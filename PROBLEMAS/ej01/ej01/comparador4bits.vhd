library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador4bits is
    Port ( 
		x : in  STD_LOGIC_VECTOR (3 downto 0);
		y : in  STD_LOGIC_VECTOR (3 downto 0);
		z : out STD_LOGIC
    );
end comparador4bits;

architecture Behavioral of comparador4bits is

begin
	
	z <= '1' when (x = y) else '0';

end Behavioral;

