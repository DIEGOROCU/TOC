library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CODE8a3 is
    Port ( 
		s : in  STD_LOGIC_VECTOR (7 downto 0);
		a : out STD_LOGIC;
		y : out STD_LOGIC_VECTOR (2 downto 0)
    );
end CODE8a3;

architecture Behavioral of CODE8a3 is

begin
	
	a <= '0' when ( s = "00000000" ) else '1'; 
	
	with s select
		y <=    "000" when "00000001",
				"001" when "00000010",
				"010" when "00000100",
				"011" when "00001000",
				"100" when "00010000",
				"101" when "00100000",
				"110" when "01000000",
				"111" when "10000000",
				"000" when others;

end Behavioral;

