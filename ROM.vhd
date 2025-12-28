library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Creazione entity

entity ROM is
	port(
		address : IN std_logic_vector(4 downto 0);
		memory_out: OUT std_logic_vector(2 downto 0)
	);
end entity;

-- Architecture della ROM

architecture ROM_rounding of ROM is

	-- Spazio per segnali interni

begin

selection: process(address)
begin

if address = "00000" then
	memory_out <= "000";
elsif address = "00001" then
	memory_out <= "000";
elsif address = "00010" then
	memory_out <= "000";
elsif address = "00011" then
	memory_out <= "001";
elsif address = "00100" then
	memory_out <= "001";
elsif address = "00101" then
	memory_out <= "001";
elsif address = "00110" then
	memory_out <= "010";
elsif address = "00111" then
	memory_out <= "010";
elsif address = "01000" then
	memory_out <= "010";
elsif address = "01001" then
	memory_out <= "010";
elsif address = "01010" then
	memory_out <= "010";
elsif address = "01011" then
	memory_out <= "011";
elsif address = "01100" then	
	memory_out <= "011";
elsif address = "01101" then
	memory_out <= "011";
elsif address = "01110" then
	memory_out <= "100";
elsif address = "01111" then
	memory_out <= "100";
elsif address = "10000" then
	memory_out <= "100";
elsif address = "10001" then
	memory_out <= "100";
elsif address = "10010" then
	memory_out <= "100";
elsif address = "10011" then
	memory_out <= "101";
elsif address = "10100" then
	memory_out <= "101";
elsif address = "10101" then
	memory_out <= "101";
elsif address = "10110" then
	memory_out <= "110";
elsif address = "10111" then
	memory_out <= "110";
elsif address = "11000" then
	memory_out <= "110";
elsif address = "11001" then
	memory_out <= "110";
elsif address = "11010" then
	memory_out <= "110";
elsif address = "11011" then
	memory_out <= "111";
elsif address = "11100" then
	memory_out <= "111";
elsif address = "11101" then
	memory_out <= "111";
elsif address = "11110" then
	memory_out <= "111";
elsif address = "11111" then
	memory_out <= "111";
end if;

end process;

end architecture ROM_rounding;