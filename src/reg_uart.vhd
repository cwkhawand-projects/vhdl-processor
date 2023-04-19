library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_UART is
  port (
    Clk     : in STD_LOGIC;
    Reset   : in STD_LOGIC;
    DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
    WrEn    : in STD_LOGIC;
    DataOut : out STD_LOGIC_VECTOR(31 downto 0);
    Go      : out STD_LOGIC
  );
end REG_UART;

architecture RTL of REG_UART is
begin

process(Clk, Reset)
begin
  if (Reset = '1') then
    DataOut <= (others => '0');
    Go <= '0';
  elsif rising_edge(Clk) then
    if (WrEn = '1') then
        Go <= '1';
        DataOut <= DataIn;
    else
        Go <= '0';
    end if;
  end if;
end process;

end RTL;