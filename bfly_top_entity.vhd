
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity BFLY_TOP_ENTITY is
port( 
	x0r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x0i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x1r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x1i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x2r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x2i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x3r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x3i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x4r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x4i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x5r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x5i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x6r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x6i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x7r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x7i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x8r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x8i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x9r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x9i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x10r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x10i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x11r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x11i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x12r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x12i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x13r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x13i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x14r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x14i_in : in STD_LOGIC_VECTOR (23 downto 0);

	x15r_in : in STD_LOGIC_VECTOR (23 downto 0);
	x15i_in : in STD_LOGIC_VECTOR (23 downto 0);

	Clock, START : in STD_LOGIC;
	
	x0r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x0i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x1r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x1i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x2r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x2i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x3r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x3i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x4r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x4i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x5r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x5i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x6r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x6i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x7r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x7i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x8r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x8i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x9r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x9i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x10r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x10i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x11r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x11i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x12r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x12i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x13r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x13i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x14r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x14i_out : out STD_LOGIC_VECTOR (23 downto 0);

	x15r_out : out STD_LOGIC_VECTOR (23 downto 0);
	x15i_out : out STD_LOGIC_VECTOR (23 downto 0);

	DONE : out STD_LOGIC
);
end	BFLY_TOP_ENTITY;

---------------------------------------------

architecture structural of BFLY_TOP_ENTITY is
	
	component bfly_datapath is
	port( 
		Br_in, Bi_in, Ar_in, Ai_in, Wr_in, Wi_in : in STD_LOGIC_VECTOR (23 downto 0);
		Clock, START, SF_2H_1L : in STD_LOGIC;
		Br_out, Bi_out, Ar_out, Ai_out : out STD_LOGIC_VECTOR (23 downto 0);
		DONE : out STD_LOGIC
	);
	end	component;
	
	type sampleArray is array (15 downto 0) of STD_LOGIC_VECTOR (23 downto 0);
	signal W_r, W_i : sampleArray := (others => (others=>'0'));
	
	type outputArray is array (31 downto 0) of STD_LOGIC_VECTOR (23 downto 0);
	signal Ar_out1, Ai_out1, Br_out1, Bi_out1 : outputArray := (others => (others=>'0'));
	
	signal DONE_out : STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
	
	
	begin
	
	Ar_out1(0) <= x0r_in;
	Ai_out1(0) <= x0i_in;
	Ar_out1(1) <= x1r_in;
	Ai_out1(1) <= x1i_in;
	Ar_out1(2) <= x2r_in;
	Ai_out1(2) <= x2i_in;
	Ar_out1(3) <= x3r_in;
	Ai_out1(3) <= x3i_in;
	Ar_out1(4) <= x4r_in;
	Ai_out1(4) <= x4i_in;
	Ar_out1(5) <= x5r_in;
	Ai_out1(5) <= x5i_in;
	Ar_out1(6) <= x6r_in;
	Ai_out1(6) <= x6i_in;
	Ar_out1(7) <= x7r_in;
	Ai_out1(7) <= x7i_in;
	
	Br_out1(0) <= x8r_in;
	Bi_out1(0) <= x8i_in;
	Br_out1(1) <= x9r_in;
	Bi_out1(1) <= x9i_in;
	Br_out1(2) <= x10r_in;
	Bi_out1(2) <= x10i_in;
	Br_out1(3) <= x11r_in;
	Bi_out1(3) <= x11i_in;
	Br_out1(4) <= x12r_in;
	Bi_out1(4) <= x12i_in;
	Br_out1(5) <= x13r_in;
	Bi_out1(5) <= x13i_in;
	Br_out1(6) <= x14r_in;
	Bi_out1(6) <= x14i_in;
	Br_out1(7) <= x15r_in;
	Bi_out1(7) <= x15i_in;
	

	gen_bfly1a : for j in 0 to 3 generate
	pm_bfly1a_j : bfly_datapath port map (
		Br_in => Br_out1(j),
		Bi_in => Bi_out1(j), 
		Ar_in => Ar_out1(j), 
		Ai_in => Ai_out1(j), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => START, 
		SF_2H_1L => '1',
		Br_out => Ar_out1(12+j), 
		Bi_out => Ai_out1(12+j), 
		Ar_out => Ar_out1(8+j), 
		Ai_out => Ai_out1(8+j),
		DONE => DONE_out(j)
	);		
	end generate;
			
	gen_bfly1b : for j in 0 to 3 generate
	pm_bfly1b_j : bfly_datapath port map (
		Br_in => Br_out1(4+j),
		Bi_in => Bi_out1(4+j), 
		Ar_in => Ar_out1(4+j), 
		Ai_in => Ai_out1(4+j), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => START, 
		SF_2H_1L => '1',
		Br_out => Br_out1(12+j), 
		Bi_out => Bi_out1(12+j), 
		Ar_out => Br_out1(8+j), 
		Ai_out => Bi_out1(8+j),
		DONE => DONE_out(4+j)
	);		
	end generate;
	
