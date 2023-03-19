library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRUCTION_UNIT is
  port (
    Clk         : in std_logic;
    Reset       : in std_logic;
    nPCsel      : in std_logic;
    Offset      : in std_logic_vector(23 downto 0);
    Instruction : out std_logic_vector(31 downto 0)
  );
end INSTRUCTION_UNIT;

architecture RTL of INSTRUCTION_UNIT is
    Signal A, B, PC_mux, PC, Offset_extended : std_logic_vector(31 downto 0);
begin

A <= std_logic_vector(unsigned(PC) + 1);
B <= std_logic_vector(unsigned(A) + unsigned(Offset_extended));

mux2v1: entity work.MUX2V1
  port map (
    A   => A,
    B   => B,
    COM => nPCsel,
    S   => PC_mux
  );

reg_pc: entity work.REG
  port map (
    Clk     => Clk,
    Reset   => Reset,
    DataIn  => PC_mux,
    DataOut => PC
  );

instruction_memory: entity work.INSTRUCTION_MEMORY
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