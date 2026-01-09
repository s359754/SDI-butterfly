library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_CU_DATAPATH is
	port (	START:	in	STD_LOGIC;
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		INSTRUCTION_OUT:	out	STD_LOGIC_VECTOR(16 downto 0)
		);
end BFLY_CU_DATAPATH;


architecture structural of BFLY_CU_DATAPATH is 
	
	component BFLY_CU_LATE_STATUS_PLA is
	port (	STATUS: in STD_LOGIC_VECTOR(1 downto 0);
		LSB_in: in STD_LOGIC;
		CC_Validation_in: in STD_LOGIC;
		CC_Validation_out: out STD_LOGIC;
		LSB_out: out STD_LOGIC
		);
	end component;
	
	component BFLY_CU_ROM is
	generic(
		in_length: INTEGER:= 3;
		next_Address_length :INTEGER := 4;
		out_length: INTEGER:= 22
	);
	port (	A:	in	STD_LOGIC_VECTOR ((in_length-1) downto 0);
		OUT_EVEN:	out	STD_LOGIC_VECTOR((out_length-1) downto 0);
		OUT_ODD:	out	STD_LOGIC_VECTOR((out_length-1) downto 0)
		);
	end component;
	
	component FD is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	D:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		E: in STD_LOGIC;	--ENABLE attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	component MUX_2 is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	A,B:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	SIGNAL microAR_in_MSB : STD_LOGIC_VECTOR (3 downto 1) := (others=>'0');
	SIGNAL microAR_out_MSB : STD_LOGIC_VECTOR (3 downto 1)	:= (others=>'0');
	SIGNAL microAR_in_LSB : STD_LOGIC := '0';
	SIGNAL microAR_out_LSB : STD_LOGIC := '0';
	
	SIGNAL CC_mux_out : STD_LOGIC := '0';
	
	SIGNAL PLA_ROM_out_even, PLA_ROM_out_odd : STD_LOGIC_VECTOR (21 downto 0):= (others=>'0');
	
	SIGNAL PLA_ROM_mux_out : STD_LOGIC_VECTOR (21 downto 0):= (others=>'0');
	
	SIGNAL status_PLA_LSB_out : STD_LOGIC := '0';
	SIGNAL status_PLA_CC_validation_out : STD_LOGIC := '0';

	SIGNAL microIR_in : STD_LOGIC_VECTOR (21 downto 0)	:= (others=>'0');
	SIGNAL microIR_out : STD_LOGIC_VECTOR (21 downto 0)	:= (others=>'0');

	SIGNAL CC_validation : STD_LOGIC := '0';
	SIGNAL next_Address_LSB : STD_LOGIC := '0';
	SIGNAL next_Address_MSB : STD_LOGIC_VECTOR (2 downto 0) := (others=>'0');
	
	SIGNAL dp_STATUS : STD_LOGIC_VECTOR (1 downto 0) := (others=>'0');
	
	SIGNAL neg_CK : STD_LOGIC := '0';
	
	begin
	
	neg_CK <= NOT(CK);

	dp_STATUS(0) <= START;
	dp_STATUS(1) <= SF_2H_1L;

	INSTRUCTION_OUT <= microIR_out (20 downto 4);
	CC_validation <= microIR_out (21);
	next_Address_LSB <= microIR_out (0);
	
	next_Address_MSB(2 downto 0) <= microIR_out (3 downto 1);

	microAR_in_MSB <= next_Address_MSB;
	microAR_in_LSB <= status_PLA_LSB_out;

	microIR_in <= PLA_ROM_mux_out;

	--PLA
	pm_PLA : BFLY_CU_LATE_STATUS_PLA 
	port map (	
		STATUS => dp_STATUS,
		LSB_in => next_Address_LSB,
		CC_Validation_in => CC_validation,
		CC_Validation_out => status_PLA_CC_validation_out,
		LSB_out => status_PLA_LSB_out
	);

	--ROM della PLA
	pm_CU_ROM : BFLY_CU_ROM
	generic map(
		in_length => 3,
		next_Address_length => 3,
		out_length => 22
	)
	port map (	
		A => microAR_out_MSB,
		OUT_EVEN => PLA_ROM_out_even,
		OUT_ODD => PLA_ROM_out_odd
	);

	--Registro del uAR eccetto l'LSB
	pm_microAR_MSB_reg : FD
	generic map (
		bus_length => 3
	)
	port map (
		D => microAR_in_MSB,
		E => '1',
		CK => CK,
		Q => microAR_out_MSB
	);
	
	--Registro dell'LSB del uAR
	FF_D_uAR: process(CK)
	begin
		if CK'event and CK='1' then -- positive edge triggered:
			microAR_out_LSB <= microAR_in_LSB;
		end if;
	end process;
	
	--Registro del uIR
	pm_microIR_reg : FD 
	generic map (
		bus_length => 22
	)
	port map (
		D => microIR_in,
		E => '1',
		CK => neg_CK,
		Q => microIR_out
	);

	--MUX a due ingressi a 21 bit, che seleziona tra l'uscita pari o dispari della ROM
	pm_ROM_mux : MUX_2 
	generic map (
		bus_length => 22
	)
	port map (
		A => PLA_ROM_out_odd,
		B => PLA_ROM_out_even,
		S => CC_mux_out,
		Q => PLA_ROM_mux_out
	);
	
	--MUX a due ingressi a 1 bit
	--L'uscita è il segnale di select per il MUX even/odd della ROM
	CC_mux_out <= microAR_out_LSB when status_PLA_CC_validation_out = '0' else status_PLA_LSB_out;
	

end structural;



