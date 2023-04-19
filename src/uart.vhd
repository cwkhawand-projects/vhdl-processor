library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
  port (
    Clk     : in std_logic;
    Reset   : in std_logic;
    Data    : in std_logic_vector(7 downto 0);
    UARTWr  : in std_logic;
    Tx      : out std_logic
  );
end UART;

architecture RTL of UART is
    Signal Tick, Go : std_logic;
    Signal DataReg  : std_logic_vector(31 downto 0);
begin

  fdiv: entity work.FDIV
    port map (
      Clk   => Clk,
      Reset => Reset,
      Tick  => Tick
    );

  UART_Conf: entity work.REG_UART
  port map (
    Clk     => Clk,
    Reset   => Reset,
    DataIn  => x"000000"&Data,
    WrEn    => UARTWr,
    DataOut => DataReg,
    Go      => Go
  );

  UART_TX: entity work.UART_TX
    port map (
      Clk   => Clk,
      Reset => Reset,
      Go    => Go,
      Data  => DataReg(7 downto 0),
      Tick  => Tick,
      Tx    => Tx
    );

end RTL;