--------------------------------------------------------
	
	gen_bfly2a : for j in 0 to 1 generate
	pm_bfly2a_j : bfly_datapath port map (
		Br_in => Br_out1(8+j),
		Bi_in => Bi_out1(8+j), 
		Ar_in => Ar_out1(8+j), 
		Ai_in => Ai_out1(8+j), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => DONE_out(0+j), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(18+j), 
		Bi_out => Ai_out1(18+j), 
		Ar_out => Ar_out1(16+j), 
		Ai_out => Ai_out1(16+j),
		DONE => DONE_out(8+j)
	);
	end generate;
	
	gen_bfly2b : for j in 0 to 1 generate
	pm_bfly2b_j : bfly_datapath port map (
		Br_in => Br_out1(10+j),
		Bi_in => Bi_out1(10+j), 
		Ar_in => Ar_out1(10+j), 
		Ai_in => Ai_out1(10+j), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => DONE_out(2+j), 
		SF_2H_1L => '0',
		Br_out => Br_out1(18+j), 
		Bi_out => Bi_out1(18+j), 
		Ar_out => Br_out1(16+j), 
		Ai_out => Bi_out1(16+j),
		DONE => DONE_out(10+j)
	);	
	end generate;
	
	gen_bfly2c : for j in 0 to 1 generate
	pm_bfly2c_j : bfly_datapath port map (
		Br_in => Br_out1(12+j),
		Bi_in => Bi_out1(12+j), 
		Ar_in => Ar_out1(12+j), 
		Ai_in => Ai_out1(12+j), 
		Wr_in => W_r(4), 
		Wi_in => W_i(4),
		Clock => Clock, 
		START => DONE_out(4+j), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(22+j), 
		Bi_out => Ai_out1(22+j), 
		Ar_out => Ar_out1(20+j), 
		Ai_out => Ai_out1(20+j),
		DONE => DONE_out(12+j)
	);		
	end generate;
	
	gen_bfly2d : for j in 0 to 1 generate
	pm_bfly2d_j : bfly_datapath port map (
		Br_in => Br_out1(14+j),
		Bi_in => Bi_out1(14+j), 
		Ar_in => Ar_out1(14+j), 
		Ai_in => Ai_out1(14+j), 
		Wr_in => W_r(4), 
		Wi_in => W_i(4),
		Clock => Clock, 
		START => DONE_out(6+j), 
		SF_2H_1L => '0',
		Br_out => Br_out1(22+j), 
		Bi_out => Bi_out1(22+j), 
		Ar_out => Br_out1(20+j), 
		Ai_out => Bi_out1(20+j),
		DONE => DONE_out(14+j)
	);
	end generate;

