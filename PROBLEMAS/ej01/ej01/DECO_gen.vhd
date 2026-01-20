library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DECO_gen is
    Generic (
		num_bits : integer := 3
	 );	
    Port ( 
		s : in  STD_LOGIC_VECTOR (num_bits-1 downto 0);
		e : in  STD_LOGIC;
		y : out STD_LOGIC_VECTOR (2**num_bits-1 downto 0)
    );
end DECO_gen;

architecture Behavioral of DECO_gen is

	signal y_intermedia : STD_LOGIC_VECTOR (2 downto 0);

begin

	y <= y_intermedia when ( e = '1') else (others => '0');

--	process (s)
--	begin
--		y_intermedia <= (others=>'0');
--		y_intermedia(to_integer(unsigned(s))) <= '1';
--	end process;

	
	process (s)
	begin
		for i in 0 to 2**num_bits-1 loop
			if to_integer(unsigned(s)) = i then 
				y_intermedia(i) <= '1';
			else
				y_intermedia(i) <= '0';
			end if;
		end loop;
	end process;
	
end Behavioral;

