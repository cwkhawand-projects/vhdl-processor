library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2V1 is
    generic (
        N : integer := 32
    );
    port (
        A, B : in std_logic_vector(N-1 downto 0);
        COM  : in std_logic;
        S    : out std_logic_vector(N-1 downto 0)
    );
end MUX2V1;

architecture RTL of MUX2V1 is
begin

    S <= A when COM = '0' else B;

end RTL;