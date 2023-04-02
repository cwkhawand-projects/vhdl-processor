library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VECTORED_INTERRUPT_CONTROLLER_tb is
end VECTORED_INTERRUPT_CONTROLLER_tb;

architecture Bench of VECTORED_INTERRUPT_CONTROLLER_tb is
    Signal Clk      : std_logic := '0';
    Signal Reset    : std_logic := '0';
    Signal IRQ_SERV : std_logic := '0';
    Signal IRQ0     : std_logic := '0';
    Signal IRQ1     : std_logic := '0';
    Signal IRQ      : std_logic;
    Signal VICPC    : std_logic_vector(31 downto 0);
    Signal OK       : boolean := TRUE;
begin

process
begin
    while (now <= 90 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

process
begin
    report "Starting vectored interrupt controller testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    IRQ0 <= '0';
    IRQ1 <= '0';
    wait for 10 ns;

    if (IRQ /= '0' or VICPC /= x"00000000") then
        report "IRQ0 interruption not working. Expected IRQ = 0 and VICPC = 0x00000000 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ0 <= '1';
    IRQ1 <= '0';
    wait for 10 ns;

    if (IRQ /= '1' or VICPC /= x"00000009") then
        report "IRQ0 interruption not working. Expected IRQ = 1 and VICPC = 0x00000009 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '1';
    wait for 10 ns;

    if (IRQ /= '0' or VICPC /= x"00000000") then
        report "IRQ0 acknowledgement not working. Expected IRQ = 0 and VICPC = 0x00000000 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '0';

    IRQ0 <= '0';
    IRQ1 <= '1';
    wait for 10 ns;

    if (IRQ /= '1' or VICPC /= x"00000015") then
        report "IRQ0 interruption not working. Expected IRQ = 1 and VICPC = 0x00000015 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '1';
    wait for 10 ns;

    if (IRQ /= '0' or VICPC /= x"00000000") then
        report "IRQ1 acknowledgement not working. Expected IRQ = 0 and VICPC = 0x00000000 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '0';

    IRQ0 <= '1';
    IRQ1 <= '1';
    wait for 10 ns;

    if (IRQ /= '1' or VICPC /= x"00000009") then
        report "IRQ0 interruption not working. Expected IRQ = 1 and VICPC = 0x00000009 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '1';
    wait for 10 ns;

    if (IRQ /= '0' or VICPC /= x"00000000") then
        report "IRQ0 acknowledgement not working. Expected IRQ = 0 and VICPC = 0x00000000 but got IRQ = " & to_string(IRQ) & " and VICPC = 0x" & to_hex_string(VICPC) severity warning;
        OK <= FALSE;
    end if;

    IRQ_SERV <= '0';
    
    if (OK) then
        report "Vectored interrupt controller testbench passed";
    else
        report "Vectored interrupt controller testbench failed";
    end if;

    wait;
end process;

VECTORED_INTERRUPT_CONTROLLER: entity work.VECTORED_INTERRUPT_CONTROLLER
    port map(
        Clk      => Clk,
        Reset    => Reset,
        IRQ_SERV => IRQ_SERV,
        IRQ0     => IRQ0,
        IRQ1     => IRQ1,
        IRQ      => IRQ,
        VICPC    => VICPC
    );
end Bench;