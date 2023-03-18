library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROCESSING_UNIT is
  port (
    Clk      : in std_logic;
    Reset    : in std_logic;
    RA       : in std_logic_vector(3 downto 0);
    RB       : in std_logic_vector(3 downto 0);
    RW       : in std_logic_vector(3 downto 0);
    MemWr    : in std_logic;
    RegWr    : in std_logic;
    Imm8     : in std_logic_vector(7 downto 0);
    MemtoReg : in std_logic;
    ALUctr   : in std_logic_vector(2 downto 0);
    ALUSrc   : in std_logic;
    ALUout   : out std_logic_vector(31 downto 0);
    Flags    : out std_logic_vector(3 downto 0)
  );
end PROCESSING_UNIT;

architecture RTL of PROCESSING_UNIT is
    Signal BusA, BusB, BusW, Imm         : std_logic_vector(31 downto 0);
    Signal BusB_mux, BusW_unmux, DataOut : std_logic_vector(31 downto 0);
    Signal N, Z, C, V                    : std_logic;
begin

  ALUout <= BusW;
  Flags  <= N & Z & C & V;

  registers: entity work.REGISTERS(RTL)
    port map (
      Clk   => Clk,
      Reset => Reset,
      W     => BusW,
      RA    => RA,
      RB    => RB,
      RW    => RW,
      WE    => RegWr,
      A     => BusA,
      B     => BusB
    );

  sign_extender: entity work.SIGN_EXTENDER(RTL)
    generic map (
      N => 8
    )
    port map (
      E => Imm8,
      S => Imm
    );

  mux2v1_imm: entity work.MUX2V1(RTL)
    port map (
      A   => BusB,
      B   => Imm,
      COM => ALUSrc,
      S   => BusB_mux
    );

  ALU: entity work.ALU(RTL)
    port map (
      OP => ALUctr,
      A  => BusA,
      B  => BusB_mux,
      S  => BusW_unmux,
      N  => N,
      Z  => Z,
      C  => C,
      V  => V
    );

  memory: entity work.MEMORY(RTL)
    port map (
      Clk   => Clk,
      Reset => Reset,
      DataIn => BusB,
      DataOut => DataOut,
      Addr => BusW_unmux(5 downto 0),
      WrEn => MemWr
    );

  mux2v1_mem: entity work.MUX2V1(RTL)
    port map (
      A   => BusW_unmux,
      B   => DataOut,
      COM => MemtoReg,
      S   => BusW
    );
end RTL;