library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ej03 is
port (
	number: in std_logic_vector(2 downto 0);
	result: out std_logic_vector(3 downto 0);
	overflow: out std_logic
);
end ej03;

architecture Behavioral of ej03 is

	signal s_3, number_unsigned: unsigned(2 downto 0);
	signal result_unsigned: unsigned(4 downto 0);

begin

	result_unsigned <= unsigned(number) * to_unsigned(3, 3);
	result <= std_logic_vector(result_unsigned(3 downto 0));
	overflow <= result_unsigned(4);
	
--	s_3 <= "011";
--	number_unsigned <= unsigned(number);	
--	result_unsigned <= number_unsigned * s_3;
--	result <= std_logic_vector(result_unsigned);
--	
--	-- WHEN ELSE
--	--overflow <= '1' when number = "110" or number = "111" else
--	--				'0';
--	
--	-- WITH-SELECT-WHEN
--	with number select 
--			overflow <= '1' when "110",
--							'1' when "111",
--							'0' when others;
--	
end Behavioral;