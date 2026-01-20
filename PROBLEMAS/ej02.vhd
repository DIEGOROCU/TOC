library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all; 

entity ej02 is
    Port ( 
      a : in  STD_LOGIC_VECTOR (3 downto 0);
      z : out STD_LOGIC
    );
end ej02;

architecture Behavioral of ej02 is

	signal primo 			: std_logic;
	signal menor4yPar		: std_logic;
	signal mayor8eImpar	: std_logic;

begin
	
	primo <= '1' when (to_integer(unsigned(a)) = 2 or 
							 to_integer(unsigned(a)) = 3 or 
							 to_integer(unsigned(a)) = 5 or 
							 to_integer(unsigned(a)) = 7 or 
							 to_integer(unsigned(a)) = 11 or 
							 to_integer(unsigned(a)) = 13) else '0';
							 
	menor4yPar <= '1' when (to_integer(unsigned(a)) < 4 and a(0) = '0') else '0';
	
	mayor8eImpar <= '1' when (to_integer(unsigned(a)) > 8 and a(0) = '1') else '0';
	
	z <= primo or menor4yPar or mayor8eImpar;

end Behavioral;

