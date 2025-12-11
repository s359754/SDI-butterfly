
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity tb_rshift is
end	tb_rshift;

---------------------------------------------

architecture behavioral of tb_rshift is
	
	component BFLY_SHIFTER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		SF_2H_1L: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		SHIFT_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_CLK, TB_SF_2H_1L: STD_LOGIC := '0';
	SIGNAL TB_SHIFT_OUT: STD_LOGIC_VECTOR(48 downto 0) := (others=>'0');
	SIGNAL TB_A: STD_LOGIC_VECTOR(48 downto 0) := (others=>'0');
	
	begin
	
	TB_CLK <= not TB_CLK after period/2;
	
	process 
	begin
		wait for period;
		TB_A <= "0000000000000000000000001000000000000000000000001";
		wait for period*1;
		
		TB_A <= "0000000000000000000000001000000000000000000000011";
		wait for period*1;
		
		TB_A <= "0000000000000000000000000000000000000000000000111";
		wait for period*1;
		
		TB_SF_2H_1L <= '1';
		
		TB_A <= "0000000000000000000000001011111111111111111111111";
		wait for period*1;
		
		TB_A <= "0000000000000000000000001011111111111111111111111";
		wait for period*1;
	
		TB_A <= (others => '1');
		wait for period*1;

	end process;
	
	
	pm_rshift : BFLY_SHIFTER port map (
		TB_A,
		TB_SF_2H_1L,
		TB_CLK,
		TB_SHIFT_OUT
	);
	
end behavioral;
 
