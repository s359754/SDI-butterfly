
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity tb_CU is
end	tb_CU;

---------------------------------------------

architecture behavioral of tb_CU is
	
	component BFLY_CU_DATAPATH is
	port (	START:	in	STD_LOGIC;
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		INSTRUCTION_OUT:	out	STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_CLK, TB_SF_2H_1L, TB_START : STD_LOGIC := '0';
	SIGNAL TB_INSTRUCTION_OUT: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	SIGNAL REG_IN, SUM_REG, AR_SEL, BR_SEL, WR_SEL, MS_DIFFp, AS_SUM_SEL, SD_ROUND_SEL, REG_RND_BR, REG_RND_BI, REG_RND_AR, REG_RND_AI, SHIFT, DONE : STD_LOGIC := '0';
	SIGNAL MSD_DIFFm : STD_LOGIC_VECTOR (1 downto 0) := "00";	
	
	begin
	
		--Instruction part
	REG_IN <= TB_INSTRUCTION_OUT(15);
	SUM_REG <= TB_INSTRUCTION_OUT(14);
	AR_SEL <= TB_INSTRUCTION_OUT(13);
	BR_SEL <= TB_INSTRUCTION_OUT(12);
	WR_SEL <= TB_INSTRUCTION_OUT(11);
	MS_DIFFp <= TB_INSTRUCTION_OUT(10);
	MSD_DIFFm <= TB_INSTRUCTION_OUT(9 downto 8);
	AS_SUM_SEL <= TB_INSTRUCTION_OUT(7);
	SD_ROUND_SEL <= TB_INSTRUCTION_OUT(6);
	REG_RND_BR <= TB_INSTRUCTION_OUT(5);
	REG_RND_BI <= TB_INSTRUCTION_OUT(4);
	REG_RND_AR <= TB_INSTRUCTION_OUT(3);
	REG_RND_AI <= TB_INSTRUCTION_OUT(2);
	SHIFT <= TB_INSTRUCTION_OUT(1);
	DONE <= TB_INSTRUCTION_OUT(0);

	
	TB_CLK <= not TB_CLK after period/2;
	
	process 
	begin
		wait for period*3;
		TB_START <= '1';
		wait for period*1;
		TB_START <= '0';
		wait for period*20;
	end process;
	
	
	pm_CU : BFLY_CU_DATAPATH port map (
		TB_START,
		TB_SF_2H_1L,
		TB_CLK,
		TB_INSTRUCTION_OUT
	);
	
end behavioral;
 
