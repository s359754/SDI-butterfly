
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity bfly_rounding_rom is
generic(
	address_length: INTEGER := 4;
	data_length: INTEGER := 16
);
port( CLOCK : in STD_LOGIC;
	A: in STD_LOGIC_VECTOR ((address_length-1) downto 0);
	DOUT: out STD_LOGIC_VECTOR ((data_length-1) downto 0);
	DIN: in STD_LOGIC_VECTOR ((data_length-1) downto 0);
	OE: in STD_LOGIC
);
end	bfly_rounding_rom;

---------------------------------------------

architecture behavioral of bfly_rounding_rom is

	type memory_array is array (0 to (2**(address_length) -1)) of STD_LOGIC_VECTOR((data_length-1) downto 0);
	
	signal mem : memory_array := (others => ("0000000000000111"));
	
	begin

	P_OPC: process (CLOCK) is
	begin
		if (CLOCK='1' and CLOCK'EVENT) then 
			if (RD = '1' and WR = '0') then
				DOUT <= mem(to_integer(unsigned(A)));
			end if;
			if (RD = '0' and WR = '1') then
				mem(to_integer(unsigned(A))) <= DIN;
			end if;
		end if;
	end process P_OPC;

end behavioral;
 