--------------------------------------------------------	
	
	pm_bfly3a_1 : bfly_datapath port map (
		Br_in => Br_out1(16),
		Bi_in => Bi_out1(16), 
		Ar_in => Ar_out1(16), 
		Ai_in => Ai_out1(16), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => DONE_out(8), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(25), 
		Bi_out => Ai_out1(25), 
		Ar_out => Ar_out1(24), 
		Ai_out => Ai_out1(24),
		DONE => DONE_out(16)
	);	
	
	pm_bfly3b_1 : bfly_datapath port map (
		Br_in => Br_out1(17),
		Bi_in => Bi_out1(17), 
		Ar_in => Ar_out1(17), 
		Ai_in => Ai_out1(17), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => DONE_out(9), 
		SF_2H_1L => '0',
		Br_out => Br_out1(25), 
		Bi_out => Bi_out1(25), 
		Ar_out => Br_out1(24), 
		Ai_out => Bi_out1(24),
		DONE => DONE_out(17)
	);
	
	pm_bfly3a_2 : bfly_datapath port map (
		Br_in => Br_out1(18),
		Bi_in => Bi_out1(18), 
		Ar_in => Ar_out1(18), 
		Ai_in => Ai_out1(18), 
		Wr_in => W_r(4), 
		Wi_in => W_i(4),
		Clock => Clock, 
		START => DONE_out(10), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(27), 
		Bi_out => Ai_out1(27), 
		Ar_out => Ar_out1(26), 
		Ai_out => Ai_out1(26),
		DONE => DONE_out(18)
	);
	
	pm_bfly3b_2 : bfly_datapath port map (
		Br_in => Br_out1(19),
		Bi_in => Bi_out1(19), 
		Ar_in => Ar_out1(19), 
		Ai_in => Ai_out1(19), 
		Wr_in => W_r(4), 
		Wi_in => W_i(4),
		Clock => Clock, 
		START => DONE_out(11), 
		SF_2H_1L => '0',
		Br_out => Br_out1(27), 
		Bi_out => Bi_out1(27), 
		Ar_out => Br_out1(26), 
		Ai_out => Bi_out1(26),
		DONE => DONE_out(19)
	);
	
	pm_bfly3a_3 : bfly_datapath port map (
		Br_in => Br_out1(20),
		Bi_in => Bi_out1(20), 
		Ar_in => Ar_out1(20), 
		Ai_in => Ai_out1(20), 
		Wr_in => W_r(2), 
		Wi_in => W_i(2),
		Clock => Clock, 
		START => DONE_out(12), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(29), 
		Bi_out => Ai_out1(29), 
		Ar_out => Ar_out1(28), 
		Ai_out => Ai_out1(28),
		DONE => DONE_out(20)
	);
	
	pm_bfly3b_3 : bfly_datapath port map (
		Br_in => Br_out1(21),
		Bi_in => Bi_out1(21), 
		Ar_in => Ar_out1(21), 
		Ai_in => Ai_out1(21), 
		Wr_in => W_r(2), 
		Wi_in => W_i(2),
		Clock => Clock, 
		START => DONE_out(13), 
		SF_2H_1L => '0',
		Br_out => Br_out1(29), 
		Bi_out => Bi_out1(29), 
		Ar_out => Br_out1(28), 
		Ai_out => Bi_out1(28),
		DONE => DONE_out(21)
	);
	
	pm_bfly3a_4 : bfly_datapath port map (
		Br_in => Br_out1(22),
		Bi_in => Bi_out1(22), 
		Ar_in => Ar_out1(22), 
		Ai_in => Ai_out1(22), 
		Wr_in => W_r(6), 
		Wi_in => W_i(6),
		Clock => Clock, 
		START => DONE_out(14), 
		SF_2H_1L => '0',
		Br_out => Ar_out1(31), 
		Bi_out => Ai_out1(31), 
		Ar_out => Ar_out1(30), 
		Ai_out => Ai_out1(30),
		DONE => DONE_out(22)
	);
	
	pm_bfly3b_4 : bfly_datapath port map (
		Br_in => Br_out1(21),
		Bi_in => Bi_out1(21), 
		Ar_in => Ar_out1(21), 
		Ai_in => Ai_out1(21), 
		Wr_in => W_r(6), 
		Wi_in => W_i(6),
		Clock => Clock, 
		START => DONE_out(15), 
		SF_2H_1L => '0',
		Br_out => Br_out1(31), 
		Bi_out => Bi_out1(31), 
		Ar_out => Br_out1(30), 
		Ai_out => Bi_out1(30),
		DONE => DONE_out(23)
	);
	
