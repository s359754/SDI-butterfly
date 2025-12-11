
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity fmc_top_entity is
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
end	fmc_top_entity;

---------------------------------------------

architecture structural of fmc_top_entity is
	
	
	
	component fmc_datapath is
	generic(
		bus_length: INTEGER:= 16
	);
	port (
		-- Segnali MCU - FMC
		FMC_CLK, FMC_NE1, FMC_NOE, FMC_NWE : in STD_LOGIC;
		FMC_AD: inout STD_LOGIC_VECTOR ((bus_length-1) downto 0);	
		
		-- Segnali FMC - Memoria
		A: out STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		DOUT: out STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		DIN: in STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		RD, WR: out STD_LOGIC
	);
	end component;
	
	component rw_mem is 
	generic(
	address_length: INTEGER := 16;
	data_length: INTEGER := 16
	);
	port( CLOCK : in STD_LOGIC;
		A: in STD_LOGIC_VECTOR ((address_length-1) downto 0);
		DOUT: out STD_LOGIC_VECTOR ((data_length-1) downto 0);
		DIN: in STD_LOGIC_VECTOR ((data_length-1) downto 0);
		RD, WR: in STD_LOGIC
	);
	end component;
	
	signal te_A, te_DOUT, te_DIN : STD_LOGIC_VECTOR (15 downto 0);
	signal te_RD, te_WR : STD_LOGIC;
	
	begin
		
		lsasBus(19) <= 'Z';
		lsasBus(23) <= 'Z';
		lsasBus(20) <= 'Z';
		lsasBus(21) <= 'Z';
	
	
	pm_datapath : fmc_datapath port map (
		FMC_CLK => lsasBus(19),
		FMC_NE1 => lsasBus(23),
		FMC_NOE => lsasBus(20),
		FMC_NWE => lsasBus(21),
		FMC_AD(1 downto 0) => lsasBus(31 downto 30),
		FMC_AD(3 downto 2) => lsasBus(17 downto 16),
		FMC_AD(12 downto 4) => lsasBus(15 downto 7),
		FMC_AD(15 downto 13) => lsasBus(26 downto 24),
		
		A => te_A,
		DOUT => te_DOUT,
		DIN => te_DIN,
		RD => te_RD,
		WR => te_WR
	);
	
	pm_rw_mem : rw_mem port map (
		CLOCK => lsasBus(19),
		A => te_A,
		DOUT => te_DIN,
		DIN => te_DOUT,
		RD => te_RD,
		WR => te_WR
	);
	
end structural;
 
