library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity PROCESSOR_VIC_tb is
end entity;

architecture Bench of PROCESSOR_VIC_tb is
    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
    type regs is array(15 downto 0) of std_logic_vector(31 downto 0);

    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal IRQ0    : std_logic := '0';
    Signal IRQ1    : std_logic := '0';
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
        for i in 14 downto 0 loop
            result(i) := (others => '0');
        end loop;

        result(15) := x"00000030";
        
        return result;
    end init_registers;

    function check_memory(memory1 : mem; memory2 : mem) return boolean is
        variable pass : boolean := TRUE;
    begin
        for i in 0 to 63 loop
            if (memory1(i) /= memory2(i)) then
                report "Memory mismatch at address " & integer'image(i);
                report "Expected " & to_hex_string(memory1(i)) & " but got " & to_hex_string(memory2(i));
                pass := FALSE;
            end if;
        end loop;

        return pass;
    end check_memory;

    function check_registers(registers1 : regs; registers2 : regs) return boolean is
        variable pass : boolean := TRUE;
    begin
        for i in 0 to 15 loop
            if (registers1(i) /= registers2(i)) then
                report "Register mismatch at address " & integer'image(i);
                report "Expected " & to_hex_string(registers1(i)) & " but got " & to_hex_string(registers2(i));
                pass := FALSE;
            end if;
        end loop;

        return pass;
    end check_registers;
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

    --for i in 0 to 1 loop
        -- R1 = 0x10
        registers(1) := x"00000010";
        wait for 10 ns;

        -- R2 = 0
        registers(2) := x"00000000";
        wait for 10 ns;

        while (unsigned(registers(1)) < x"0000001A") loop
            -- R0 = DATAMEM[R1] 
            registers(0) := memory(to_integer(unsigned(registers(1))));
            wait for 10 ns;

            -- interrupt IRQ0
            if (unsigned(registers(1)) + x"00000001" = x"00000012") then
                IRQ0 <= '1';
            end if;
            
            -- R2 = R2 + R0
            registers(2) := std_logic_vector(unsigned(registers(2)) + unsigned(registers(0)));
            wait for 10 ns;

            -- interrupt IRQ0
            if (unsigned(registers(1)) + x"00000001" = x"00000012") then
                IRQ0 <= '0';
            end if;

            -- R1 = R1 + 1
            registers(1) := std_logic_vector(unsigned(registers(1)) + x"00000001");
            wait for 10 ns;

            -- interrupt IRQ0
            if (unsigned(registers(1)) = x"00000012") then                
                -- MEM[R15] = R1 
                memory(to_integer(unsigned(registers(15)))) := registers(1);
                wait for 10 ns;

                -- R15 = R15 + 1
                registers(15) := std_logic_vector(unsigned(registers(15)) + x"00000001");
                wait for 10 ns;

                -- MEM[R15] = R3
                memory(to_integer(unsigned(registers(15)))) := registers(3);
                wait for 10 ns;

                -- R3 = 0x10
                registers(3) := x"00000010";
                wait for 10 ns;

                -- R1 = MEM[R3]
                registers(1) := memory(to_integer(unsigned(registers(3))));
                wait for 10 ns;

                -- R1 = R1 + 1
                registers(1) := std_logic_vector(unsigned(registers(1)) + x"00000001");
                wait for 10 ns;

                -- MEM[R3] = R1
                memory(to_integer(unsigned(registers(3)))) := registers(1);
                wait for 10 ns;

                -- R3 = MEM[R15]
                registers(3) := memory(to_integer(unsigned(registers(15))));
                wait for 10 ns;

                -- R15 = R15 - 1
                registers(15) := std_logic_vector(unsigned(registers(15)) - x"00000001");
                wait for 10 ns;

                -- R1 <= MEM[R15]
                registers(1) := memory(to_integer(unsigned(registers(15))));
                wait for 10 ns;

                -- BX
                wait for 10 ns;
            end if;

            -- if R1 >= 0x1A 
            wait for 10 ns;
            if (unsigned(registers(1)) < x"0000001A") then
                -- BLT loop
                wait for 10 ns;
            end if;
        end loop;


        -- DATAMEM[R1] = R2
        memory(to_integer(unsigned(registers(1)))) := registers(2);
        wait for 10 ns;

        -- PC = PC + (-7)
        wait for 10 ns;

        OK <= check_memory(memory, << signal .processor_vic_tb.processor.processing_unit.memory.Memory : mem >>);
        OK <= check_registers(registers, << signal .processor_vic_tb.processor.processing_unit.registers.Registers : regs >>);

    --end loop;

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
        Display => Display
    );

end Bench;