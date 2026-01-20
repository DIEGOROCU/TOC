-- Comparador de números enteros
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparadorCompleto is
    generic (
        num_bits : natural := 4
    );
    port ( 
		x : in  STD_LOGIC_VECTOR (num_bits-1 downto 0);
		y : in  STD_LOGIC_VECTOR (num_bits-1 downto 0);
		e : out STD_LOGIC;
		g : out STD_LOGIC;
		l : out STD_LOGIC
    );
end comparadorCompleto;

architecture Behavioral of comparadorCompleto is

begin
	
	e <= '1' when (signed(x) = signed(y)) else '0';
	g <= '1' when (signed(x) > signed(y)) else '0';
	l <= '1' when (signed(x) < signed(y)) else '0';

end Behavioral;

