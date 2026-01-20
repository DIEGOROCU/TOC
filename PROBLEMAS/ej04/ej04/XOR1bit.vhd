library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR1bit is
    Port ( 
		x : in  STD_LOGIC;
      y : in  STD_LOGIC;
      z : out STD_LOGIC
    );
end XOR1bit;

architecture Behavioral of XOR1bit is

begin
	
	z <= x xor y;

end Behavioral;

