library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX_tb is
end UART_TX_tb;

architecture Bench of UART_TX_tb is
    signal Clk         : std_logic := '0';
    signal Reset       : std_logic := '0';
    signal Go          : std_logic := '0';
    signal Data        : std_logic_vector(7 downto 0) := (others => '0');
    signal Tick        : std_logic := '0';
    signal Tx          : std_logic;
    signal Reg         : std_logic_vector(9 downto 0) := (others => '0');
    signal OK          : boolean := TRUE;
begin

process
begin
    while (now <= 100 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

    Reg <= '1' & Data & '0';

process
begin
    report "Starting UART Tx testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    Data <= "10011001";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "Expected " & to_string(Reg(i)) & " but got " & to_string(Tx) severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "UART Tx testbench passed" severity note;
    else
        report "UART Tx testbench failed" severity error;
    end if;

    wait;
end process;

fdiv: entity work.FDIV
    port map (
        Clk   => Clk,
        Reset => Reset,
        Tick  => Tick
    );

UART_TX: entity work.UART_TX
    port map (
        Clk   => Clk,
        Reset => Reset,
        Go    => Go,
        Data  => Data,
        Tick  => Tick,
        Tx    => Tx
    );

end Bench;