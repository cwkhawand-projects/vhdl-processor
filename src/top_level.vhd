library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_LEVEL is
  port (
    CLOCK_50 : in std_logic;
    KEY	     :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    SW       :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    HEX0     : out std_logic_vector(0 to 6);
    HEX1     : out std_logic_vector(0 to 6);
    HEX2     : out std_logic_vector(0 to 6);
    HEX3     : out std_logic_vector(0 to 6);
    GPIO     : out std_logic_vector(0 to 1)
  );
end TOP_LEVEL;

architecture RTL of TOP_LEVEL is
    Signal Reset                  : std_logic;
    Signal Button                 : std_logic_vector(1 downto 0);
    Signal Display                : std_logic_vector(31 downto 0);
begin

Reset <= SW(0);
Button <= not KEY;

processor: entity work.PROCESSOR
    generic map (
        isTest => TRUE
    )
    port map (
        Clk      => CLOCK_50,
        Reset    => Reset,
        IRQ0     => Button(0),
        IRQ1     => Button(1),
        Display  => Display,
        Tx       => GPIO(0)
    );

seven_seg_decoder_0: entity work.SEVEN_SEG_DECODER
    port map (
        Data   => Display(3 downto 0),
        Pol    => '0',
        Segout => HEX0
    );

seven_seg_decoder_1: entity work.SEVEN_SEG_DECODER
    port map (
        Data   => Display(7 downto 4),
        Pol    => '0',
        Segout => HEX1
    );

seven_seg_decoder_2: entity work.SEVEN_SEG_DECODER
    port map (
        Data   => Display(11 downto 8),
        Pol    => '0',
        Segout => HEX2
    );

seven_seg_decoder_3: entity work.SEVEN_SEG_DECODER
    port map (
        Data   => Display(15 downto 12),
        Pol    => '0',
        Segout => HEX3
    );
end RTL;