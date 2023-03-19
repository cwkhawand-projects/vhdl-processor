library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EXTENDER is
    generic (
        N : integer := 8
    );
    port (
        E : in std_logic_vector(N-1 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end EXTENDER;

architecture RTL of EXTENDER is
begin

    S <= std_logic_vector(resize(unsigned(E), 32));

end RTL;