library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2V1_tb is
end MUX2V1_tb;

architecture Bench of MUX2V1_tb is
    Signal A, B : std_logic_vector(31 downto 0);
    Signal COM  : std_logic;
    Signal S    : std_logic_vector(31 downto 0);
    Signal OK   : boolean := TRUE;
begin

process
begin
    report "Starting mux2v1 testbench...";

    A <= x"00000000";
    B <= x"FFFFFFFF";
    COM <= '0';
    wait for 5 ns;
    if S /= x"00000000" then
        report "COM = 0, expected S = A = 0x00000000, got S = 0x" & to_hex_string(S) severity error;
        OK <= FALSE;
    end if;

    COM <= '1';
    wait for 5 ns;
    if S /= x"FFFFFFFF" then
        report "COM = 1, expected S = B = 0xFFFFFFFF, got S = 0x" & to_hex_string(S) severity error;
        OK <= FALSE;
    end if;

    if (OK) then
        report "Mux2v1 testbench passed" severity note;
    else
        report "Mux2v1 testbench failed" severity error;
    end if;

    wait;
end process;

mux2v1: entity work.MUX2V1
    port map (
        A => A,
        B => B,
        COM => COM,
        S => S
    );

end Bench;