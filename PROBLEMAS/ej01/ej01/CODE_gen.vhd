library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity CODE_gen is
    Generic (
		num_bits : integer := 3
	 );
    Port ( 
		s : in  STD_LOGIC_VECTOR (2**num_bits-1 downto 0);
		a : out STD_LOGIC;
		y : out STD_LOGIC_VECTOR (num_bits-1 downto 0)
    );
end CODE_gen;

architecture Behavioral of CODE_gen is

begin

	process (s)
	begin
		a <= '0';
		y <= (others => '0');
		for i in 0 to 2**num_bits-1 loop
			if s(i) = '1' then 
				a <= '1';
				y <= std_logic_vector(to_unsigned(i, num_bits));
			end if;
		end loop;
	end process;

end Behavioral;

