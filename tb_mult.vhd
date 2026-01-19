
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity tb_multiplier is
end	tb_multiplier;

---------------------------------------------

architecture behavioral of tb_multiplier is
	
	component BFLY_MULTIPLIER is
	port (	A:	in	STD_LOGIC_VECTOR (23 downto 0);
		B:	in	STD_LOGIC_VECTOR (23 downto 0);
		SHIFT: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		S_OUT:	out	STD_LOGIC_VECTOR(48 downto 0);
		M_OUT:	out	STD_LOGIC_VECTOR(48 downto 0));
	end component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_CLK, TB_SHIFT : STD_LOGIC := '0';
	SIGNAL TB_S_OUT, TB_M_OUT: STD_LOGIC_VECTOR(48 downto 0) := (others=>'0');
	SIGNAL TB_A, TB_B: STD_LOGIC_VECTOR(23 downto 0) := (others=>'0');
	
	begin
	
	TB_CLK <= not TB_CLK after period/2;
	
	process 
	begin
		wait for period;
		TB_A <= "000000000000000000000001";
		TB_B <= "111111111111111111111111";
		wait for period*1;
		
		TB_A <= "100000000000000000000001";
		TB_B <= "100000000000000000000001";
		wait for period*1;
		
		TB_A <= "111111111111111111111111";
		TB_B <= "111111111111111111111111";
		wait for period*1;
		
		TB_A <= "000000000000000000000011";
		TB_B <= "111111111111111111111101";
		wait for period*1;
		
		TB_A <= "000000000000000000000111";
		TB_B <= "111111111111111111111101";
		wait for period*1;
		
		TB_A <= "011111111111111111111111";
		TB_B <= "011111111111111111111111";
		wait for period*1;
		
		TB_A <= "011111111111111111111111";
		TB_B <= "100000000000000000000001";
		wait for period*1;
	
		TB_SHIFT <= '1';
		TB_A <= "000111111111111111111111";
		TB_B <= "100000000000000000000001";
		wait for period*1;
		
		TB_SHIFT <= '1';
		TB_A <= "111111111111111111111111";
		TB_B <= "100000000000000000000001";
		wait for period*1;
	end process;
	
	
	pm_mult : BFLY_MULTIPLIER port map (
		TB_A,
		TB_B,
		TB_SHIFT,
		TB_CLK,
		TB_S_OUT,
		TB_M_OUT
	);
	
end behavioral;
 
