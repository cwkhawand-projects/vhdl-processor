library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSOR is
  generic (
    isTest : boolean := FALSE
  );
  port (
    Clk     : in STD_LOGIC;
    Reset   : in STD_LOGIC;
    IRQ0    : in STD_LOGIC;
    IRQ1    : in STD_LOGIC;
    Display : out STD_LOGIC_VECTOR(31 downto 0)
  );
end PROCESSOR;

architecture RTL of PROCESSOR is
  Signal nPCSel      : STD_LOGIC;
  Signal Flags       : STD_LOGIC_VECTOR(3 downto 0);
  Signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
  Signal PSREn       : std_logic;
  Signal RegWr       : std_logic;
  Signal RegSel      : std_logic;
  Signal ALUctr      : std_logic_vector(2 downto 0);
  Signal ALUSrc      : std_logic;
  Signal WrSrc       : std_logic;
  Signal MemWr       : std_logic;
  Signal RegAff      : std_logic;
  Signal Imm8        : std_logic_vector(7 downto 0);
  Signal Imm24       : std_logic_vector(23 downto 0);
  Signal UARTWr      : std_logic;
  Signal ALUout      : std_logic_vector(31 downto 0);
  Signal IRQ         : std_logic;
  Signal VICPC       : std_logic_vector(31 downto 0);
  Signal IRQ_END     : std_logic;
  Signal IRQ_SERV    : std_logic;
begin
  instruction_unit: entity work.INSTRUCTION_UNIT(RTL)
    port map (
      Clk => Clk,
      Reset => Reset,
      nPCSel => nPCSel,
      Offset => Imm24,
      IRQ => IRQ,
      VICPC => VICPC,
      IRQ_END => IRQ_END,
      Instruction => Instruction,
      IRQ_SERV => IRQ_SERV
    );

  instruction_decoder: entity work.INSTRUCTION_DECODER(RTL)
    port map (
      Instruction => Instruction,
      Flags => Flags,
      IRQ => IRQ,
      nPCSel => nPCSel,
      PSREn => PSREn,
      RegWr => RegWr,
      RegSel => RegSel,
      ALUctr => ALUctr,
      ALUSrc => ALUSrc,
      WrSrc => WrSrc,
      MemWr => MemWr,
      RegAff => RegAff,
      Imm8 => Imm8,
      Imm24 => Imm24,
      UARTWr => UARTWr,
      IRQ_END => IRQ_END
    );

  processing_unit: entity work.PROCESSING_UNIT(RTL)
    generic map (
      isTest => isTest
    )
    port map (
      Clk     => Clk,
      Reset   => Reset,
      Rn      => Instruction(19 downto 16),
      Rm      => Instruction(3 downto 0),
      Rd      => Instruction(15 downto 12),
      MemWr   => MemWr,
      RegWr   => RegWr,
      RegSel  => RegSel,
      RegAff  => RegAff,
      Imm8    => Imm8,
      WrSrc   => WrSrc,
      ALUctr  => ALUctr,
      ALUSrc  => ALUSrc,
      PSREn   => PSREn,
      ALUout  => open,
      Flags   => Flags,
      Display => Display
    );

    vectored_interrupt_controller: entity work.VECTORED_INTERRUPT_CONTROLLER(RTL)
      port map (
        Clk      => Clk,
        Reset    => Reset,
        IRQ_SERV => IRQ_SERV,
        IRQ0     => IRQ0,
        IRQ1     => IRQ1,
        IRQ      => IRQ,
        VICPC    => VICPC
      );
end RTL;