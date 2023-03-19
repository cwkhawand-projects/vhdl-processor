library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PSR_tb is
end entity;

architecture Bench of PSR_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal DataIn  : std_logic_vector(31 downto 0) := x"00000000";
    Signal WrEn    : std_logic := '0';
    Signal DataOut : std_logic_vector(31 downto 0);
    Signal OK      : boolean := TRUE;
begin

process
begin
    while (now <= 40 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting PSR testbench...";

    Reset <= '1';
    wait for 5 ns;

    Reset <= '0';
    WrEn <= '1';

    DataIn <= x"000000FA";
    wait for 10 ns;
    if (DataOut /= x"000000FA") then
        report "Expected DataOut to be 0x000000FA, but it was 0x" & to_hex_string(DataOut);
        OK <= FALSE;
    end if;

    wait for 5 ns;

    DataIn <= x"CAF00000";
    wait for 10 ns;
    if (DataOut /= x"CAF00000") then
        report "Expected DataOut to be 0xCAF00000, but it was 0x" & to_hex_string(DataOut);
        OK <= FALSE;
    end if;

    wait for 5 ns;

    WrEn <= '0';
    DataIn <= x"00000000";
    wait for 10 ns;
    if (DataOut /= x"CAF00000") then
        report "Expected DataOut to be 0xCAF00000, but it was 0x" & to_hex_string(DataOut);
        OK <= FALSE;
    end if;

    if (OK) then
        report "PSR testbench passed";
    else
        report "PSR testbench failed";
    end if;

    wait;
end process;

psr: entity work.PSR
    port map(
        Clk     => Clk,
        Reset   => Reset,
        DataIn  => DataIn,
        WrEn    => WrEn,
        DataOut => DataOut
    );

end Bench;