
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity tb_adder is
end	tb_adder;

---------------------------------------------

architecture behavioral of tb_adder is
	
	component BFLY_ADDER is
	port (	A:	in	STD_LOGIC_VECTOR (48 downto 0);
		B:	in	STD_LOGIC_VECTOR (48 downto 0);
		CK:	in	STD_LOGIC;
		SUM_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_CLK: STD_LOGIC := '0';
	SIGNAL TB_SUM_OUT: STD_LOGIC_VECTOR(48 downto 0) := (others=>'0');
	SIGNAL TB_A, TB_B: STD_LOGIC_VECTOR(48 downto 0) := (others=>'0');
	
	begin
	
	TB_CLK <= not TB_CLK after period/2;
	
	process 
	begin
		wait for period;
		TB_A <= "0000000000000000000000001000000000000000000000001";
		TB_B <= (others=>'0');
		wait for period*1;
		
		TB_A <= "0000000000000000000000001000000000000000000000011";
		TB_B <= (others=>'0');
		TB_B(1) <= '1';
		wait for period*1;
		
		TB_A <= "0000000000000000000000000000000000000000000000111";
		TB_B <= "0000000000000000000000001111111111111111111111101";
		wait for period*1;
		
		TB_A <= "0000000000000000000000001011111111111111111111111";
		TB_B <= "0000000000000000000000001011111111111111111111111";
		wait for period*1;
		
		TB_A <= "0000000000000000000000001011111111111111111111111";
		TB_B <= "0000000000000000000000001100000000000000000000001";
		wait for period*1;
	
		TB_A <= "0000000000000000000000001000111111111111111111111";
		TB_B <= "0000000000000000000000001100000000000000000000001";
		wait for period*1;
		
		TB_A <= "0000000000000000000000001111111111111111111111111";
		TB_B <= "0000000000000000000000001100000000000000000000001";
		wait for period*1;
	end process;
	
	
	pm_adder : BFLY_ADDER port map (
		TB_A,
		TB_B,
		TB_CLK,
		TB_SUM_OUT
	);
	
end behavioral;
 
