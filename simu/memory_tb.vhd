library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEMORY_tb is
end MEMORY_tb;

architecture Bench of MEMORY_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic;
    Signal DataIn  : std_logic_vector(31 downto 0);
    Signal DataOut : std_logic_vector(31 downto 0);
    Signal Addr    : std_logic_vector(5 downto 0);
    Signal WrEn    : std_logic := '0';
    Signal OK      : boolean := TRUE;
begin

process
begin
    while (now <= 2000 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting memory testbench...";

    Reset <= '1';
    wait for 10 ns;
    Reset <= '0';

    WrEn <= '1';
    -- fill memory with data = i
    for i in 0 to 63 loop
        Addr <= std_logic_vector(to_unsigned(i, 6));
        DataIn <= std_logic_vector(to_unsigned(i, 32));
        wait for 10 ns;
    end loop;
    WrEn <= '0';

    -- test to see if written data can be retrieved
    for i in 0 to 63 loop
        Addr <= std_logic_vector(to_unsigned(i, 6));
        wait for 10 ns;
        if (DataOut /= std_logic_vector(to_unsigned(i, 32))) then
            OK <= FALSE;
            report "Error: DataOut = 0x" & to_hex_string(DataOut) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i, 32)));
        end if;
    end loop;

    -- test to see if write enable can disable writing
    WrEn <= '0';
    for i in 0 to 63 loop
        Addr <= std_logic_vector(to_unsigned(i, 6));
        DataIn <= std_logic_vector(to_unsigned(63-i, 32));
        wait for 10 ns;
    end loop;

    -- the same loop as before should work because the data should not have changed
    for i in 0 to 7 loop
        Addr <= std_logic_vector(to_unsigned(i, 6));
        wait for 10 ns;
        if (DataOut /= std_logic_vector(to_unsigned(i, 32))) then
            OK <= FALSE;
            report "Error: DataOut = 0x" & to_hex_string(DataOut) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i, 32))) severity error;
        end if;
    end loop;

    if (OK) then
        report "Memory testbench passed" severity note;
    else
        report "Memory testbench failed" severity error;
    end if;
    wait;
end process;

Memory: entity work.MEMORY
    port map (
        Clk     => Clk,
        Reset   => Reset,
        DataIn  => DataIn,
        DataOut => DataOut,
        Addr    => Addr,
        WrEn    => WrEn
    );
end Bench;