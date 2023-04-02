--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEVEN_SEG_DECODER is
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(1 to 7)      -- Segments A, B, C, D, E, F, G
  );
end entity SEVEN_SEG_DECODER;

Architecture RTL of SEVEN_SEG_DECODER is
    signal Segout_tmp : std_logic_vector(1 to 7);
begin
	
With Data select
    Segout_tmp <= "1111110" when x"0", -- 0
                  "0110000" when x"1", -- 1
                  "1101101" when x"2", -- 2
                  "1111001" when x"3", -- 3
                  "0110011" when x"4", -- 4
                  "1011011" when x"5", -- 5
                  "1011111" when x"6", -- 6
                  "1110000" when x"7", -- 7
                  "1111111" when x"8", -- 8
                  "1111011" when x"9", -- 9
                  "1110111" when x"A", -- A
                  "0011111" when x"B", -- B
                  "1001110" when x"C", -- C
                  "0111101" when x"D", -- D
                  "1001111" when x"E", -- E
                  "1000111" when x"F", -- F
                  "-------" when others;

-- Inversion of output if Pol='0'
Segout <= Segout_tmp when Pol='1' else not(Segout_tmp);

end architecture RTL;