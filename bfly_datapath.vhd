
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity fmc_datapath is
port( 
	Br_in, Bi_in, Ar_in, Ai_in, Wr_in, Wi_in : in STD_LOGIC_VECTOR (23 downto 0);
	Clock : in STD_LOGIC;
	Br_out, Bi_out, Ar_out, Ai_out : out STD_LOGIC_VECTOR (23 downto 0)
);
end	fmc_datapath;

---------------------------------------------

architecture structural of fmc_datapath is
	
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
	
	--Shifter a destra di uno o due bit
	component BFLY_SHIFTER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		SHIFT_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
	end component;
	
	--====================================================================================================---
	--Dichiarazione segnali datapath
	--====================================================================================================---
	
	--Segnali FSM
	SIGNAL dp_REG_BR_WR, dp_REG_BI_AR, dp_REG_WI, dp_REG_AI, dp_SUM_REG, dp_AR_SEL, dp_BR_SEL, dp_WR_SEL, dp_SM_DIFFp, dp_AS_SUM_SEL, dp_SD_ROUND_SEL, dp_SHIFT, dp_SF_2H_1L : STD_LOGIC := '0';
	SIGNAL dp_MSD_DIFFm	: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	
	--Ingressi al MUX di Br/Bi
	SIGNAL dp_Br_MUX_in, dp_Bi_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	--Ingressi al MUX di Ar/Ai
	SIGNAL dp_Ar_MUX_in, dp_Ai_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	--Ingressi al MUX di Wr/Wi
	SIGNAL dp_Wr_MUX_in, dp_Wi_MUX_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	
	--Uscite dei MUX di B, A e W
	SIGNAL dp_B_MUX_out, dp_A_MUX_out, dp_W_MUX_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	
	--Ingressi ai registri di pipe di ingresso di Ar e Ai
	SIGNAL dp_Ar_reg2_in, dp_Ar_reg3_in, dp_Ar_reg4_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	SIGNAL dp_Ai_reg2_in, dp_Ai_reg3_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	
	--Uscite e ingressi del multiplier
	SIGNAL dp_X_MPY_in, dp_Y_MPY_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0'); 
	SIGNAL dp_MPY_product_out, dp_MPY_shift_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0'); 
	
	--Uscita e ingressi dell'adder
	SIGNAL dp_SUM_out, dp_X_SUM_in, dp_Y_SUM_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0'); 
	
	--Uscita e ingressi del sottrattore
	SIGNAL dp_DIFF_out, dp_X_DIFF_in, dp_Y_DIFF_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del registro di pipe della somma
	SIGNAL dp_SUM_reg_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Ingresso 1 del multiplexer in entrata al sommatore, ovvero l'uscita del MUX di Ar/Ai con zeri aggiunti
	SIGNAL dp_AS_A_MUX_in : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	--Uscita del multiplexer in entrata al sommatore
	SIGNAL dp_AS_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');

	--Uscita del MUX A/B in ingresso al multiplier
	SIGNAL dp_AB_MUX_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');

	--Uscita del MUX dell'ingresso positivo del sottrattore
	SIGNAL dp_SM_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del MUX dell'ingresso negativo del sottrattore
	SIGNAL dp_MSD_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del MUX dell'ingresso dello shifter a destra
	SIGNAL dp_SD_MUX_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita dello Shifter
	SIGNAL dp_SHIFT_out : STD_LOGIC_VECTOR (48 downto 0) := (others => '0');
	
	--Uscita del rom rounding
	SIGNAL dp_ROM_round_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	
	begin
	
	--====================================================================================================---
	--Port map dei registri a 24 bit
	--====================================================================================================---
	
	pm_reg1_Br : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Br_in,
			E => dp_REG_BR_WR,
			CK => Clock,
			Q => dp_Br_MUX_in
	);
	
	pm_reg1_Bi : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Bi_in,
			E => dp_REG_BI_AR,
			CK => Clock,
			Q => dp_Bi_MUX_in
	);
	
	pm_reg1_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Ar_in,
			E => '1',
			CK => Clock,
			Q => dp_Ar_reg2_in
	);
	
	pm_reg2_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_Ar_reg2_in,
			E => '1',
			CK => Clock,
			Q => dp_Ar_reg3_in
	);
	
	pm_reg3_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_Ar_reg3_in,
			E => '1',
			CK => Clock,
			Q => dp_Ar_reg4_in
	);
	
	pm_reg4_Ar : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_Ar_reg3_in,
			E => dp_REG_BI_AR,
			CK => Clock,
			Q => dp_Ar_reg4_in
	);
	
	pm_reg1_Ai : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => Ai_in,
			E => '1',
			CK => Clock,
			Q => dp_Ai_reg2_in
	);
	
	pm_reg2_Ai : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_Ai_reg2_in,
			E => '1',
			CK => Clock,
			Q => dp_Ai_reg3_in
	);
	
	pm_reg3_Ai : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => dp_Ai_reg3_in,
			E => dp_REG_AI,
			CK => Clock,
			Q => dp_Ai_MUX_in
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
		A => dp_MPY_shift_out,	--l'uscita SHIFT del moltiplicatore
		B => dp_SUM_reg_out,	--l'uscita del sommatore rallentata di un colpo di Clock
		S => dp_SM_DIFFp,
		Q => dp_SM_MUX_out
	);
	
	pm_mux_rshift : MUX_2 	--Multiplexer dell'ingresso allo shifter a destra
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_SUM_out,		--l'uscita del sommatore
		B => dp_DIFF_out,	--l'uscita del sottrattore
		S => dp_SD_ROUND_SEL,
		Q => dp_SD_MUX_out
	);
	
	--Port map del MUX a tre ingressi
	pm_mux_Sub_minus : MUX_3 	--Multiplexer dell'ingresso negativo del sottrattore
	generic map (
		bus_length => 49
	)
	port map (
		A => dp_MPY_product_out,		--l'uscita MPY del moltiplicatore 
		B => dp_SUM_reg_out,			--l'uscita del sommatore rallentata di un colpo di Clock
		C => dp_DIFF_out,				--l'uscita del sottrattore
		S => dp_MSD_DIFFm,
		Q => dp_DIFF_out
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
	dp_Y_SUM_in <= dp_MPY_product_out;	--L'ingresso 2 dell'adder è connesso all'uscita moltiplicazione del multiplier
	
	pm_Adder : BFLY_ADDER	--Port map dell'adder
	port map (
		A => dp_X_SUM_in,
		B => dp_Y_SUM_in,
		CK => Clock,
		SUM_OUT => dp_SUM_out
	);
	
	dp_X_DIFF_in <= dp_SM_MUX_out;
	dp_Y_DIFF_in <= dp_MSD_MUX_out;
	
	pm_Subractor : BFLY_SUBTRACTOR	--Port map del sottrattore
	port map (
		A => dp_X_DIFF_in,
		B => dp_Y_DIFF_in,
		CK => Clock,
		DIFF_OUT => dp_DIFF_out
	);
	
	pm_rshift: BFLY_SHIFTER		--Port map dello shifter a destra
	port map (
		A => dp_SD_MUX_out,		--L'ingresso dello shifter è l'uscita del multiplexer Somma/Differenza
		SF_2H_1L => dp_SF_2H_1L,
		CK => Clock,
		SHIFT_OUT => dp_SHIFT_out
	);
	
	--rom rounding
	--pm_rom_round : 
	--port map(
		
	--);
	
	Br_out <= dp_ROM_round_out;
	Bi_out <= dp_ROM_round_out;
	Ar_out <= dp_ROM_round_out;
	Ai_out <= dp_ROM_round_out;
	
end structural;
 
