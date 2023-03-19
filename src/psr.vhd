library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- process state register
entity PSR is
  port (
    Clk     : in STD_LOGIC;
    Reset   : in STD_LOGIC;
    DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
    WrEn    : in STD_LOGIC;
    DataOut : out STD_LOGIC_VECTOR(31 downto 0)
  );
end PSR;

architecture RTL of PSR is
begin

process(Clk, Reset)
begin
  if (Reset = '1') then
    DataOut <= (others => '0');
  elsif rising_edge(Clk) then
    if (WrEn = '1') then
      DataOut <= DataIn;
    end if;
  end if;
end process;

end RTL;