library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end entity;

architecture Bench of ALU_tb is
    Signal OP			: std_logic_vector(2 downto 0);
    Signal A, B, S		: std_logic_vector(31 downto 0) := (others => '0');
    Signal N, Z, C, V 	: std_logic;
    Signal OK           : boolean := TRUE;
begin

UUT: process
begin
    report "Starting ALU testbench...";

    OP <= "000";
    for i in 0 to 512 loop
        for j in 0 to 512 loop
            A <= std_logic_vector(to_signed(i, 32));
            B <= std_logic_vector(to_signed(j, 32));
            wait for 1 ns;
            if (i+j /= to_integer(signed(S))) then
                report "Error: " & integer'image(i) & " + " & integer'image(j) & " = " & integer'image(i+j) & " but S = " & integer'image(to_integer(signed(S))) severity error;
                OK <= FALSE;
            end if;

            if (i = 0 and j = 0 and Z /= '1') then
                report "Error: Z should be 1 when i = 0 and j = 0" severity error;
                OK <= FALSE;
            elsif ((i /= 0 or j /= 0) and Z /= '0') then
                report "Error: Z should be 0 when i /= 0 or j /= 0" severity error;
                OK <= FALSE;
            end if;

            if (C /= '0') then
                report "Error: C should be 0 since there is no carry here" severity error;
                OK <= FALSE;
            end if;
        end loop;
    end loop;

    A <= "10000000000000000000000000000000";
    B <= "10000000000000000000000000000000";
    wait for 1 ns;
    if (C /= '1') then
        report "Error: C should be 1 since there is a carry here" severity error;
        OK <= FALSE;
    end if;

    OP <= "001";
    A <= x"00000101";
    B <= x"00000001";
    wait for 1 ns;
    if (S /= x"00000001") then
        report "Error: B = " & integer'image(to_integer(signed(B))) & " but S = " & integer'image(to_integer(signed(S))) severity error;
        OK <= FALSE;
    end if;

    OP <= "010";
    for i in 0 to 512 loop
        for j in 0 to 512 loop
            A <= std_logic_vector(to_signed(i, 32));
            B <= std_logic_vector(to_signed(j, 32));
            wait for 5 ns;
            if (i-j /= to_integer(signed(S))) then
                report "Error: " & integer'image(i) & " - " & integer'image(j) & " = " & integer'image(i-j) & " but S = " & integer'image(to_integer(signed(S))) severity error;
                OK <= FALSE;
            end if;

            if (i = 0 and j = 0 and Z /= '1') then
                report "Error: Z should be 1 when i = 0 and j = 0" severity error;
                OK <= FALSE;
            end if;

            if (i > j and N /= '0') then
                report "Error: N should be 0 when i > j" severity error;
                OK <= FALSE;
            elsif (i < j and N = '0') then
                report "Error: N should be 1 when i < j" severity error;
                OK <= FALSE;
            end if;
        end loop;
    end loop;

    OP <= "011";
    A <= x"00000101";
    B <= x"00000001";
    wait for 1 ns;
    if (S /= x"00000101") then
        report "Error: A = " & integer'image(to_integer(signed(B))) & " but S = " & integer'image(to_integer(signed(S))) severity error;
        OK <= FALSE;
    end if;

    OP <= "100";
    A <= x"01100101";
    B <= x"00011101";
    wait for 1 ns;
    if (S /= (A or B)) then
        report "Error: or result is wrong" severity error;
        OK <= FALSE;
    end if;

    OP <= "101";
    A <= x"01100101";
    B <= x"00011101";
    wait for 1 ns;
    if (S /= (A and B)) then
        report "Error: and result is wrong" severity error;
        OK <= FALSE;
    end if;

    OP <= "110";
    A <= x"01100101";
    B <= x"00011101";
    wait for 1 ns;
    if (S /= (A xor B)) then
        report "Error: xor result is wrong" severity error;
        OK <= FALSE;
    end if;

    OP <= "111";
    A <= x"01100101";
    B <= x"00011101";
    wait for 1 ns;
    if (S /= NOT(A)) then
        report "Error: not result is wrong" severity error;
        OK <= FALSE;
    end if;

    OP <= "000";
    A <= x"FFFFFFFF";
    B <= x"00000001";
    wait for 1 ns;
    if (C /= '1') then
        report "Error: C should be 1 since there is a carry here" severity error;
        OK <= FALSE;
    end if;

    OP <= "000";
    A <= x"7FFFFFFF";
    B <= x"7FFFFFFF";
    wait for 1 ns;
    if (V /= '1') then
        report "Error: V should be 1 since there is an overflow here" severity error;
        OK <= FALSE;
    end if;

    if (OK) then
        report "Alu testbench passed" severity note;
    else
        report "Alu testbench failed" severity error;
    end if;

    wait;
end process;

alu: entity work.ALU(RTL)
    port map (
        OP => OP,
        A => A,
        B => B,
        S => S,
        N => N,
        Z => Z,
        C => C,
        V => V
    );

end Bench;