library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSING_UNIT_TB is
end PROCESSING_UNIT_TB;

architecture Bench of PROCESSING_UNIT_TB is
    Signal Clk      : std_logic;
    Signal Reset    : std_logic;
    Signal RA       : std_logic_vector(3 downto 0);
    Signal RB       : std_logic_vector(3 downto 0);
    Signal RW       : std_logic_vector(3 downto 0);
    Signal MemWr    : std_logic := '0';
    Signal RegWr    : std_logic := '0';
    Signal Imm8     : std_logic_vector(7 downto 0) := x"00";
    Signal MemtoReg : std_logic := '0';
    Signal ALUctr   : std_logic_vector(2 downto 0);
    Signal ALUSrc   : std_logic := '0';
    Signal ALUout   : std_logic_vector(31 downto 0);
    Signal Flags    : std_logic_vector(3 downto 0);
    Signal OK       : boolean := TRUE;
begin
process
begin
    while (now <= 160 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting processing unit testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';
    MemWr <= '0';

    -- Add 2 registers (R0 + R15)
    ALUctr <= "000";
    RA <= x"0";
    RB <= x"F";
    RW <= x"0";
    RegWr <= '1';
    ALUSrc <= '0';
    MemtoReg <= '0';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"0";
    wait for 10 ns;

    -- Add immediate value to register (R0 + 10)
    ALUctr <= "000";
    RA <= x"0";
    RW <= x"1";
    Imm8 <= x"0A";
    RegWr <= '1';
    ALUSrc <= '1';
    MemtoReg <= '0';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"1";
    wait for 10 ns;

    -- Subtract 2 registers (R1 - R0)
    ALUctr <= "010";
    RA <= x"1";
    RB <= x"0";
    RW <= x"2";
    RegWr <= '1';
    ALUSrc <= '0';
    MemtoReg <= '0';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"2";
    wait for 10 ns;

    -- Subtract immediate value from register (R1 - 10)
    ALUctr <= "010";
    RA <= x"1";
    RW <= x"3";
    Imm8 <= x"0A";
    RegWr <= '1';
    ALUSrc <= '1';
    MemtoReg <= '0';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"3";
    wait for 10 ns;

    -- Copy register to register (R6 = R1)
    ALUctr <= "011";
    RA <= x"1";
    RW <= x"6";
    RegWr <= '1';
    ALUSrc <= '0';
    MemtoReg <= '0';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"6";
    wait for 10 ns;

    -- Write to memory at address R2 = 0x0000000A value R3 = 0x00000030
    ALUctr <= "011";
    RA <= x"2";
    RB <= x"3";
    MemWr <= '1';
    RegWr <= '0';
    ALUSrc <= '0';
    MemtoReg <= '1';
    wait for 10 ns;
    MemWr <= '0';
    wait for 10 ns;

    -- Read from memory at address R2 = 0x0000000A to register R7
    ALUctr <= "011";
    RA <= x"2";
    RW <= x"7";
    RegWr <= '1';
    ALUSrc <= '0';
    MemtoReg <= '1';
    wait for 10 ns;
    RegWr <= '0';

    -- Return register content
    ALUctr <= "011";
    MemtoReg <= '0';
    RA <= x"7";
    wait for 10 ns;

    wait;
end process;

CHECKS: process
begin
    wait for 21 ns;
    if (ALUout /= x"00000030") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x00000030" severity error;
        OK <= FALSE;
    end if;

    wait for 20 ns;
    if (ALUout /= x"0000003A") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x0000003A" severity error;
        OK <= FALSE;
    end if;

    wait for 20 ns;
    if (ALUout /= x"0000000A") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x0000000A" severity error;
        OK <= FALSE;
    end if;
    
    wait for 20 ns;
    if (ALUout /= x"00000030") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x00000030" severity error;
        OK <= FALSE;
    end if;

    wait for 20 ns;
    if (ALUout /= x"0000003A") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x0000003A" severity error;
        OK <= FALSE;
    end if;

    wait for 20 ns;
    if (ALUout /= x"00000030") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x00000030" severity error;
        OK <= FALSE;
    end if;

    wait for 20 ns;
    if (ALUout /= x"00000030") then
        report "ALUout = 0x" & to_hex_string(ALUout) & " expected 0x00000030" severity error;
        OK <= FALSE;
    end if;

    if (OK) then
        report "Processing unit testbench passed" severity note;
    else
        report "Processing unit testbench failed" severity error;
    end if;

    wait;
end process;

PROCESSING_UNIT: entity work.PROCESSING_UNIT(RTL)
    port map (
        Clk      => Clk,
        Reset    => Reset,
        RA       => RA,
        RB       => RB,
        RW       => RW,
        MemWr    => MemWr,
        RegWr    => RegWr,
        Imm8     => Imm8,
        MemtoReg => MemtoReg,
        ALUctr   => ALUctr,
        ALUSrc   => ALUSrc,
        ALUout   => ALUout,
        Flags    => Flags
    );

end Bench;