--------------------------------------------------------
	
	pm_bfly4_1 : bfly_datapath port map (
		Br_in => Br_out1(24),
		Bi_in => Bi_out1(24), 
		Ar_in => Ar_out1(24), 
		Ai_in => Ai_out1(24), 
		Wr_in => W_r(0), 
		Wi_in => W_i(0),
		Clock => Clock, 
		START => DONE_out(16),
		SF_2H_1L => '0',
		Br_out => x8r_out, 
		Bi_out => x8i_out, 
		Ar_out => x0r_out, 
		Ai_out => x0i_out,
		DONE => DONE_out(24)
	);
	
	pm_bfly4_2 : bfly_datapath port map (
		Br_in => Br_out1(25),
		Bi_in => Bi_out1(25), 
		Ar_in => Ar_out1(25), 
		Ai_in => Ai_out1(25), 
		Wr_in => W_r(4), 
		Wi_in => W_i(4),
		Clock => Clock, 
		START => DONE_out(17),
		SF_2H_1L => '0',
		Br_out => x12r_out, 
		Bi_out => x12i_out, 
		Ar_out => x4r_out, 
		Ai_out => x4i_out,
		DONE => DONE_out(25)
	);
	
	pm_bfly4_3 : bfly_datapath port map (
		Br_in => Br_out1(26),
		Bi_in => Bi_out1(26), 
		Ar_in => Ar_out1(26), 
		Ai_in => Ai_out1(26), 
		Wr_in => W_r(2), 
		Wi_in => W_i(2),
		Clock => Clock, 
		START => DONE_out(18),
		SF_2H_1L => '0',
		Br_out => x10r_out, 
		Bi_out => x10i_out, 
		Ar_out => x2r_out, 
		Ai_out => x2i_out,
		DONE => DONE_out(26)
	);
	
	pm_bfly4_4 : bfly_datapath port map (
		Br_in => Br_out1(27),
		Bi_in => Bi_out1(27), 
		Ar_in => Ar_out1(27), 
		Ai_in => Ai_out1(27), 
		Wr_in => W_r(6), 
		Wi_in => W_i(6),
		Clock => Clock, 
		START => DONE_out(19),
		SF_2H_1L => '0',
		Br_out => x14r_out, 
		Bi_out => x14i_out, 
		Ar_out => x6r_out, 
		Ai_out => x6i_out,
		DONE => DONE_out(27)
	);
	
	pm_bfly4_5 : bfly_datapath port map (
		Br_in => Br_out1(28),
		Bi_in => Bi_out1(28), 
		Ar_in => Ar_out1(28), 
		Ai_in => Ai_out1(28), 
		Wr_in => W_r(1), 
		Wi_in => W_i(1),
		Clock => Clock, 
		START => DONE_out(20),
		SF_2H_1L => '0',
		Br_out => x9r_out, 
		Bi_out => x9i_out, 
		Ar_out => x1r_out, 
		Ai_out => x1i_out,
		DONE => DONE_out(28)
	);
	
	pm_bfly4_6 : bfly_datapath port map (
		Br_in => Br_out1(29),
		Bi_in => Bi_out1(29), 
		Ar_in => Ar_out1(29), 
		Ai_in => Ai_out1(29), 
		Wr_in => W_r(5), 
		Wi_in => W_i(5),
		Clock => Clock, 
		START => DONE_out(21),
		SF_2H_1L => '0',
		Br_out => x13r_out, 
		Bi_out => x13i_out, 
		Ar_out => x5r_out, 
		Ai_out => x5i_out,
		DONE => DONE_out(29)
	);
	
	pm_bfly4_7 : bfly_datapath port map (
		Br_in => Br_out1(30),
		Bi_in => Bi_out1(30), 
		Ar_in => Ar_out1(30), 
		Ai_in => Ai_out1(30), 
		Wr_in => W_r(3), 
		Wi_in => W_i(3),
		Clock => Clock, 
		START => DONE_out(22),
		SF_2H_1L => '0',
		Br_out => x11r_out, 
		Bi_out => x11i_out, 
		Ar_out => x3r_out, 
		Ai_out => x3i_out,
		DONE => DONE_out(30)
	);
	
	pm_bfly4_8 : bfly_datapath port map (
		Br_in => Br_out1(31),
		Bi_in => Bi_out1(31), 
		Ar_in => Ar_out1(31), 
		Ai_in => Ai_out1(31), 
		Wr_in => W_r(7), 
		Wi_in => W_i(7),
		Clock => Clock, 
		START => DONE_out(23),
		SF_2H_1L => '0',
		Br_out => x15r_out, 
		Bi_out => x15i_out, 
		Ar_out => x7r_out, 
		Ai_out => x7i_out,
		DONE => DONE_out(31)
	);


