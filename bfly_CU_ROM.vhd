library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_CU_ROM is
	generic(
		in_length: INTEGER:= 3,
		next_Address_length :INTEGER := 4
		out_length: INTEGER:= 21
	);
	port (	A:	in	STD_LOGIC_VECTOR ((in_length-1) downto 0);
		OUT_EVEN:	out	STD_LOGIC_VECTOR((out_length-1) downto 0);
		OUT_ODD:	out	STD_LOGIC_VECTOR((out_length-1) downto 0);
		);
end BFLY_CU_ROM


architecture behavioral of BFLY_CU_ROM is 
	
	SIGNAL out_temp : STD_LOGIC_VECTOR ((out_length-2) downto 0) := (others=>'0');
	SIGNAL next_Address : STD_LOGIC_VECTOR ((next_Address_length-1) downto 0) := (others=>'0');
	
	SIGNAL REG_IN, SUM_REG, AR_SEL, BR_SEL, WR_SEL, SM_DIFFp, MSD_DIFFm, AS_SUM_SEL, SD_ROUND_SEL, REG_RND_BR, REG_RND_BI, REG_RND_AR, REG_RND_AI, SHIFT, DONE : STD_LOGIC := '0';
	
	SIGNAL CC_Validation : STD_LOGIC := '0';
	
	
	begin

	--CC validation
	out_tmp_even(20) <= CC_Validation;

	--Instruction part
	out_tmp_even(19) <= REG_IN;
	out_tmp_even(18) <= SUM_REG;
	out_tmp_even(17) <= AR_SEL;
	out_tmp_even(16) <= BR_SEL;
	out_tmp_even(15) <= WR_SEL;
	out_tmp_even(14) <= SM_DIFFp;
	out_tmp_even(13 downto 12) <= MSD_DIFFm;
	out_tmp_even(11) <= AS_SUM_SEL;
	out_tmp_even(10) <= SD_ROUND_SEL;
	out_tmp_even(9) <= REG_RND_BR;
	out_tmp_even(8) <= REG_RND_BI;
	out_tmp_even(7) <= REG_RND_AR;
	out_tmp_even(6) <= REG_RND_AI;
	out_tmp_even(5) <= SHIFT;
	out_tmp_even(4) <= DONE;

	--Next address
	out_tmp_even((next_Address_length-1) downto 0) <= next_Address;
	


	p_rom : process (A)
	begin
		case A is
		when "0000" => 					--IDLE
			CC_Validation <= '1';
			REG_IN <= '0';
			SUM_REG <= '0';
			AR_SEL <= '0';
			BR_SEL <= '0';
			WR_SEL <= '0';
			SM_DIFFp <= '0';
			MSD_DIFFm <= '0';
			AS_SUM_SEL <= '0';
			SD_ROUND_SEL <= '0';
			REG_RND_BR <= '0';
			REG_RND_BI <= '0';
			REG_RND_AR <= '0';
			REG_RND_AI <= '0';
			SHIFT <= '0';
			DONE <= '0';
		when "001" => 					--START
			
		when "010" => 					--M1	(Wr * Br)
			Q <= C;
		when "011" => 					--M2	(Wi * Br)
			Q <= ;
		when "100" =>  					--S1 & M3	(Wi * Bi, M1 + Ar)
			Q <= ;
		when "101" =>  					--S2 & M4	
			Q <= ;
		when "110" =>  					--D1 & M5	
			Q <= ;
		when "111" =>  					--SH1 & D2 & M6 & D3
			Q <= ;
		when "111" =>  					--SH2 & D3 & AP1
			Q <= ;
		when "111" =>  					--SH3 & AP2
			Q <= ;
		when "111" =>  					--SH4 & AP3
			Q <= ;
		when "111" =>  					--AP4 & DONE
			Q <= ;
		when others => 
			Q <= (others=>'0');
	end case;
	end process;


end behavioral;



