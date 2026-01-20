library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all; 

entity MUX_gen is
    Generic (
		num_bits_sel : integer := 2
	 );
    Port ( 
      a : in  STD_LOGIC_VECTOR (2**num_bits_sel-1 downto 0);
      s : in  STD_LOGIC_VECTOR (num_bits_sel-1 downto 0);
      z : out STD_LOGIC
    );
end MUX_gen;

architecture Behavioral of MUX_gen is

begin
	
	z <= a(to_integer(unsigned(s)));

end Behavioral;

