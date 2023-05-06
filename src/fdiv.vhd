library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FDIV is
    generic (
        BaudRate : integer := 115_200;
        ClockFrequency : integer := 50_000_000
    );
    port (
        Clk       : in std_logic;
        Reset     : in std_logic;
        Tick      : out std_logic;
        Tick_half : out std_logic
    );
end FDIV;

architecture RTL of FDIV is
    signal countTo : integer;
begin
    countTo <= ClockFrequency / BaudRate - 1;

    process (Clk, Reset)
        variable counter : integer := 0;
    begin
        if Reset = '1' then
            counter := 0;
            Tick <= '0';
            Tick_half <= '0';
        elsif rising_edge(Clk) then
            counter := counter + 1;

            if counter >= countTo then
                Tick <= '1';
                Tick_half <= '1';
                counter := 0;
            elsif counter = countTo/2 then
                Tick_half <= '1';
            else
                Tick <= '0';
                Tick_half <= '0';
            end if;
        end if;
    end process;
end RTL;