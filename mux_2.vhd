library IEEE;
use IEEE.std_logic_1164.all; 

entity MUX_2 is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	A,B:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
end MUX_2;


architecture behavioral of MUX_2 is 

begin

	Q <= A when S = '1' else B;

end behavioral;



