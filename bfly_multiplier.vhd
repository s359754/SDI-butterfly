library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;


entity BFLY_MULTIPLIER is
	port (	A:	in	STD_LOGIC_VECTOR (23 downto 0);
		B:	in	STD_LOGIC_VECTOR (23 downto 0);
		SHIFT: in STD_LOGIC;
		CK:	in	STD_LOGIC;
		S_OUT:	out	STD_LOGIC_VECTOR(48 downto 0);
		M_OUT:	out	STD_LOGIC_VECTOR(48 downto 0)
		);
end BFLY_MULTIPLIER;


architecture behavioral of BFLY_MULTIPLIER is 

	signal op_A, op_B: STD_LOGIC_VECTOR (23 downto 0) := (others=>'0');
	signal product: STD_LOGIC_VECTOR (47 downto 0) := (others=>'0');
	signal S_OUT_tmp,M_OUT_tmp: STD_LOGIC_VECTOR (47 downto 0) := (others=>'0');
	signal S_OUT_trunc,M_OUT_trunc: STD_LOGIC_VECTOR (46 downto 0) := (others=>'0');
	
	begin
	
	op_A <= A;
	op_B <= "000000000000000000000010" when SHIFT = '1' else B;
	product <= std_logic_vector(signed(op_A)*signed(op_B));
	S_OUT_trunc <= S_OUT_tmp(46 downto 0);
	M_OUT_trunc <= M_OUT_tmp(46 downto 0);
	S_OUT <=  '0' & '0' & S_OUT_trunc;
	M_OUT <= '0' & '0' & M_OUT_trunc;
	
	
		PSYNCH: process(CK)
		begin
			if CK'event and CK='1' then -- positive edge triggered:
				S_OUT_tmp <= product;
				M_OUT_tmp <= S_OUT_tmp;
			
			end if;
		end process;

end behavioral;



