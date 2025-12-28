library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TBROM is
end entity;

architecture sim of TBROM is

    signal address  : std_logic_vector(4 downto 0);
    signal memory_out : std_logic_vector(2 downto 0);

begin

    -- Istanziazione della ROM
    DUT: entity work.ROM
        port map (
            address  => address,
            memory_out => memory_out
        );

    stim_proc: process
    begin
        for i in 0 to 31 loop
            address <= std_logic_vector(to_unsigned(i, 5));
            wait for 10 ns;
        end loop;

        -- Fine simulazione
        wait;
    end process;

end architecture sim;
