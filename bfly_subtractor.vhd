library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_SUBTRACTOR is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		B:	in	STD_LOGIC_VECTOR (48 downto 0);
		CK:	in	STD_LOGIC;
		DIFF_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end BFLY_SUBTRACTOR;


architecture behavioral of BFLY_SUBTRACTOR is 

	signal diff: STD_LOGIC_VECTOR (48 downto 0) := (others=>'0');
	
	begin
	
	DIFF_OUT <= diff;
	
		PSYNCH: process(CK)
		begin
			if CK'event and CK='1' then -- positive edge triggered:
				diff <= std_logic_vector(signed(A)-signed(B)); 
			
			end if;
		end process;

end behavioral;



