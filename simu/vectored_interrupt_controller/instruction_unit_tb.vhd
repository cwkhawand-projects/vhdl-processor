library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_UNIT_tb is
end entity;

architecture Bench of INSTRUCTION_UNIT_tb is
    Signal Clk          : std_logic;
    Signal Reset        : std_logic := '0';
    Signal nPCsel       : std_logic := '0';
    Signal Offset       : std_logic_vector(23 downto 0) := (others => '0');
    Signal IRQ          : std_logic := '0';
    Signal VICPC        : std_logic_vector(31 downto 0) := (others => '0');
    Signal IRQ_END      : std_logic := '0';
    Signal Instruction  : std_logic_vector(31 downto 0);
    Signal IRQ_SERV     : std_logic;
    Signal OK           : boolean := TRUE;
begin

process
begin
    while (now <= 75 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting instruction unit testbench...";

    Reset <= '1';
    wait for 10 ns;
    Reset <= '0';

    if (Instruction /= x"E3A01010") then
        report "Expected instruction E3A01010, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;
    nPCsel <= '1';
    Offset <= "000000000000000000000011";

    wait for 10 ns;

    if (Instruction /= x"E2811001") then
        report "Expected instruction E2811001, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    nPCsel <= '0';
    Offset <= "000000000000000000000000";

    wait for 10 ns;

    if (Instruction /= x"E351001A") then
        report "Expected instruction E351001A, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    wait for 10 ns;

    if (Instruction /= x"BAFFFFFB") then
        report "Expected instruction BAFFFFFB, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    IRQ <= '1';
    VICPC <= x"00000009";

    wait for 10 ns;

    if (Instruction /= x"E60F1000") then
        report "Expected instruction E60F1000, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    IRQ <= '0';

    wait for 10 ns;
    
    if (Instruction /= x"E28FF001") then
        report "Expected instruction E28FF001, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    IRQ_END <= '1';

    wait for 10 ns;

    if (Instruction /= x"E6012000") then
        report "Expected instruction E6012000, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    if (OK) then
        report "Instruction unit testbench passed";
    else
        report "Instruction unit testbench failed";
    end if;

    wait;
end process;

instruction_unit: entity work.INSTRUCTION_UNIT
    port map (
        Clk         => Clk,
        Reset       => Reset,
        nPCsel      => nPCsel,
        Offset      => Offset,
        IRQ         => IRQ,  
        VICPC       => VICPC,
        IRQ_END     => IRQ_END,
        Instruction => Instruction,
        IRQ_SERV    => IRQ_SERV
    );

end Bench;