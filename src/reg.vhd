library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG is
    generic (
        N : integer := 32
    );
    port (
        Clk : in std_logic;
        Reset : in std_logic;
        DataIn : in std_logic_vector(N-1 downto 0);
        DataOut : out std_logic_vector(N-1 downto 0)
    );
end REG;

architecture RTL of REG is
begin

process(Clk, Reset)
begin
    if (Reset = '1') then
        DataOut <= (others => '0');
    elsif rising_edge(Clk) then
        DataOut <= DataIn;
    end if;
end process;

end RTL;