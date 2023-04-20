library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        Rx           : in std_logic;
        Tick_halfbit : in std_logic;
        Clear_fdiv   : out std_logic;
        Err          : out std_logic;
        Data         : out std_logic_vector(7 downto 0);
        RxIrq        : out std_logic
    );
end UART_RX;

architecture RTL of UART_RX is
    signal reg : std_logic_vector(7 downto 0);
    signal count_bit : integer range 0 to 15;

	type StateType is (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, Er);
	signal State : StateType;
begin

process (Clk, Reset)
begin
    if Reset = '1' then
        RxIrq <= '0';
        count_bit <= 0;
        reg <= (others => '0');
        Clear_fdiv <= '0';
        Err <= '0';
    elsif rising_edge(Clk) then
        case State is
            when E1 =>
                if Rx = '0' then
                    State <= E2;
                    Clear_fdiv <= '1';
                    RxIrq <= '0';
                    Err <= '0';
                end if;
            when E2 =>
                State <= E3;
                Clear_fdiv <= '0';
            when E3 =>
                if Tick_halfbit = '1' then
                    State <= E4;
                end if;
            when E4 =>
                if Rx = '0' then
                    State <= E5;
                elsif Rx = '1' then
                    State <= Er;
                    Err <= '1';
                end if;
            when E5 =>
                if Tick_halfbit = '1' then
                    State <= E6;
                end if;
            when E6 =>
                if Tick_halfbit = '1' then
                    State <= E7;
                    reg(count_bit) <= Rx;
                    count_bit <= count_bit + 1;
                end if;
            when E7 =>
                if count_bit = 8 then
                    State <= E8;
                elsif Tick_halfbit = '1' then
                    State <= E6;
                end if;
            when E8 =>
                if Tick_halfbit = '1' then
                    State <= E9;
                end if;
            when E9 =>
                if Tick_halfbit = '1' then
                    State <= E10;
                end if;
            when E10 =>
                if Rx = '0' then
                    State <= Er;
                    Err <= '1';
                else
                    State <= E11;
                    Data <= reg;
                    RxIrq <= '1';
                end if;
            when E11 =>
                State <= E1;
                count_bit <= 0;
            when Er =>
                State <= E1;
                count_bit <= 0;
        end case;
    end if;
end process;

end RTL;