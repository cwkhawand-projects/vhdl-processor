library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXTENDER_tb is
end entity;

architecture Bench of EXTENDER_tb is
    Signal E  : std_logic_vector(23 downto 0);
    Signal S  : std_logic_vector(31 downto 0);
    Signal OK : boolean := TRUE;
begin

UUT: process
begin
    report "Starting PC extender testbench...";

    E <= "000000000000000000001010";
    wait for 5 ns;
    if (S /= x"0000000A") then
        report "Expected S = 0x0000000A, but got S = " & to_hex_string(S);
        OK <= FALSE;
    end if;

    E <= "111100000000000000001010";
    wait for 5 ns;
    if (S /= x"00F0000A") then
        report "Expected S = 0x00F0000A, but got S = " & to_hex_string(S);
        OK <= FALSE;
    end if;

    if (OK) then
        report "Extender testbench passed";
    else
        report "Extender testbench failed";
    end if;

    wait;
end process;

pc_extender: entity work.EXTENDER
    port map (
        E => E,
        S => S
    );

end Bench;