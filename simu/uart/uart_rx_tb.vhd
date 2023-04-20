library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX_tb is
end UART_RX_tb;

architecture Bench of UART_RX_tb is
    Signal Clk          : std_logic := '0';
    Signal Reset        : std_logic := '0';
    Signal Rx           : std_logic;
    Signal Tick_halfbit : std_logic;
    Signal Clear_fdiv   : std_logic;
    Signal Err          : std_logic;
    Signal Data         : std_logic_vector(7 downto 0);
    Signal RxIrq          : std_logic;
    Signal Reg          : std_logic_vector(9 downto 0);
    Signal OK           : boolean := TRUE;
begin

process
begin
    while (now <= 177950 ns) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

process
begin
    report "Starting UART Rx testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    Reg <= "1100110010";

    wait for 10 ns;

    for i in 0 to Reg'length - 1 loop
        Rx <= Reg(i);
        wait for 8680.6 ns;
    end loop;

    if Data /= Reg(8 downto 1) then
        report "Data mismatch" severity error;
        OK <= FALSE;
    end if;

    if RxIrq /= '1' then
        report "RxIrq not asserted" severity error;
        OK <= FALSE;
    end if;

    -- Test first bit error detection
    Rx <= '0';

    wait for 20 ns;

    Rx <= '1';

    wait until Err = '1' for 8680.6 ns;
    if Err /= '1' then
        report "Error at state E4 not triggered for Rx = '1'" severity error;
        OK <= FALSE;
    end if;

    -- Test last bit error detection
    Reg <= "0100110010";

    for i in 0 to Reg'length - 1 loop
        Rx <= Reg(i);
        if i /= Reg'length - 1 then
            wait for 8680.6 ns;
        else
            wait until Err = '1' for 8680.6 ns;
            if Err /= '1' then
                report "Error at state E10 not triggered for Rx = '0'" severity error;
                OK <= FALSE;
            end if;
        end if;
    end loop;

    wait for 10 ns;

    if (OK) then
        report "UART Rx testbench passed" severity note;
    else
        report "UART Rx testbench failed" severity error;
    end if;

    wait;
end process;

fdiv: entity work.FDIV
    port map (
        Clk       => Clk,
        Reset     => Reset or Clear_fdiv,
        Tick      => open,
        Tick_half => Tick_halfbit
    );

UART_RX: entity work.UART_RX
    port map (
        Clk          => Clk,
        Reset        => Reset,
        Rx           => Rx,
        Tick_halfbit => Tick_halfbit,
        Clear_fdiv   => Clear_fdiv,
        Err          => Err,
        Data         => Data,
        RxIrq          => RxIrq
    );

end Bench;