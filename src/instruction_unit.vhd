library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRUCTION_UNIT is
  port (
    Clk         : in std_logic;
    Reset       : in std_logic;
    nPCsel      : in std_logic;
    Offset      : in std_logic_vector(23 downto 0);
    IRQ         : in std_logic;
    VICPC       : in std_logic_vector(31 downto 0);
    IRQ_END     : in std_logic;
    Instruction : out std_logic_vector(31 downto 0);
    IRQ_SERV    : out std_logic
  );
end INSTRUCTION_UNIT;

architecture RTL of INSTRUCTION_UNIT is
    Signal A, B, PC_mux, PC, Offset_extended : std_logic_vector(31 downto 0);
    Signal LR_reg, LR : std_logic_vector(31 downto 0);
begin

A <= std_logic_vector(unsigned(PC) + 1);
B <= std_logic_vector(unsigned(A) + unsigned(Offset_extended));

process(all)
begin
  if (IRQ_END = '0') then
    if (IRQ = '1') then
      LR_reg <= PC;
      PC_mux <= VICPC;
      IRQ_SERV <= '1';
    else
      IRQ_SERV <= '0';
      
      if (nPCsel = '0') then
        PC_mux <= A;
      else
        PC_mux <= B;
      end if;

      LR_reg <= LR;
    end if;
  else
    if (IRQ_END = '1') then
      PC_mux <= std_logic_vector(unsigned(LR) + 1);
      LR_reg <= LR;
    end if;
  end if;
end process;

reg_pc: entity work.REG
  port map (
    Clk     => Clk,
    Reset   => Reset,
    DataIn  => PC_mux,
    DataOut => PC
  );

reg_lr: entity work.REG
  port map (
    Clk     => Clk,
    Reset   => Reset,
    DataIn  => LR_reg,
    DataOut => LR
  );

instruction_memory: entity work.INSTRUCTION_MEMORY_IRQ
  port map (
    PC          => PC,
    Instruction => Instruction
  );

pc_extender: entity work.SIGN_EXTENDER
  generic map (
    N => 24
  )
  port map (
    E => Offset,
    S => Offset_extended
  );

end RTL;