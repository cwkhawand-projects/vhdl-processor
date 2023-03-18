library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG_tb is
end entity;

architecture Bench of REG_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal DataIn  : std_logic_vector(31 downto 0) := x"00000000";
    Signal DataOut : std_logic_vector(31 downto 0);
    Signal OK      : boolean := TRUE;
begin

process
begin
    while (now <= 20 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting register testbench...";

    Reset <= '1';
    wait for 5 ns;

    Reset <= '0';

    DataIn <= x"000000FA";
    wait for 10 ns;
    if (DataOut /= x"000000FA") then
        report "DataOut is not equal to DataIn";
        OK <= FALSE;
    end if;

    wait for 5 ns;

    DataIn <= x"CAF00000";
    wait for 10 ns;
    if (DataOut /= x"CAF00000") then
        report "DataOut is not equal to DataIn";
        OK <= FALSE;
    end if;

    if (OK) then
        report "Register testbench passed";
    else
        report "Register testbench failed";
    end if;

    wait;
end process;

reg: entity work.REG
    port map(
        Clk     => Clk,
        Reset   => Reset,
        DataIn  => DataIn,
        DataOut => DataOut
    );

end Bench;