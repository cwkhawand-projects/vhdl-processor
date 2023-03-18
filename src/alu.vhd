library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port
	(
		OP			: in std_logic_vector(2 downto 0);
		A, B		: in std_logic_vector(31 downto 0);
		S			: out std_logic_vector(31 downto 0);
		N, Z, C, V 	: out std_logic
	);
end ALU;

architecture RTL of alu is
	Signal A_int, B_int : signed(32 downto 0);
	Signal S_int 		: signed(32 downto 0);
begin
	A_int <= '0' & signed(A);
	B_int <= '0' & signed(B);

	With OP select
		S_int <= A_int + B_int		when "000",
				 B_int 				when "001",
				 A_int - B_int		when "010",
				 A_int 				when "011",
				 A_int or B_int  	when "100",
				 A_int and B_int 	when "101",
				 A_int xor B_int 	when "110",
				 NOT A_int 	 		when "111",
				 (others => 'U') 	when others;

	S <= std_logic_vector(S_int(31 downto 0));

	N <= S_int(31);
	Z <= '1' when S_int(31 downto 0) = x"00000000" else '0';
	C <= S_int(32);
	V <= '1' when A(31) = B(31) and S_int(31) /= A(31) else '0';
end RTL;