--------------------------------------------------------

DONE <= DONE_out(24) or DONE_out(25) or DONE_out(26) or DONE_out(27) or DONE_out(28) or DONE_out(29) or DONE_out(30) or DONE_out(31);
	
--------------------------------------------------------

	
	
	
	W_r(0) <= "011111111111111111111111";		-- 1.000000000000000 + 0.000000000000000i
	W_i(0) <= "000000000000000000000000";
	
	W_r(1) <= "011101100100000110101111";		-- 0.923879532511287 - 0.382683432365090i
	W_i(1) <= "110011110000010000111011";		
	
	W_r(2) <= "010110101000001001111001";		-- 0.707106781186547 - 0.707106781186548i
	W_i(2) <= "101001010111110110000111";		
	
	W_r(3) <= "001100001111101111000101";		-- 0.382683432365090 - 0.923879532511287i
	W_i(3) <= "100010011011111001010001";		
	
	W_r(4) <= "000000000000000000000000";		-- -0.000000000000000 - 1.000000000000000i
	W_i(4) <= "100000000000000000000001";		
	
	W_r(5) <= "110011110000010000111011";		-- -0.382683432365090 - 0.923879532511287i
	W_i(5) <= "100010011011111001010001";		
	
	W_r(6) <= "101001010111110110000111";		-- -0.707106781186548 - 0.707106781186547i
	W_i(6) <= "101001010111110110000111";		
	
	W_r(7) <= "100010011011111001010001";		-- -0.923879532511287 - 0.382683432365089i
	W_i(7) <= "110011110000010000111011";		
	
	
	
	
	W_r(8) <= "100000000000000000000001";		-- -1.000000000000000 + 0.000000000000000i
	W_i(8) <= "000000000000000000000000";		
	
	W_r(9) <= "100010011011111001010001";		-- -0.923879532511287 + 0.382683432365090i
	W_i(9) <= "001100001111101111000101";		
	
	W_r(10) <= "101001010111110110000111";		-- -0.707106781186547 + 0.707106781186548i
	W_i(10) <= "010110101000001001111001";		
	
	W_r(11) <= "110011110000010000111011";		-- -0.382683432365089 + 0.923879532511287i
	W_i(11) <= "011101100100000110101111";		
	
	W_r(12) <= "000000000000000000000000";		-- 0.000000000000000 + 1.000000000000000i
	W_i(12) <= "011111111111111111111111";		
	
	W_r(13) <= "001100001111101111000101";		-- 0.382683432365090 + 0.923879532511286i
	W_i(13) <= "011101100100000110101111";		
	
	W_r(14) <= "010110101000001001111001";		-- 0.707106781186548 + 0.707106781186547i
	W_i(14) <= "010110101000001001111001";		
	
	W_r(15) <= "011101100100000110101111";		-- 0.923879532511287 + 0.382683432365089i
	W_i(15) <= "001100001111101111000101";		
	
end structural;
