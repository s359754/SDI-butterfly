library IEEE;
use IEEE.std_logic_1164.all; 

entity MUX_3 is
	generic(
		bus_length: INTEGER:= 49
	);
	port (	A,B,C:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		S: in STD_LOGIC_VECTOR (1 downto 0);	
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
end MUX_3;


architecture behavioral of MUX_3 is

begin

	p_mux: process (S, A, B, C)
	begin
	case S is
		when "00" => 
			Q <= A;
		when "01" => 
			Q <= B;
		when "10" => 
			Q <= C;
		when "11" => 
			Q <= (others=>'0');
		when others => 
			Q <= (others=>'0');
	end case;
	end process;

end behavioral;



