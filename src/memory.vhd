library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEMORY is
    generic (
        SIZE : integer := 64;
        isTest : boolean := FALSE
    );
    port (
        Clk     : in std_logic;
        Reset   : in std_logic;
        DataIn  : in std_logic_vector(31 downto 0);
        DataOut : out std_logic_vector(31 downto 0);
        Addr    : in std_logic_vector(5 downto 0);
        WrEn    : in std_logic
    );
end MEMORY;

architecture RTL of MEMORY is
    type table is array(SIZE-1 downto 0) of std_logic_vector(31 downto 0);

    function init_memory return table is
        variable result : table;
    begin
        for i in SIZE-1 downto 0 loop
            if (not isTest) then
                result(i) := (others => '0');
            else
                result(i) := std_logic_vector(to_unsigned(i, 32));
            end if;
        end loop;
        
        return result;
    end init_memory;

    signal Memory : table := init_memory;
begin
    DataOut <= Memory(to_integer(unsigned(Addr))) when to_integer(unsigned(Addr)) < SIZE else (others => 'X');

    process (Clk, Reset)
    begin
        if (Reset = '1') then
            Memory <= init_memory;
        elsif (rising_edge(Clk)) then
            if (WrEn = '1') then
                Memory(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;
end RTL;