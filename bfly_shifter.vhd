library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_SHIFTER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		SHIFT_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end BFLY_SHIFTER;


architecture behavioral of BFLY_SHIFTER is 

	signal SHIFT_OUT_tmp: STD_LOGIC_VECTOR (48 downto 0) := (others=>'0');
	
	begin
	
		SHIFT_OUT <= SHIFT_OUT_tmp;
	
		PSYNCH: process(CK)
		begin
			if CK'event and CK='1' then -- positive edge triggered:
				if SF_2H_1L = '1' then --scala di 2 bit
					SHIFT_OUT_tmp <= '0' & '0' & A(48 downto 2); 
				else	--scala di 1 bit
					SHIFT_OUT_tmp <= '0' & A(48 downto 1); 
				end if;
			end if;
		end process;

end behavioral;



