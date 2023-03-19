library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INSTRUCTION_DECODER is
  port (
    Instruction : in std_logic_vector(31 downto 0);
    Flags       : in std_logic_vector(3 downto 0);
    nPCSel      : out std_logic;
    PSREn       : out std_logic;
    RegWr       : out std_logic;
    RegSel      : out std_logic;
    ALUctr      : out std_logic_vector(2 downto 0);
    MemToReg    : out std_logic;
    ALUSrc      : out std_logic;
    WrSrc       : out std_logic;
    MemWr       : out std_logic;
    RegAff      : out std_logic;
    Imm8        : out std_logic_vector(7 downto 0);
    Imm24       : out std_logic_vector(23 downto 0);
    Display     : out std_logic_vector(31 downto 0);
  );
end INSTRUCTION_DECODER;

architecture RTL of INSTRUCTION_DECODER is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
    signal current_instruction : enum_instruction;
begin

instruction_assigner: process(Instruction)
begin
    if (Instruction(27 downto 26) = "00") then
        if (Instruction(24 downto 21) = "1101") then
            current_instruction <= MOV;
        elsif (Instruction(24 downto 21) = "0000") then
            if (Instruction(25) = '0') then
                current_instruction <= ADDr;
            else
                current_instruction <= ADDi;
            end if;
        elsif (Instruction(24 downto 21) = "1010") then
            current_instruction <= CMP;
        end if;
    elsif (Instruction(27 downto 26) = "01") then
        if (Instruction(20) = '0') then
            current_instruction <= STR;
        else
            current_instruction <= LDR;
        end if;
    elsif (Instruction(27 downto 26) = "10") then
        if (Instruction(24 downto 21) = "1110") then
            current_instruction <= BAL;
        elsif (Instruction(24 downto 21) = "1011") then
            current_instruction <= BLT;
        end if;
    end if;
end process;

decoder: process(current_instruction)
begin
    case current_instruction is
        when MOV =>
            nPCSel <= '0';
            PSREn <= '0';
            RegWr <= '0';
            RegSel <= '0';
            ALUctr <= "000";
            MemToReg <= '0';
            ALUSrc <= '0';
            WrSrc <= '0';
            MemWr <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
            Display <= (others => '0');
        when others =>
            nPCSel <= '0';
            PSREn <= '0';
            RegWr <= '0';
            RegSel <= '0';
            ALUctr <= "000";
            MemToReg <= '0';
            ALUSrc <= '0';
            WrSrc <= '0';
            MemWr <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
            Display <= (others => '0');
    end case;
end process;

end RTL;