
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity tb_fmc is
end	tb_fmc;

---------------------------------------------

architecture behavioral of tb_fmc is
	
	component fmc_top_entity is
	port( 
	-- Segnali MCU - FMC
	--lsasBus(19 downto 19)	FMC_CLK
	--lsasBus(23 downto 23)	FMC_NE1
	--lsasBus(20 downto 20)	FMC_NOE
	--lsasBus(21 downto 21)	FMC_NWE
	--lsasBus(22 downto 22) FMC_NWAIT
	--lsasBus(31 downto 30)	FMC_AD0-1
	--lsasBus(17 downto 16)	FMC_AD2-3
	--lsasBus(15 downto 7)	FMC_AD4-12
	--lsasBus(26 downto 24) FMC_AD13-15
	
	lsasBus: inout STD_LOGIC_VECTOR (31 downto 7)
	);
	end	component;
	
	constant period : time := 100 ns;
	
	SIGNAL TB_CLK, TB_NE1, TB_NOE, TB_NWE : STD_LOGIC := '1';
	SIGNAL TB_AD_tmp: STD_LOGIC_VECTOR (15 downto 0);
	SIGNAL TB_AD: STD_LOGIC_VECTOR (15 downto 0) := (others=>'Z');
	SIGNAL TB_lsasBus: STD_LOGIC_VECTOR(31 downto 7) := (others=>'1');
	
	begin
	
	TB_CLK <= not TB_CLK after period/2;
	
	TB_lsasBus(31 downto 30) <= TB_AD_tmp(1 downto 0);
	TB_lsasBus(26 downto 24) <= TB_AD_tmp(15 downto 13);
	TB_lsasBus(23) <= TB_NE1;
	TB_lsasBus(22) <= '0';
	TB_lsasBus(21) <= TB_NWE;
	TB_lsasBus(20) <= TB_NOE;
	TB_lsasBus(19) <= TB_CLK;
	TB_lsasBus(17 downto 16) <= TB_AD_tmp(3 downto 2);
	TB_lsasBus(15 downto 7) <= TB_AD_tmp(12 downto 4);
	
	
	
	process 
	begin
		wait for period/2;
		TB_NE1 <= '0';
		TB_AD_tmp <= "0000000000000001";
		TB_NWE <= '0';
		wait for 4*period/2;
		TB_AD_tmp <= (others=>'Z');
		wait for 2*period/2;
		TB_AD_tmp <= "0101010101101010";
		wait for 4*period/2;
		TB_AD_tmp <= (others=>'Z');
		wait for 3*period/2;
		TB_NE1 <= '1';
		TB_NWE <= '1';
		
		wait for 4*period/2;
	
		wait for period/2;
		TB_NE1 <= '0';
		TB_AD_tmp <= "0000000000000001";
		wait for 4*period/2;
		TB_AD_tmp <= (others=>'Z');
		TB_NOE <= '0';
		wait for 9*period/2;
		TB_NE1 <= '1';
		TB_NOE <= '1';
		
		wait for 4*period/2;
	
	end process;
	
	
	
	
	pm_fmc_top_entity : fmc_top_entity port map (
		TB_lsasBus
	);
	
end behavioral;
 
