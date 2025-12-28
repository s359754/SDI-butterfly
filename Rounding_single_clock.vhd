library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Creazione entity
entity rounding is
	port(
		Clock:	IN	STD_LOGIC; -- Clock
		rounding_in : IN std_logic_vector(48 downto 0); -- 49 bit da arrotondare
		rounding_out: OUT std_logic_vector(23 downto 0); -- 24 bit arrotondati
		shift_signal: IN STD_LOGIC -- segnale per shiftare
	);
end entity;

-- Architecture del blocco rounding
architecture behavioural of rounding is

	--====================================================================================================---
	-- Inizializzazione componenti
	--====================================================================================================---
	component ROM is
	port(
		address : IN std_logic_vector(4 downto 0);
		memory_out: OUT std_logic_vector(2 downto 0));
	end component;
	
	component FD is
	generic(
		bus_length: INTEGER:= 24
	);
	port (	D:	in	STD_LOGIC_VECTOR ((bus_length-1) downto 0);
		E: in STD_LOGIC;	--ENABLE attivo alto
		CK:	in	STD_LOGIC;
		Q:	out	STD_LOGIC_VECTOR((bus_length-1) downto 0));
	end component;
	
	--====================================================================================================---
	-- Segnali interni al blocco rounding
	--====================================================================================================---
	
	signal mantissa : std_logic_vector(23 downto 0):= (others=>'0');
	signal dummy_memory_out: std_logic_vector(2 downto 0):= (others=>'0');
	signal address_memory : std_logic_vector(4 downto 0):= (others=>'0');
	signal reg_in : std_logic_vector(23 downto 0):= (others=>'0');
	signal bit_scarto : std_logic_vector(1 downto 0):= (others=>'0');
	signal shift_dummy: std_logic_vector(48 downto 0) := (others=>'0');
	
begin

	--====================================================================================================---
	-- Port map
	--====================================================================================================---
	pm_reg_rom_out : FD
		generic map (
			bus_length => 24
		)
		port map (
			D => reg_in,
			E => '1',
			CK => Clock,
			Q => rounding_out
	);
	
	pm_ROM : ROM
		port map(
		address => address_memory,
		memory_out => dummy_memory_out
	);
		
	
	--====================================================================================================---
    -- Shift senza processo logico (non impiega colpi di clock)
    --====================================================================================================---
    shift_dummy <=
        '0' & '0' & rounding_in(48 downto 2) when shift_signal = '1' else '0' & rounding_in(48 downto 1);

	--====================================================================================================---
	-- Creazione mantissa e bit di scarto
	--====================================================================================================---
		
	mantissa   <= shift_dummy(46 downto 23);
	bit_scarto <= shift_dummy(22 downto 21);

	--====================================================================================================---
	-- Creazione dell'indirizzo per leggere dalla ROM
	--====================================================================================================---
	
	-- address = (3 bit LSB mantissa) + (1 bit MSB scarto) + (1 bit OR con tutti gli altri dello scarto)
	address_memory <= mantissa(2 downto 0) & bit_scarto;

	--====================================================================================================---
	-- Inserimento dati nel registro d'uscita del blocco
	--====================================================================================================---

	reg_in <= mantissa(23 downto 3) & dummy_memory_out; -- 21 bit di mantissa & 3 bit arrotondamento
	
	
	
	


end architecture behavioural;