library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SIGN_EXTENDER_tb is
end SIGN_EXTENDER_tb;

architecture Bench of SIGN_EXTENDER_tb is
    Signal E  : std_logic_vector(7 downto 0);
    Signal S  : std_logic_vector(31 downto 0);
    Signal OK : boolean := TRUE;
begin

process
begin
    report "Starting sign extender testbench...";

    E <= x"01";
    wait for 10 ns;
    if S /= x"00000001" then
        report "Expected S = 0x00000001, but got 0x" & to_hex_string(S);
        OK <= FALSE;
    end if;

    E <= x"F0";
    wait for 10 ns;
    if S /= x"FFFFFFF0" then
        report "Expected S = 0xFFFFFFF0, but got 0x" & to_hex_string(S);
        OK <= FALSE;
    end if;

    if (OK) then
        report "Sign extender testbench passed";
    else
        report "Sign extender testbench failed";
    end if;

    wait;
end process;

sign_extender: entity work.SIGN_EXTENDER
    generic map(
        N => 8
    )
    port map(
        E => E,
        S => S
    );
end Bench;