library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity PROCESSOR_UART_tb is
end entity;

architecture Bench_send_1 of PROCESSOR_UART_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal IRQ0    : std_logic := '0';
    Signal IRQ1    : std_logic := '0';
    Signal Data    : std_logic_vector(7 downto 0) := x"31";
    Signal Tx      : std_logic := '1';
    Signal Rx      : std_logic := '1';
    Signal OK      : boolean := TRUE;
begin

process
begin
    while (now <= 1200 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting processor testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    wait for 1 us;

    IRQ1 <= '1';
    
    wait until Tx = '0';

    wait for 8680.6 ns;
    wait for 30 ns;

    for i in 0 to Data'length - 1 loop
        if (Tx /= Data(i)) then
            report "Expected " & to_string(Data(i)) & " but got " & to_string(Tx) severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;
    

    wait for 10 ns;

    if (OK) then
        report "Processor testbench passed";
    else
        report "Processor testbench failed";
    end if;

    wait;
end process;

processor: entity work.Processor
    generic map (
        isTest => TRUE
    )
    port map (
        Clk     => Clk,
        Reset   => Reset,
        IRQ0    => IRQ0,
        IRQ1    => IRQ1,
        Display => Display,
        Tx      => Tx,
        Rx      => Rx
    );

end Bench_send_1;

architecture Bench_send_helloworld of PROCESSOR_UART_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal IRQ0    : std_logic := '0';
    Signal IRQ1    : std_logic := '0';
    Signal Data    : std_logic_vector(7 downto 0);
    Signal Tx      : std_logic := '1';
    Signal Rx      : std_logic := '1';
    Signal OK      : boolean := TRUE;

    type arr is array (natural range <>) of std_logic_vector;
    Signal Str     : arr (0 to 11)(7 downto 0) := (
        x"48", -- H
        x"45", -- E
        x"4C", -- L
        x"4C", -- L
        x"4F", -- O
        x"20", --
        x"57", -- W
        x"4F", -- O
        x"52", -- R
        x"4C", -- L
        x"44", -- D
        x"21"  -- !
    );
begin

process
begin
    while (now <= 1200 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting processor testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    wait for 1 us;

    IRQ1 <= '1';

    wait for 40 ns;

    IRQ1 <= '0';

    for i in 0 to Str'length - 1 loop
        Data <= Str(i);

        wait until Tx = '0';

        wait for 8680.6 ns;
        wait for 30 ns;

        for j in 0 to Data'length - 1 loop
            if (Tx /= Data(j)) then
                report "Expected " & to_string(Data(j)) & " but got " & to_string(Tx) severity error;
                OK <= FALSE;
            end if;
            wait for 8680.6 ns;
        end loop;
    end loop;

    wait for 10 ns;

    if (OK) then
        report "Processor testbench passed";
    else
        report "Processor testbench failed";
    end if;

    wait;
end process;

processor: entity work.Processor
    generic map (
        isTest => TRUE
    )
    port map (
        Clk     => Clk,
        Reset   => Reset,
        IRQ0    => IRQ0,
        IRQ1    => IRQ1,
        Display => Display,
        Tx      => Tx,
        Rx      => Rx
    );

end Bench_send_helloworld;

architecture Bench_receive of PROCESSOR_UART_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal IRQ0    : std_logic := '0';
    Signal IRQ1    : std_logic := '0';
    Signal Data    : std_logic_vector(7 downto 0);
    Signal Tx      : std_logic := '1';
    Signal Rx      : std_logic := '1';
    Signal OK      : boolean := TRUE;

    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);

    type arr is array (natural range <>) of std_logic_vector;
    Signal Str     : arr (0 to 12)(7 downto 0) := (
        x"56", -- V
        x"48", -- H
        x"44", -- D
        x"4C", -- L
        x"20", --
        x"49", -- I
        x"53", -- S
        x"20", --
        x"43", -- C
        x"4F", -- O
        x"4F", -- O
        x"4C", -- L
        x"21"  -- !
    );
begin

process
begin
    while (now <= 1200 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting processor testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    wait for 1 us;

    for i in 0 to Str'length - 1 loop
        Rx <= '0';
        wait for 8680.6 ns;

        for j in 0 to Data'length - 1 loop
            Rx <= Str(i)(j);
            wait for 8680.6 ns;
        end loop;

        Rx <= '1';
        wait for 8680.6 ns;
    end loop;

    if (x"000000"&Str(12) /= << signal .processor_uart_tb.processor.processing_unit.memory.Memory: mem >>(52)) then
        report "Expected " & to_hex_string(Str(12)) & " but got " & to_hex_string(<< signal .processor_uart_tb.processor.processing_unit.memory.Memory: mem >>(52)) severity error;
        OK <= FALSE;
    end if;
    
    for i in 1 to 11 - 1 loop
        if (x"000000"&Str(i) /= << signal .processor_uart_tb.processor.processing_unit.memory.Memory: mem >>(52+i)) then
            report "Expected " & to_hex_string(Str(i)) & " but got " & to_hex_string(<< signal .processor_uart_tb.processor.processing_unit.memory.Memory: mem >>(52+i)) severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    wait for 10 ns;

    if (OK) then
        report "Processor testbench passed";
    else
        report "Processor testbench failed";
    end if;

    wait;
end process;

processor: entity work.Processor
    generic map (
        isTest => TRUE
    )
    port map (
        Clk     => Clk,
        Reset   => Reset,
        IRQ0    => IRQ0,
        IRQ1    => IRQ1,
        Display => Display,
        Tx      => Tx,
        Rx      => Rx
    );

end Bench_receive;