library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_tb is
end UART_tb;

architecture Bench of UART_tb is
    signal Clk    : std_logic;
    signal Reset  : std_logic;
    signal Data   : std_logic_vector(7 downto 0);
    signal UARTWr : std_logic;
    signal Tx     : std_logic;
    signal Reg    : std_logic_vector(9 downto 0) := (others => '0');
    signal OK     : boolean := TRUE;
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
    report "Starting UART testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    Data <= "10011001";
    UARTWr <= '1';

    wait until << signal .uart_tb.uart.Tick: std_logic >> = '1';
    wait for 30 ns;

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "Expected " & to_string(Reg(i)) & " but got " & to_string(Tx) severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "UART testbench passed" severity note;
    else
        report "UART testbench failed" severity error;
    end if;

    wait;
end process;

UART: entity work.UART
    port map (
        Clk    => Clk,
        Reset  => Reset,
        Data   => Data,
        UARTWr => UARTWr,
        Tx     => Tx
    );

end Bench;