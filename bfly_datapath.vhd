
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity bfly_datapath is
port( 
	Br_in, Bi_in, Ar_in, Ai_in, Wr_in, Wi_in : in STD_LOGIC_VECTOR (23 downto 0);
	Clock, START, SF_2H_1L : in STD_LOGIC;
	Br_out, Bi_out, Ar_out, Ai_out : out STD_LOGIC_VECTOR (23 downto 0);
	DONE : out STD_LOGIC
);
end	bfly_datapath;

---------------------------------------------

architecture structural of bfly_datapath is
	
	--====================================================================================================---
	--Inizializzazione componenti
	--====================================================================================================---
	
	--Multiplier
	component BFLY_MULTIPLIER is
	port (	A:	in	STD_LOGIC_VECTOR (23 downto 0);
		B:	in	STD_LOGIC_VECTOR (23 downto 0);
		SHIFT: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		S_OUT:	out	STD_LOGIC_VECTOR(48 downto 0);
		M_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
	end component;
	
	--Adder
	component BFLY_ADDER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		B:	in	STD_LOGIC_VECTOR (48 downto 0);
		CK:	in	STD_LOGIC;
		SUM_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
	end component;

	--Sottrattore
	component BFLY_SUBTRACTOR is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		B:	in	STD_LOGIC_VECTOR (48 downto 0);
		CK:	in	STD_LOGIC;
		DIFF_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
	end component;
	
	--Registro FF con enable
	component FD is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	D:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		E: in STD_LOGIC;	--ENABLE attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	--Flip Flop di tipo T con reset sincrono attivo alto
	component T_FF is
	port (	T:	in	STD_LOGIC;
		R: in STD_LOGIC;	--RESET attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC);
	end component;

	--Multiplexer a tre ingressi con due bit di select
	component MUX_3 is
	generic(
		bus_length: INTEGER:= 49
	);
	port (	A,B,C:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC_VECTOR (1 downto 0);	
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	--Multiplexer a due ingressi con un bit di select
	component MUX_2 is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	A,B:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	--Blocco unico di shift a destra e rom rounding
	component rounding is
	port(
		Clock:	IN	STD_LOGIC; -- Clock
		rounding_in : IN std_logic_vector(48 downto 0); -- 49 bit da arrotondare
		rounding_out: OUT std_logic_vector(23 downto 0); -- 24 bit arrotondati
		shift_signal: IN STD_LOGIC -- segnale per shiftare
	);
	end component;
	
	--Control Unit
	component BFLY_CU_DATAPATH is
	port (	START:	in	STD_LOGIC;
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		INSTRUCTION_OUT:	out	STD_LOGIC_VECTOR(16 downto 0)
		);
	end component;
	
	
	--====================================================================================================---
	--Dichiarazione segnali datapath
	--====================================================================================================---
	
	--Segnali uIR
	SIGNAL dp_SHIFT_SIGNAL, dp_REG_IN, dp_SUM_REG, dp_AR_SEL, dp_BR_SEL, dp_WR_SEL, dp_MS_DIFFp, dp_AS_SUM_SEL, dp_SD_ROUND_SEL, dp_SHIFT, dp_SF_2H_1L, dp_REG_RND_BR, dp_REG_RND_BI, dp_REG_RND_AR, dp_REG_RND_AI, dp_DONE : STD_LOGIC := '0';
	SIGNAL dp_MSD_DIFFm	: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	SIGNAL dp_INSTRUCTION_OUT : STD_LOGIC_VECTOR (16 downto 0) := (others => '0');
	
	--Ingressi al MUX di Br/Bi
	SIGNAL dp_Br_MUX_in, dp_Bi_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	--Ingressi al MUX di Ar/Ai
	SIGNAL dp_Ar_MUX_in, dp_Ai_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	--Ingressi al MUX di Wr/Wi
	SIGNAL dp_Wr_MUX_in, dp_Wi_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	
	--Uscite dei MUX di B, A e W
	SIGNAL dp_B_MUX_out, dp_A_MUX_out, dp_W_MUX_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	
	--Uscite e ingressi del multiplier
	SIGNAL dp_X_MPY_in, dp_Y_MPY_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	SIGNAL dp_MPY_product_out, dp_MPY_shift_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0'); 
	
	--Uscita e ingressi dell'adder
	SIGNAL dp_SUM_out, dp_X_SUM_in, dp_Y_SUM_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0'); 
	
	--Uscita e ingressi del sottrattore
	SIGNAL dp_DIFF_out, dp_X_DIFF_in, dp_Y_DIFF_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del registro di pipe della somma
	SIGNAL dp_SUM_reg_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del registro di pipe del sottrattore
	SIGNAL dp_DIFF_reg_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del registro di pipe del prodotto e dello shift
	SIGNAL dp_MPY_M_reg_out, dp_MPY_S_reg_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Ingresso 1 del multiplexer in entrata al sommatore, ovvero l'uscita del MUX di Ar/Ai con zeri aggiunti
	SIGNAL dp_AS_A_MUX_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	--Uscita del multiplexer in entrata al sommatore
	SIGNAL dp_AS_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');

	--Uscita del MUX A/B in ingresso al multiplier
	SIGNAL dp_AB_MUX_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');

	--Uscita del MUX dell'ingresso positivo del sottrattore
	SIGNAL dp_MS_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del MUX dell'ingresso negativo del sottrattore
	SIGNAL dp_MSD_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del MUX dell'ingresso dello shifter a destra
	SIGNAL dp_SD_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del blocco shift + rom rounding
	SIGNAL dp_ROM_round_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	
	begin
	
	--====================================================================================================---
	--Port map dei registri a 24 bit
	--====================================================================================================---
	
	pm_regin_Br : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Br_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Br_MUX_in
	);
	
	pm_regin_Bi : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Bi_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Bi_MUX_in
	);
	
	pm_regin_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Ar_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Ar_MUX_in
	);
	
	pm_regin_Ai : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Ai_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Ai_MUX_in
	);
	
	pm_regin_Wr : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Wr_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Wr_MUX_in
	);
	
	pm_regin_Wi : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Wi_in,
			E => dp_REG_IN,
			CK => Clock,
			Q => dp_Wi_MUX_in
	);
	
	--====================================================================================================---
	--Port map dei Multiplexer a due ingressi
	--====================================================================================================---
	
	pm_mux_B : MUX_2 
	generic map (
		bus_length => 24
	)
	port map (
		A => dp_Br_MUX_in,
		B => dp_Bi_MUX_in,
		S => dp_BR_SEL,
		Q => dp_B_MUX_out
	);
	
	pm_mux_A : MUX_2 
	generic map (
		bus_length => 24
	)
	port map (
		A => dp_Ar_MUX_in,
		B => dp_Ai_MUX_in,
		S => dp_AR_SEL,
		Q => dp_A_MUX_out
	);
	
	pm_mux_W : MUX_2 
	generic map (
		bus_length => 24
	)
	port map (
		A => dp_Wr_MUX_in,
		B => dp_Wi_MUX_in,
		S => dp_WR_SEL,
		Q => dp_W_MUX_out
	);
	
	pm_mux_Mult : MUX_2 	--Multiplexer del multiplier
	generic map (
		bus_length => 24
	)
	port map (
		A => dp_A_MUX_out,
		B => dp_B_MUX_out,
		S => dp_SHIFT,
		Q => dp_AB_MUX_out
	);
	
	--Ingresso 1 del multiplexer in entrata al sommatore, ovvero l'uscita del MUX di Ar/Ai
	dp_AS_A_MUX_in (48 downto 24) <= (others => '0');	--Aggiungo zeri perché l'uscita del MUX di Ar/Ai è solo su 24 bit
	dp_AS_A_MUX_in (23 downto 0) <= dp_A_MUX_out;
	
	pm_mux_Adder : MUX_2 	--Multiplexer dell'adder
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_AS_A_MUX_in,	--l'uscita del MUX Ar/Ai
		B => dp_SUM_reg_out,	--l'uscita del sommatore rallentata di un colpo di Clock
		S => dp_AS_SUM_SEL,
		Q => dp_AS_MUX_out
	);
	
	pm_mux_Sub_plus : MUX_2 	--Multiplexer dell'ingresso positivo del sottrattore
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_MPY_S_reg_out,	--l'uscita SHIFT del moltiplicatore
		B => dp_SUM_reg_out,	--l'uscita del sommatore rallentata di un colpo di Clock
		S => dp_MS_DIFFp,
		Q => dp_MS_MUX_out
	);
	
	pm_mux_rshift : MUX_2 	--Multiplexer dell'ingresso allo shifter a destra
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_SUM_reg_out,		--l'uscita del sommatore
		B => dp_DIFF_reg_out,	--l'uscita del sottrattore
		S => dp_SD_ROUND_SEL,
		Q => dp_SD_MUX_out
	);
	
	--Port map del MUX a tre ingressi
	pm_mux_Sub_minus : MUX_3 	--Multiplexer dell'ingresso negativo del sottrattore
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_MPY_M_reg_out,			--l'uscita MPY del moltiplicatore rallentata di un colpo di Clock
		B => dp_SUM_reg_out,			--l'uscita del sommatore rallentata di un colpo di Clock
		C => dp_DIFF_reg_out,			--l'uscita del sottrattore rallentata di un colpo di Clock
		S => dp_MSD_DIFFm,
		Q => dp_MSD_MUX_out
	);
	
	--====================================================================================================---
	--Port map degli operatori
	--====================================================================================================---
	
	dp_X_MPY_in <= dp_AB_MUX_out;	--L'ingresso 1 del multiplier è connesso all'uscita del multiplexer A/B
	dp_Y_MPY_in <= dp_W_MUX_out;	--L'ingresso 2 del multiplier è connesso all'uscita del multiplexer Wr/Wi
	
	pm_Multiplier : BFLY_MULTIPLIER	--Port map del multiplier
	port map (
		A => dp_X_MPY_in,
		B => dp_Y_MPY_in,
		SHIFT => dp_SHIFT,
		CK => Clock,
		M_OUT => dp_MPY_product_out,
		S_OUT => dp_MPY_shift_out
	);
	
	dp_X_SUM_in <= dp_AS_MUX_out;		--L'ingresso 1 dell'adder è connesso all'uscita del multiplexer A/Somma
	dp_Y_SUM_in <= dp_MPY_M_reg_out;	--L'ingresso 2 dell'adder è connesso all'uscita moltiplicazione del multiplier
	
	pm_Adder : BFLY_ADDER	--Port map dell'adder
	port map (
		A => dp_X_SUM_in,
		B => dp_Y_SUM_in,
		CK => Clock,
		SUM_OUT => dp_SUM_out
	);
	
	dp_X_DIFF_in <= dp_MS_MUX_out;
	dp_Y_DIFF_in <= dp_MSD_MUX_out;
	
	pm_Subractor : BFLY_SUBTRACTOR	--Port map del sottrattore
	port map (
		A => dp_X_DIFF_in,
		B => dp_Y_DIFF_in,
		CK => Clock,
		DIFF_OUT => dp_DIFF_out
	);
		
	pm_ft_shift : T_FF	--Port map del flip flop T che ha come uscita il segnale di SF_2H_1L per il blocco rounding
	port map (
		T => dp_SHIFT_SIGNAL,	--Segnale che viene dalla CU
		R => dp_DONE,			--Segnale che viene dalla CU
		CK => Clock,
		Q => dp_SF_2H_1L
	);
		
	pm_rounding : rounding	--Port map del blocco unico shifter a destra e ROM rounding
	port map (
		Clock => Clock,
		rounding_in => dp_SD_MUX_out,
		rounding_out => dp_ROM_round_out,
		shift_signal => dp_SF_2H_1L
	);
	
	pm_CU : BFLY_CU_DATAPATH	--Port map della Control unit
	port map (
		START => START,
		SF_2H_1L => SF_2H_1L,
		CK => Clock,
		INSTRUCTION_OUT => dp_INSTRUCTION_OUT
	);
	
	--Segnali della parte di istruzione del uIR della CU
	dp_SHIFT_SIGNAL <= dp_INSTRUCTION_OUT(16);
	dp_REG_IN <= dp_INSTRUCTION_OUT(15);
	dp_SUM_REG <= dp_INSTRUCTION_OUT(14);
	dp_AR_SEL <= dp_INSTRUCTION_OUT(13);
	dp_BR_SEL <= dp_INSTRUCTION_OUT(12);
	dp_WR_SEL <= dp_INSTRUCTION_OUT(11);
	dp_MS_DIFFp <= dp_INSTRUCTION_OUT(10);
	dp_MSD_DIFFm <= dp_INSTRUCTION_OUT(9 downto 8);
	dp_AS_SUM_SEL <= dp_INSTRUCTION_OUT(7);
	dp_SD_ROUND_SEL <= dp_INSTRUCTION_OUT(6);
	dp_REG_RND_BR <= dp_INSTRUCTION_OUT(5);
	dp_REG_RND_BI <= dp_INSTRUCTION_OUT(4);
	dp_REG_RND_AR <= dp_INSTRUCTION_OUT(3);
	dp_REG_RND_AI <= dp_INSTRUCTION_OUT(2);
	dp_SHIFT <= dp_INSTRUCTION_OUT(1);
	dp_DONE <= dp_INSTRUCTION_OUT(0);
	
	DONE <= dp_DONE;
	
	
	--====================================================================================================---
	--Port map dei registri a 49 bit
	--====================================================================================================---
	
	pm_reg_MPY_product_out : FD	--Port map del registro all'uscita prodotto del multiplier
		generic map (
			bus_length => 49
		)
		port map (
			D => dp_MPY_product_out,
			E => '1',
			CK => Clock,
			Q => dp_MPY_M_reg_out
	);
	
	pm_reg_MPY_shift_out : FD	--Port map del registro all'uscita shift del multiplier
		generic map (
			bus_length => 49
		)
		port map (
			D => dp_MPY_shift_out,
			E => '1',
			CK => Clock,
			Q => dp_MPY_S_reg_out
	);
	
	pm_reg_SUM_out : FD	--Port map del registro all'uscita del sommatore
		generic map (
			bus_length => 49
		)
		port map (
			D => dp_SUM_out,
			E => '1',
			CK => Clock,
			Q => dp_SUM_reg_out
	);
	
	pm_reg_DIFF_out : FD	--Port map del registro all'uscita del sottrattore
		generic map (
			bus_length => 49
		)
		port map (
			D => dp_DIFF_out,
			E => '1',
			CK => Clock,
			Q => dp_DIFF_reg_out
	);
	
	--====================================================================================================---
	--Port map dei registri di uscita a 24 bit
	--====================================================================================================---
	
	pm_regout_Br : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_ROM_round_out,
			E => dp_REG_RND_BR,
			CK => Clock,
			Q => Br_out
	);
	
	pm_regout_Bi : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_ROM_round_out,
			E => dp_REG_RND_BI,
			CK => Clock,
			Q => Bi_out
	);
	
	pm_regout_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_ROM_round_out,
			E => dp_REG_RND_AR,
			CK => Clock,
			Q => Ar_out
	);
	
	pm_regout_Ai : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_ROM_round_out,
			E => dp_REG_RND_AI,
			CK => Clock,
			Q => Ai_out
	);
	
end structural;
 
