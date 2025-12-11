library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_ADDER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		B:	in	STD_LOGIC_VECTOR (48 downto 0);
		CK:	in	STD_LOGIC;
		SUM_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end BFLY_ADDER;


architecture behavioral of BFLY_ADDER is 

	signal sum: STD_LOGIC_VECTOR (48 downto 0) := (others=>'0');
	
	begin
	
	sum <= std_logic_vector(signed(A)+signed(B)); 

		PSYNCH: process(CK)
		begin
			if CK'event and CK='1' then -- positive edge triggered:
				SUM_OUT <= sum;
			
			end if;
		end process;

end behavioral;



