
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity TB_BFLY_SINGLE is
end	TB_BFLY_SINGLE;

---------------------------------------------

architecture behavioral of TB_BFLY_SINGLE is
	
	component bfly_datapath is
	port( 
		Br_in, Bi_in, Ar_in, Ai_in, Wr_in, Wi_in : in STD_LOGIC_VECTOR (23 downto 0);
		Clock, START, SF_2H_1L : in STD_LOGIC;
		Br_out, Bi_out, Ar_out, Ai_out : out STD_LOGIC_VECTOR (23 downto 0);
		DONE : out STD_LOGIC
	);
	end	component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_Clock, TB_START, TB_SF_2H_1L, TB_DONE : STD_LOGIC := '0';
	SIGNAL TB_Br_in, TB_Bi_in, TB_Ar_in, TB_Ai_in, TB_Wr_in, TB_Wi_in : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	SIGNAL TB_Br_out, TB_Bi_out, TB_Ar_out, TB_Ai_out : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
	
	SIGNAL UNS_Br, UNS_Bi, UNS_Ar, UNS_Ai, UNS_Wr, UNS_Wi : UNSIGNED (23 downto 0);

	
	begin
	
	TB_Clock <= not TB_Clock after period/2;
	
	process 
	begin
		wait for 2*period/2;
		TB_START <= '1';
		TB_SF_2H_1L <= '0';
		
		wait for 2*period/2;
		TB_START <= '0';
		
		wait for 38*period/2;
		
		wait for 2*period/2;
		
		
		TB_Br_in <= "010001000000010000000011";
		TB_Bi_in <= "010001000000010000000011";
		
		TB_Ar_in <= "000100010000000010000000";
		TB_Ai_in <= "000100010000000010000000";
		
		
		TB_Wr_in <= "000000000000000000000010";
		TB_Wr_in <= "000000000000000000000010";
		
		
		TB_START <= '1';
		TB_SF_2H_1L <= '0';
		
		wait for 2*period/2;
		TB_START <= '0';

		
		wait for 38*period/2;
		
		wait for 2*period/2;
		
		
		TB_Br_in <= "000000000000000000000010";
		TB_Bi_in <= "000000000000000000000010";
		
		TB_Ar_in <= "000000000000000000000010";
		TB_Ai_in <= "000000000000000000000010";
		
		
		TB_Wr_in <= "000000000000000000000010";
		TB_Wi_in <= "000000000000000000000010";
		
		
		TB_START <= '1';
		TB_SF_2H_1L <= '0';
		
		wait for 2*period/2;
		TB_START <= '0';

		
		wait for 38*period/2;
		
	end process;
	
	
	pm_bfly_datapath : bfly_datapath port map (
		Br_in => TB_Br_in,
		Bi_in => TB_Bi_in,
		Ar_in => TB_Ar_in,
		Ai_in => TB_Ai_in,
		Wr_in => TB_Wr_in,
		Wi_in => TB_Wi_in,
		Clock => TB_Clock,
		START => TB_START,
		SF_2H_1L => TB_SF_2H_1L,
		Br_out => TB_Br_out,
		Bi_out => TB_Bi_out,
		Ar_out => TB_Ar_out,
		Ai_out => TB_Ai_out,
		DONE => TB_DONE
		);
	
end behavioral;
 
