library IEEE;
use IEEE.std_logic_1164.all; 

entity T_FF is
	port (	T:	in	STD_LOGIC;
		R: in STD_LOGIC;	--RESET attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC);
end T_FF;


architecture behavioral of T_FF is -- flip flop T

	signal q_temp : STD_LOGIC := '0';

begin

	Q <= q_temp;
	PSYNCH: process(CK)
	begin
		if CK'event and CK='1' then -- positive edge triggered:
			if R = '1' then
				q_temp <= '0';
			elsif T = '1' then
				q_temp <= NOT (q_temp);
			end if;
		end if;
	end process;

end behavioral;



