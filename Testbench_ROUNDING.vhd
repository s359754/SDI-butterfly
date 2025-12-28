library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rounding is
end entity;

architecture sim of tb_rounding is

    -- Segnali per collegare il DUT
    signal Clock        : std_logic := '0';
    signal rounding_in  : std_logic_vector(48 downto 0);
    signal rounding_out : std_logic_vector(23 downto 0);
	 signal shift_signal: std_logic := '0';
	 
    constant Tclk : time := 10 ns;

begin

    -- Istanziazione del DUT
    DUT : entity work.rounding
        port map (
            Clock        => Clock,
            rounding_in  => rounding_in,
            rounding_out => rounding_out,
				shift_signal => shift_signal
        );

    -- Clock a 100 MHz
    clk_proc : process
    begin
        Clock <= '0';
        wait for Tclk/2;
        Clock <= '1';
        wait for Tclk/2;
    end process;

    stim_proc : process
    begin
		  -- Caso 1
        rounding_in <= "1100101110101110110110000010001110010110011100111";
		  shift_signal <= '1';
        wait for Tclk;
		-- Caso 2
        rounding_in <= "1000111110100101110100001100101100111111001111000";
		  shift_signal <= '1';
        wait for Tclk;
		-- Caso 3
		rounding_in <= "0001011101011011101000101111101110011101001000000";
		shift_signal <= '0';
        wait for Tclk;
		-- Caso 4
        rounding_in <= "1000010011010101101000100011100111010111000101101";
		  shift_signal <= '1';
        wait for Tclk;
		-- Caso 5
		rounding_in <= "1100001011110000100110011110010100000111110110100";
		shift_signal <= '1';
        wait for Tclk;
		-- Caso 6
		rounding_in <= "0101010010100110000110101011100101011001111111011";
		shift_signal <= '0';
        wait for Tclk;
		-- Caso 7
		rounding_in <= "1101101010011110100111101101101101110111100011011";
		shift_signal <= '1';
        wait for Tclk;
		-- Caso 8
		rounding_in <= "0000110001110011000110100111001000011001111101011";
		shift_signal <= '0';
        wait for Tclk;
		-- Caso 9
		rounding_in <= "1101010100101011010101000000111001110110111010011";
		shift_signal <= '1';
        wait for Tclk;
		-- Caso 10
		rounding_in <= "1011001001010000110100111010111110011011101111100";
		shift_signal <= '1';
        wait for Tclk;
		-- Caso 11
		rounding_in <= "0001001001100001011111100111101001000011001100100";
		shift_signal <= '0';
        wait for Tclk;
		-- Caso 12
        rounding_in <= "1111111111111111111111111111111111111111111111111";
		  shift_signal <= '1';
        wait for Tclk;

        wait;
    end process;

end architecture sim;
