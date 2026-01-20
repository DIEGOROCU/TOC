library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4a1 is
    Port ( 
      a : in  STD_LOGIC_VECTOR (3 downto 0);
      s : in  STD_LOGIC_VECTOR (1 downto 0);
      z : out STD_LOGIC
    );
end MUX4a1;

architecture Behavioral of MUX4a1 is

begin
	
	with s select
		z <=	a(0) when "00",
				a(1) when "01",
				a(2) when "10",
				a(3) when others;

end Behavioral;

