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
    Signal Instruction  : std_logic_vector(31 downto 0);
    Signal OK           : boolean := TRUE;
begin

process
begin
    while (now <= 35 ns) loop
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
    wait for 5 ns;
    Reset <= '0';

    if (Instruction /= x"E3A01020") then
        report "Expected instruction E3A01020, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;
    nPCsel <= '1';
    Offset <= "000000000000000000000011";

    wait for 10 ns;

    if (Instruction /= x"E3A02000") then
        report "Expected instruction E3A02000, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    npcsel <= '0';

    wait for 10 ns;

    if (Instruction /= x"E351002A") then
        report "Expected instruction E351002A, got " & to_hex_string(Instruction);
        OK <= FALSE;
    end if;

    wait for 10 ns;

    if (Instruction /= x"BAFFFFFB") then
        report "Expected instruction BAFFFFFB, got " & to_hex_string(Instruction);
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
        Instruction => Instruction
    );

end Bench;