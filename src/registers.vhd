library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGISTERS is
    generic (
        SIZE : integer := 16
    );
    port (
        Clk     : in std_logic;
        Reset   : in std_logic;
        W       : in std_logic_vector(31 downto 0);
        RA      : in std_logic_vector(3 downto 0);
        RB      : in std_logic_vector(3 downto 0);
        RW      : in std_logic_vector(3 downto 0);
        WE      : in std_logic;
        A       : out std_logic_vector(31 downto 0);
        B       : out std_logic_vector(31 downto 0)
    );
end REGISTERS;

architecture RTL of REGISTERS is
    type table is array(SIZE-1 downto 0) of std_logic_vector(31 downto 0);

    function init_banc return table is
        variable result : table;
    begin
        for i in SIZE-2 downto 0 loop
            result(i) := (others => '0');
        end loop;
        
        result(SIZE-1) := x"00000030";
        return result;
    end init_banc;

    signal Banc : table := init_banc;
begin
    A <= Banc(to_integer(unsigned(RA)));
    B <= Banc(to_integer(unsigned(RB)));

    process (Clk, Reset)
    begin
        if (Reset = '1') then
            Banc <= init_banc;
        elsif (rising_edge(Clk)) then
            if (WE = '1') then
                Banc(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;
end RTL;