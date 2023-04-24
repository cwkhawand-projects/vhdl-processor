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

    function init_registers return table is
        variable result : table;
    begin
        for i in SIZE-4 downto 0 loop
            result(i) := (others => '0');
        end loop;
        
        result(SIZE-3) := x"00000034"; -- $txp
        result(SIZE-2) := x"00000034"; -- $rxp
        result(SIZE-1) := x"00000030"; -- $sp
        return result;
    end init_registers;

    signal Registers : table := init_registers;
begin
    A <= Registers(to_integer(unsigned(RA)));
    B <= Registers(to_integer(unsigned(RB)));

    process (Clk, Reset)
    begin
        if (Reset = '1') then
            Registers <= init_registers;
        elsif (rising_edge(Clk)) then
            if (WE = '1') then
                Registers(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;
end RTL;