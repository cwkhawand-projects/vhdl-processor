library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_memory_IRQ is
    port(
        PC          : in std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of instruction_memory_IRQ is
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);
 
    function init_mem return RAM64x32 is
        variable ram_block : RAM64x32;
    begin
        -- PC            -- INSTRUCTION -- COMMENT
        ram_block(0 ) := x"E3A01010"; -- _main : MOV R1,#0x10 ; --R1 <= 0x10
        ram_block(1 ) := x"E3A02000"; -- MOV R2,#0 ;            --R2 <= 0 
        ram_block(2 ) := x"E6110000"; -- _loop : LDR R0,0(R1) ; --R0 <= MEM[R1]
        ram_block(3 ) := x"E0822000"; -- ADD R2,R2,R0 ;         --R2 <= R2 + R0
        ram_block(4 ) := x"E2811001"; -- ADD R1,R1,#1 ;         --R1 <= R1 + 1
        ram_block(5 ) := x"E351001A"; -- CMP R1,0x1A ;          --? R1 = 0x1A
        ram_block(6 ) := x"BAFFFFFB"; -- BLT loop ;             --branch to _loop if R1 less than 0x1A
        ram_block(7 ) := x"E6012000"; -- STR R2,0(R1) ;         --MEM[R1] <= R2
        ram_block(8 ) := x"EAFFFFF7"; -- BAL main ;             --branch to _main 
        -- ISR 0 : interruption 0
        --save context
        ram_block(9 ) := x"E60F1000"; -- STR R1,0(R15) ;        --MEM[R15] <= R1 
        ram_block(10) := x"E28FF001"; -- ADD R15,R15,1 ;        --R15 <= R15 + 1
        ram_block(11) := x"E60F3000"; -- STR R3,0(R15) ;        --MEM[R15] <= R3
        --processing
        ram_block(12) := x"E3A03010"; -- MOV R3,0x10 ;          --R3 <= 0x10
        ram_block(13) := x"E6131000"; -- LDR R1,0(R3) ;         --R1 <= MEM[R3]
        ram_block(14) := x"E2811001"; -- ADD R1,R1,1 ;          --R1 <= R1 + 1
        ram_block(15) := x"E6031000"; -- STR R1,0(R3) ;         --MEM[R3] <= R1
        -- restore context
        ram_block(16) := x"E61F3000"; -- LDR R3,0(R15) ;        --R3 <= MEM[R15]
        ram_block(17) := x"E28FF0FF"; -- ADD R15,R15,-1 ;       --R15 <= R15 - 1
        ram_block(18) := x"E61F1000"; -- LDR R1,0(R15) ;        --R1 <= MEM[R15]
        ram_block(19) := x"EB000000"; -- BX ;                   -- end of interruption instruction
        ram_block(20) := x"00000000"; 
        -- ISR1 : interruption 1 
        --save context - R15 is the stack pointer
        ram_block(21) := x"E60F4000"; -- STR R4,0(R15) ;        --MEM[R15] <= R4
        ram_block(22) := x"E28FF001"; -- ADD R15,R15,1 ;        --R15 <= R15 + 1
        ram_block(23) := x"E60F5000"; -- STR R5,0(R15) ;        --MEM[R15] <= R5
        --processing
        ram_block(24) := x"E3A05010"; -- MOV R5,0x10 ;          --R5 <= 0x10
        ram_block(25) := x"E6154000"; -- LDR R4,0(R5) ;         --R4 <= MEM[R5]
        ram_block(26) := x"E2844002"; -- ADD R4,R4,2 ;          --R4 <= R4 + 2
        ram_block(27) := x"E6054000"; -- STR R4,0(R5) ;         --MEM[R5] <= R4
        -- restore context
        ram_block(28) := x"E61F5000"; -- LDR R5,0(R15) ;        --R5 <= MEM[R15]
        ram_block(29) := x"E28FF0FF"; -- ADD R15,R15,-1 ;       --R15 <= R15 - 1
        ram_block(30) := x"E61F4000"; -- LDR R4,0(R15) ;        --R4 <= MEM[R15]
        ram_block(31) := x"EB000000"; -- BX ;                   -- end of interruption instruction
        ram_block(32) := x"00000001";
        ram_block(33) := x"00000002";
        ram_block(34) := x"00000003";
        ram_block(35) := x"00000004";
        ram_block(36) := x"00000005";
        ram_block(37) := x"00000006";
        ram_block(38) := x"00000007";
        ram_block(39) := x"00000008";
        ram_block(40) := x"00000009";
        ram_block(41) := x"0000000A";
        ram_block(42 to 63) := (others=> x"00000000");
        
        return ram_block;
    end init_mem;

    signal mem: RAM64x32 := init_mem;
begin
    Instruction <= mem(to_integer(unsigned(PC)));
end architecture;