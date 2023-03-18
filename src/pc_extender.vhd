library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_EXTENDER is
    port (
        E : in std_logic_vector(23 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end PC_EXTENDER;

architecture RTL of PC_EXTENDER is
begin

    S <= std_logic_vector(resize(signed(E), 32));

end RTL;