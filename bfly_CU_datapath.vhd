library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_CU_DATAPATH is
	port (	START:	in	STD_LOGIC;
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		INSTRUCTION_OUT:	out	STD_LOGIC_VECTOR(15 downto 0);
		DONE: out STD_LOGIC
		);
end BFLY_CU_DATAPATH;


architecture structural of BFLY_CU_DATAPATH is 
	
	component FD is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	D:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		E: in STD_LOGIC;	--ENABLE attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	entity MUX_2 is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	A,B:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end MUX_2;
	
	SIGNAL microAR_in_MSB : STD_LOGIC_VECTOR (3 downto 0) := (others=>'0');
	SIGNAL microAR_out_MSB : STD_LOGIC_VECTOR (3 downto 0)	:= (others=>'0');
	SIGNAL microAR_in_LSB : STD_LOGIC := '0';
	SIGNAL microAR_out_LSB : STD_LOGIC := '0';
	
	SIGNAL CC_mux_out : STD_LOGIC := '0';
	
	SIGNAL PLA_ROM_out_even, PLA_ROM_out_odd : STD_LOGIC_VECTOR (20 downto 0):= (others=>'0');
	
	SIGNAL PLA_ROM_mux_out : STD_LOGIC_VECTOR (20 downto 0):= (others=>'0');
	
	SIGNAL status_PLA_LSB_out : STD_LOGIC := '0';
	SIGNAL status_PLA_CC_validation_out : STD_LOGIC := '0';

	SIGNAL microIR_in : STD_LOGIC_VECTOR (20 downto 0)	:= (others=>'0');
	SIGNAL microIR_out : STD_LOGIC_VECTOR (20 downto 0)	:= (others=>'0');

	SIGNAL CC_validation : STD_LOGIC := '0';
	SIGNAL next_Address_LSB : STD_LOGIC := '0';
	SIGNAL next_Address_MSB : STD_LOGIC_VECTOR (3 downto 1) := (others=>'0');
	
	
	
	begin


	INSTRUCTION_OUT <= microIR_out (19 downto 5);
	DONE <= microIR_out (4);
	CC_validation <= microIR_out (20);
	next_Address_LSB <= microIR_out (0);
	next_Address_MSB <= microIR_out (3 downto 1);

	microAR_in_MSB <= next_Address_MSB;

	pm_microAR_MSB_reg : FD 
	generic map (
		bus_length => 3
	);
	port map (
		A => microAR_in_MSB,
		E => '1',
		CK => CK,
		Q => microAR_out_MSB
	);
	
	pm_microAR_LSB_reg
	generic map (
		bus_length => 1
	);
	port map (
		A => microAR_in_LSB,
		E => '1',
		CK => CK,
		Q => microAR_out_LSB
	);
	
	pm_microIR_reg : FD 
	generic map (
		bus_length => 21
	);
	port map (
		A => microIR_in,
		E => '1',
		CK => CK,
		Q => microIR_out
	);

	pm_ROM_mux : MUX_2 
	generic map (
		bus_length => 21
	);
	port map (
		A => PLA_ROM_out_even,
		B => PLA_ROM_out_odd,
		S => CC_mux_out,
		Q => PLA_ROM_mux_out
	);
	
	pm_CC_mux : MUX_2 
	generic map (
		bus_length => 1
	);
	port map (
		A => microAR_out_LSB,
		B => status_PLA_LSB_out,
		S => status_PLA_CC_validation_out,
		Q => CC_mux_out
	);
	

end structural;



