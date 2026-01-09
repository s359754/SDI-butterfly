library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_CU_ROM is
	generic(
		in_length: INTEGER:= 3;
		next_Address_length :INTEGER := 3;
		out_length: INTEGER:= 22
	);
	port (	A:	in	STD_LOGIC_VECTOR ((in_length-1) downto 0);
		OUT_EVEN:	out	STD_LOGIC_VECTOR((out_length-1) downto 0);
		OUT_ODD:	out	STD_LOGIC_VECTOR((out_length-1) downto 0)
		);
end BFLY_CU_ROM;


architecture behavioral of BFLY_CU_ROM is 
	
	SIGNAL out_tmp_even, out_tmp_odd : STD_LOGIC_VECTOR ((out_length-1) downto 0) := (others=>'0');
	SIGNAL next_Address_even, next_Address_odd : STD_LOGIC_VECTOR ((next_Address_length-1) downto 0) := (others=>'0');
	
	SIGNAL REG_IN_even, SUM_REG_even, AR_SEL_even, BR_SEL_even, WR_SEL_even, MS_DIFFp_even, AS_SUM_SEL_even, SD_ROUND_SEL_even, REG_RND_BR_even, REG_RND_BI_even, REG_RND_AR_even, REG_RND_AI_even, SHIFT_even, DONE_even : STD_LOGIC := '0';
	SIGNAL REG_IN_odd, SUM_REG_odd, AR_SEL_odd, BR_SEL_odd, WR_SEL_odd, MS_DIFFp_odd, AS_SUM_SEL_odd, SD_ROUND_SEL_odd, REG_RND_BR_odd, REG_RND_BI_odd, REG_RND_AR_odd, REG_RND_AI_odd, SHIFT_odd, DONE_odd : STD_LOGIC := '0';
	SIGNAL SF_2H_1L_even, SF_2H_1L_odd : STD_LOGIC := '0';
	
	
	SIGNAL MSD_DIFFm_even, MSD_DIFFm_odd : STD_LOGIC_VECTOR (1 downto 0) := "00";
	
	SIGNAL CC_Validation_even, CC_Validation_odd : STD_LOGIC := '0';
		
	begin

	OUT_EVEN <= out_tmp_even;
	OUT_ODD <= out_tmp_odd;


	--CC validation
	out_tmp_even(21) <= CC_Validation_even;

	--Instruction part
	out_tmp_even(20) <= SF_2H_1L_even;
	out_tmp_even(19) <= REG_IN_even;
	out_tmp_even(18) <= SUM_REG_even;
	out_tmp_even(17) <= AR_SEL_even;
	out_tmp_even(16) <= BR_SEL_even;
	out_tmp_even(15) <= WR_SEL_even;
	out_tmp_even(14) <= MS_DIFFp_even;
	out_tmp_even(13 downto 12) <= MSD_DIFFm_even;
	out_tmp_even(11) <= AS_SUM_SEL_even;
	out_tmp_even(10) <= SD_ROUND_SEL_even;
	out_tmp_even(9) <= REG_RND_BR_even;
	out_tmp_even(8) <= REG_RND_BI_even;
	out_tmp_even(7) <= REG_RND_AR_even;
	out_tmp_even(6) <= REG_RND_AI_even;
	out_tmp_even(5) <= SHIFT_even;
	out_tmp_even(4) <= DONE_even;

	--Next address
	out_tmp_even((next_Address_length) downto 1) <= next_Address_even;
	out_tmp_even(0) <= '0';




	--CC validation
	out_tmp_odd(21) <= CC_Validation_odd;

	--Instruction part
	out_tmp_odd(20) <= SF_2H_1L_odd;
	out_tmp_odd(19) <= REG_IN_odd;
	out_tmp_odd(18) <= SUM_REG_odd;
	out_tmp_odd(17) <= AR_SEL_odd;
	out_tmp_odd(16) <= BR_SEL_odd;
	out_tmp_odd(15) <= WR_SEL_odd;
	out_tmp_odd(14) <= MS_DIFFp_odd;
	out_tmp_odd(13 downto 12) <= MSD_DIFFm_odd;
	out_tmp_odd(11) <= AS_SUM_SEL_odd;
	out_tmp_odd(10) <= SD_ROUND_SEL_odd;
	out_tmp_odd(9) <= REG_RND_BR_odd;
	out_tmp_odd(8) <= REG_RND_BI_odd;
	out_tmp_odd(7) <= REG_RND_AR_odd;
	out_tmp_odd(6) <= REG_RND_AI_odd;
	out_tmp_odd(5) <= SHIFT_odd;
	out_tmp_odd(4) <= DONE_odd;

	--Next address
	out_tmp_odd((next_Address_length) downto 1) <= next_Address_odd;
	out_tmp_odd(0) <= '1';

	p_rom : process (A)
	begin
		if A = "000" then					--IDLE / START

			--IDLE
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '0';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "000";
			
			--START
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '1';
			REG_IN_odd <= '1';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "001";
			

		elsif A = "001" then 					--M1,SH0 / M1,SH1
			
			--M1, SH0
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '0';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '1';
			WR_SEL_even <= '1';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "010";
			
			--M1, SH1
			SF_2H_1L_odd <= '1';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '1';
			WR_SEL_odd <= '1';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "010";
			
			
		elsif A = "010" then 					--M2 / M3
		
			--M2
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '1';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '1';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "010";
			
			--M3
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "011";
			
			
		elsif A = "011" then 					--M4,S1 / S2

			--M4, S1
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '1';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '1';
			BR_SEL_even <= '0';
			WR_SEL_even <= '1';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '1';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "011";
			
			--S2
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '1';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "100";
			
			
		elsif A = "100" then  					--M5,D1 / M6,S3
			
			--M5, D1
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '1';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '1';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '1';
			DONE_even <= '0';
			next_Address_even <= "100";
			
			--M6, S3
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";		--Product
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '1';
			DONE_odd <= '0';
			next_Address_odd <= "101";
			
			
		elsif A = "101" then  					--D2,SH1 / D3,SH2
			
			--D2, SH1
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '1';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '1';
			MSD_DIFFm_even <= "10";		--Difference
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "101";
			
			--D3, SH2
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '1';
			MSD_DIFFm_odd <= "01";		--Sum
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '1';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '1';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "110";
			
			
		elsif A = "110" then  					--SH3 / SH4
			
			--SH3
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '1';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '1';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "110";
			
			--SH4
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '1';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "111";
			
			
		elsif A = "111" then  					--DONE
			
			--DONE
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '0';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '1';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '1';
			next_Address_even <= "000";
			
			--UNUSED
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "000";
		
		else 
		
			--DONE
			SF_2H_1L_even <= '0';
			CC_Validation_even <= '0';
			REG_IN_even <= '0';
			SUM_REG_even <= '0';
			AR_SEL_even <= '0';
			BR_SEL_even <= '0';
			WR_SEL_even <= '0';
			MS_DIFFp_even <= '0';
			MSD_DIFFm_even <= "00";
			AS_SUM_SEL_even <= '0';
			SD_ROUND_SEL_even <= '0';
			REG_RND_BR_even <= '0';
			REG_RND_BI_even <= '0';
			REG_RND_AR_even <= '0';
			REG_RND_AI_even <= '0';
			SHIFT_even <= '0';
			DONE_even <= '0';
			next_Address_even <= "000";
			
			SF_2H_1L_odd <= '0';
			CC_Validation_odd <= '0';
			REG_IN_odd <= '0';
			SUM_REG_odd <= '0';
			AR_SEL_odd <= '0';
			BR_SEL_odd <= '0';
			WR_SEL_odd <= '0';
			MS_DIFFp_odd <= '0';
			MSD_DIFFm_odd <= "00";
			AS_SUM_SEL_odd <= '0';
			SD_ROUND_SEL_odd <= '0';
			REG_RND_BR_odd <= '0';
			REG_RND_BI_odd <= '0';
			REG_RND_AR_odd <= '0';
			REG_RND_AI_odd <= '0';
			SHIFT_odd <= '0';
			DONE_odd <= '0';
			next_Address_odd <= "000";
			
	end if;
	end process;


end behavioral;



