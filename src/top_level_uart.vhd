library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_LEVEL_UART is
  port (
    CLOCK_50 : IN std_logic;
    KEY	     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    SW       : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    GPIO     : OUT STD_LOGIC_VECTOR(0 to 1)
  );
end TOP_LEVEL_UART;

architecture RTL of TOP_LEVEL_UART is
	Signal Reset, Go_1, Go : std_logic;
begin

Reset <= not(KEY(1));

process(CLOCK_50, Reset)
begin
    if Reset = '1' then
        Go_1 <= '0';
    elsif rising_edge(CLOCK_50) then
        Go_1 <= not(KEY(0));
        Go <= not(Go_1) and not(KEY(0));
    end if;
end process;

uart: entity work.UART
  port map (
    Clk     => CLOCK_50,
    Reset   => Reset,
    Data    => SW(7 downto 0),
    UARTWr  => Go,
    Tx      => GPIO(0)
  );

end RTL;