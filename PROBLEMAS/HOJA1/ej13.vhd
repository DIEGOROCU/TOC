library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ej13 is
    Port ( 
		clk 				: in  STD_LOGIC;
		rst				: in  STD_LOGIC;
      entrada 			: in  STD_LOGIC_VECTOR(6 downto 0);
		desplazamiento	: in  STD_LOGIC_VECTOR(2 downto 0);
		salida 			: out STD_LOGIC_VECTOR(7 downto 0)
    );
end ej13;

architecture Behavioral of ej13 is

	signal salidaYEntrada : STD_LOGIC_VECTOR(14 downto 0);
	signal salidaInterna  : STD_LOGIC_VECTOR(7 downto 0);

begin

	salidaYEntrada <= salidaInterna & entrada;
	
	SYNC: process(clk, rst)
	begin
		if rising_edge(clk) then
			if (rst = '1') then 
				salidaInterna <= (others=>'0');
			else
				salidaInterna <= salidaYEntrada(14-to_integer(unsigned(desplazamiento)) downto 7-to_integer(unsigned(desplazamiento)));
			end if;
		end if;
	end process SYNC;

	salida <= salidaInterna;
	
end Behavioral;

