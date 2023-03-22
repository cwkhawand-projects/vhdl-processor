library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity PROCESSOR_tb is
end entity;

architecture Bench of PROCESSOR_tb is
    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
    type regs is array(15 downto 0) of std_logic_vector(31 downto 0);

    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal OK      : boolean := TRUE;

    function init_memory return mem is
        variable result : mem;
    begin
        for i in 63 downto 0 loop
            result(i) := std_logic_vector(to_unsigned(i, 32));
        end loop;
        
        return result;
    end init_memory;

    function init_registers return regs is
        variable result : regs;
    begin
        for i in 15 downto 0 loop
            result(i) := (others => '0');
        end loop;
        
        return result;
    end init_registers;
begin

process
begin
    while (now <= 1500 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
    variable memory : mem := init_memory;
    variable registers : regs := init_registers;
begin
    report "Starting processor testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    for i in 0 to 1 loop
        -- R1 = 0x20
        registers(1) := x"00000020";
        wait for 10 ns;

        -- R2 = 0
        registers(2) := x"00000000";
        wait for 10 ns;

        while (unsigned(registers(1)) < x"0000002A") loop
            -- R0 = DATAMEM[R1] 
            registers(0) := memory(to_integer(unsigned(registers(1))));
            wait for 10 ns;

            -- R2 = R2 + R0
            registers(2) := std_logic_vector(unsigned(registers(2)) + unsigned(registers(0)));
            wait for 10 ns;

            -- R1 = R1 + 1
            registers(1) := std_logic_vector(unsigned(registers(1)) + x"00000001");
            wait for 10 ns;

            -- if R1 >= 0x2A 
            wait for 10 ns;
            if (unsigned(registers(1)) < x"0000002A") then
                -- PC = PC + (-5) if N = 1
                wait for 10 ns;
            end if;
        end loop;

        -- DATAMEM[R1] = R2
        memory(to_integer(unsigned(registers(1)))) := registers(2);
        wait for 10 ns;

        -- PC = PC + (-7)
        wait for 10 ns;

        if (memory(to_integer(unsigned(registers(1)))) /= << signal .processor_tb.processor.processing_unit.memory.Memory : mem >>(to_integer(unsigned(registers(1))))) then
            report "Memory mismatch at address " & integer'image(to_integer(unsigned(registers(1))));
            report "Expected " & to_string(memory(to_integer(unsigned(registers(1))))) & " but got " & to_string(<< signal .processor_tb.processor.processing_unit.memory.Memory : mem >>(to_integer(unsigned(registers(1)))));
            OK <= FALSE;
        end if;
    end loop;

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
        Display => Display
    );

end Bench;