library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECO3a8 is
    Port ( 
		s : in  STD_LOGIC_VECTOR (2 downto 0);
		e : in  STD_LOGIC;
		y : out STD_LOGIC_VECTOR (7 downto 0)
    );
end DECO3a8;

architecture Behavioral of DECO3a8 is

	signal y_intermedia : STD_LOGIC_VECTOR (2 downto 0);

begin
	
	y <= y_intermedia when ( e = '1') else "00000000";
	
	with s select
		y_intermedia <=  "00000001" when "000",
						 "00000010" when "001",
						 "00000100" when "010",
						 "00001000" when "011",
						 "00010000" when "100",
						 "00100000" when "101",
						 "01000000" when "110",
						 "10000000" when "111",
						 "00000000" when others;

end Behavioral;

