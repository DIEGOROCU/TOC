library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR4Bits is
    port ( 
      x : in  STD_LOGIC_VECTOR (3 downto 0);
      y : in  STD_LOGIC_VECTOR (3 downto 0);
      z : out STD_LOGIC_VECTOR (3 downto 0)
    );
end XOR4Bits;

architecture Behavioral of XOR4Bits is

begin
	
	z <= x xor y;

end Behavioral;

