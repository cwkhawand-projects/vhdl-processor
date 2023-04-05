library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INSTRUCTION_DECODER is
  port (
    Instruction : in std_logic_vector(31 downto 0);
    Flags       : in std_logic_vector(3 downto 0);
    IRQ         : in std_logic;
    nPCSel      : out std_logic;
    PSREn       : out std_logic;
    RegWr       : out std_logic;
    RegSel      : out std_logic;
    ALUctr      : out std_logic_vector(2 downto 0);
    ALUSrc      : out std_logic;
    WrSrc       : out std_logic;
    MemWr       : out std_logic;
    RegAff      : out std_logic;
    Imm8        : out std_logic_vector(7 downto 0);
    Imm24       : out std_logic_vector(23 downto 0);
    IRQ_END     : out std_logic
  );
end INSTRUCTION_DECODER;

architecture RTL of INSTRUCTION_DECODER is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BX);
    signal current_instruction : enum_instruction;
begin

instruction_assigner: process(Instruction)
begin
    if (Instruction = x"EB000000") then
        current_instruction <= BX;
    elsif (Instruction(27 downto 26) = "00") then
        if (Instruction(24 downto 21) = "1101") then
            current_instruction <= MOV;
        elsif (Instruction(24 downto 21) = "0100") then
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
        if (Instruction(31 downto 28) = "1110") then
            if (Instruction(25 downto 24) = "11") then
                current_instruction <= BX;
            else
                current_instruction <= BAL;
            end if;
        elsif (Instruction(31 downto 28) = "1011") then
            current_instruction <= BLT;
        end if;
    end if;
end process;

instruction_decoder: process(current_instruction, Instruction)
begin
    case current_instruction is
        when ADDi =>
            IRQ_END <= '0';
            nPCSel <= '0';
            RegWr <= '1';
            ALUSrc <= '1';
            ALUctr <= "000";
            PSREn <= '1';
            MemWr <= '0';
            WrSrc <= '0';
            RegSel <= '1';
            RegAff <= '0';
            Imm8 <= Instruction(7 downto 0);
            Imm24 <= (others => '0');
        when ADDr =>
            IRQ_END <= '0';
            nPCSel <= '0';
            RegWr <= '1';
            ALUSrc <= '0';
            ALUctr <= "000";
            PSREn <= '1';
            MemWr <= '0';
            WrSrc <= '0';
            RegSel <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
        when BAL =>
            IRQ_END <= '0';
            nPCSel <= '1';
            RegWr <= '0';
            ALUSrc <= '1';
            ALUctr <= "011";
            PSREn <= '0';
            MemWr <= '0';
            WrSrc <= '0';
            RegSel <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= Instruction(23 downto 0);
        when BLT =>
            IRQ_END <= '0';
            if (Flags(3) = '1') then
                nPCSel <= '1';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUctr <= "011";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
                Imm8 <= (others => '0');
                Imm24 <= Instruction(23 downto 0);
            else
                nPCSel <= '1';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUctr <= "011";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
                Imm8 <= (others => '0');
                Imm24 <= (others => '0');
            end if;
        when CMP =>
            IRQ_END <= '0';
            nPCSel <= '0';
            RegWr <= '0';
            ALUSrc <= '1';
            ALUctr <= "010";
            PSREn <= '1';
            MemWr <= '0';
            WrSrc <= '0';
            RegSel <= '1';
            RegAff <= '0';
            Imm8 <= Instruction(7 downto 0);
            Imm24 <= (others => '0');
        when LDR =>
            IRQ_END <= '0';
            nPCSel <= '1';
            RegWr <= '1';
            ALUSrc <= '0';
            ALUctr <= "011";
            PSREn <= '0';
            MemWr <= '0';
            WrSrc <= '1';
            RegSel <= '1';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
        when MOV =>
            IRQ_END <= '0';
            nPCSel <= '0';
            RegWr <= '1';
            ALUSrc <= '1';
            ALUctr <= "001";
            PSREn <= '0';
            MemWr <= '0';
            WrSrc <= '0';
            RegSel <= '1';
            RegAff <= '0';
            Imm8 <= Instruction(7 downto 0);
            Imm24 <= (others => '0');
        when STR =>
            IRQ_END <= '0';
            nPCSel <= '0';
            RegWr <= '0';
            ALUSrc <= '0';
            ALUctr <= "011";
            PSREn <= '0';
            MemWr <= '1';
            WrSrc <= '0';
            RegSel <= '1';
            RegAff <= '1';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
        when BX =>
            IRQ_END <= '1';
            nPCSel <= '0';
            PSREn <= '0';
            RegWr <= '0';
            RegSel <= '0';
            ALUctr <= "000";
            ALUSrc <= '0';
            WrSrc <= '0';
            MemWr <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
        when others =>
            IRQ_END <= '0';
            nPCSel <= '0';
            PSREn <= '0';
            RegWr <= '0';
            RegSel <= '0';
            ALUctr <= "000";
            ALUSrc <= '0';
            WrSrc <= '0';
            MemWr <= '0';
            RegAff <= '0';
            Imm8 <= (others => '0');
            Imm24 <= (others => '0');
    end case;
end process;

end RTL;