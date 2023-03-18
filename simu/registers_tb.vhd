library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGISTERS_tb is
end REGISTERS_tb;

architecture Bench of REGISTERS_tb is
    Signal Clk   : std_logic;
    Signal Reset : std_logic;
    Signal W     : std_logic_vector(31 downto 0);
    Signal RA    : std_logic_vector(3 downto 0) := "0000";
    Signal RB    : std_logic_vector(3 downto 0) := "0000";
    Signal RW    : std_logic_vector(3 downto 0) := "0000";
    Signal WE    : std_logic := '0';
    Signal A     : std_logic_vector(31 downto 0);
    Signal B     : std_logic_vector(31 downto 0);
    Signal OK    : boolean := TRUE;
begin

process
begin
    while (now <= 490 ns) loop
        Clk <= '0';
        wait for 5 ns;
        Clk <= '1';
        wait for 5 ns;
    end loop;
    wait;
end process;

UUT: process
begin
    report "Starting registers testbench...";

    Reset <= '1';
    wait for 10 ns;
    Reset <= '0';

    WE <= '1';
    -- fill registers with data = i
    for i in 0 to 15 loop
        RW <= std_logic_vector(to_unsigned(i, 4));
        W <= std_logic_vector(to_unsigned(i, 32));
        wait for 10 ns;
    end loop;

    -- test to see if written data can be retrieved
    for i in 0 to 7 loop
        RA <= std_logic_vector(to_unsigned(i*2, 4));
        RB <= std_logic_vector(to_unsigned(i*2+1, 4));
        wait for 10 ns;
        if (A /= std_logic_vector(to_unsigned(i*2, 32))) then
            OK <= FALSE;
            report "Error: A = 0x" & to_hex_string(A) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i*2, 32)));
        end if;
        
        if (B /= std_logic_vector(to_unsigned(i*2+1, 32))) then
            OK <= FALSE;
            report "Error: B = 0x" & to_hex_string(B) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i*2+1, 32)));
        end if;
    end loop;

    -- test to see if write enable can disable writing
    WE <= '0';
    for i in 0 to 15 loop
        RW <= std_logic_vector(to_unsigned(i, 4));
        W <= std_logic_vector(to_unsigned(15-i, 32));
        wait for 10 ns;
    end loop;

    -- the same loop as before should work because the data should not have changed
    for i in 0 to 7 loop
        RA <= std_logic_vector(to_unsigned(i*2, 4));
        RB <= std_logic_vector(to_unsigned(i*2+1, 4));
        wait for 10 ns;
        if (A /= std_logic_vector(to_unsigned(i*2, 32))) then
            OK <= FALSE;
            report "Error: A = 0x" & to_hex_string(A) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i*2, 32))) severity error;
        end if;
        
        if (B /= std_logic_vector(to_unsigned(i*2+1, 32))) then
            OK <= FALSE;
            report "Error: B = 0x" & to_hex_string(B) & " expected 0x" & to_hex_string(std_logic_vector(to_unsigned(i*2+1, 32))) severity error;
        end if;
    end loop;

    if (OK) then
        report "Registers testbench passed" severity note;
    else
        report "Registers testbench failed" severity error;
    end if;
    wait;
end process;

registers: entity work.REGISTERS(RTL)
    port map (
        Clk   => Clk,
        Reset => Reset,
        W     => W,
        RA    => RA,
        RB    => RB,
        RW    => RW,
        WE    => WE,
        A     => A,
        B     => B
    );

end Bench;