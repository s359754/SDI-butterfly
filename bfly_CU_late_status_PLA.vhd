library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_CU_LATE_STATUS_PLA is
	port (	STATUS: in STD_LOGIC_VECTOR(1 downto 0);
		LSB_in: in STD_LOGIC;
		CC_Validation_in: in STD_LOGIC;
		CC_Validation_out: out STD_LOGIC;
		LSB_out: out STD_LOGIC
		);
end BFLY_CU_LATE_STATUS_PLA;


architecture behavioral of BFLY_CU_LATE_STATUS_PLA is 
	
	SIGNAL START, SF_2H_1L : STD_LOGIC := '0';
	
	begin
	
		START <= STATUS(0);
		SF_2H_1L <= STATUS(1);

		LSB_out <= (CC_Validation_in AND (NOT LSB_in)) OR (CC_Validation_in AND SF_2H_1L) OR ((NOT LSB_in) AND START);
		CC_Validation_out <= NOT(LSB_in);

end behavioral;
