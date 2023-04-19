library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX is
    port (
        Clk   : in std_logic;
        Reset : in std_logic;
        Go    : in std_logic;
        Data  : in std_logic_vector(7 downto 0);
        Tick  : in std_logic;
        Tx    : out std_logic;
        TxIrq : out std_logic
    );
end UART_TX;

architecture RTL of UART_TX is
    signal reg : std_logic_vector(9 downto 0);
    signal count_bit : integer range 0 to 15;

	type StateType is (E1, E2, E3, E4);
	signal State : StateType;
begin

process (Clk, Reset)
begin
    if Reset = '1' then
        Tx <= '1';
        TxIrq <= '0';
        count_bit <= 0;
        reg <= (others => '0');
    elsif rising_edge(Clk) then
        case State is
            when E1 =>
                if Go = '1' then
                    State <= E2;
                    reg <= '1' & Data & '0';
                    count_bit <= 0;
                    TxIrq <= '0';
                end if;
            when E2 =>
                if Tick = '1' then
                    State <= E3;
                    Tx <= reg(count_bit);
                end if;
            when E3 =>
                State <= E4;
                count_bit <= count_bit + 1;
            when E4 =>
                if (count_bit = 10) then
                    State <= E1;
                    count_bit <= 0;
                    TxIrq <= '1';
                elsif Tick = '1' then
                    State <= E3;
                    Tx <= reg(count_bit);
                end if;
        end case;
    end if;
end process;

end RTL;