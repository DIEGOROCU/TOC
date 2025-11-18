library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ALU is
	port( 		
		A			: in  std_logic_vector(31 downto 0);
		B			: in  std_logic_vector(31 downto 0);
		ALUop		: in  std_logic_vector(1 downto 0);
		op_5	    : in  std_logic;		
		funct7_5   	: in  std_logic;		
		funct3		: in  std_logic_vector(2 downto 0);
		Zero		: out std_logic;
		R			: out std_logic_vector(31 downto 0)
	);
end ALU;

architecture ALUArch of ALU is
   
	signal A_signed : signed(31 downto 0);
	signal B_signed : signed(31 downto 0);
	signal R_signed : signed(31 downto 0);
	signal slt : signed(31 downto 0);
	
begin

	R <= std_logic_vector(R_signed);	
	Zero <= '1' when (R_signed = x"00000000") else '0';
	
	A_signed <= signed(A);
	B_signed <= signed(B);
	slt <= x"00000001" when (A_signed < B_signed) else x"00000000";
	
	R_signed <=     A_signed + B_signed when (ALUop = "00") else
				    A_signed - B_signed when (ALUop = "01") else
					A_signed + B_signed when (op_5 = '1' and funct7_5 = '0' and funct3 = "000") else  -- ADD R
					A_signed - B_signed when (op_5 = '1' and funct7_5 = '1' and funct3 = "000") else  -- SUB R
					A_signed + B_signed when (op_5 = '0' and funct3 = "000") else  -- ADDI
					slt when (funct3 = "010") else -- SLT / SLTI
					A_signed and B_signed when (funct3 = "111") else  -- AND / ANDI
					A_signed or B_signed when (funct3 = "110") else -- OR / ORI
					(others=>'-');
	
end ALUArch;