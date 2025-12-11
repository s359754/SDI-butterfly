library IEEE;
use IEEE.std_logic_1164.all; 

entity FD is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	D:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		E: in STD_LOGIC;	--ENABLE attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
end FD;


architecture behavioral of FD is -- flip flop D

	signal q_temp : STD_LOGIC_VECTOR ((bus_length-1) downto 0) := (others=>'0');

begin

	Q <= q_temp;
	PSYNCH: process(CK)
	begin
		if CK'event and CK='1' then -- positive edge triggered:
			q_temp <= D;
		end if;
	end process;

end behavioral;



