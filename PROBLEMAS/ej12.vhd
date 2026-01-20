library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ej12 is
    Port ( 
		clk 			: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
      entrada 		: in  STD_LOGIC;
		paridad_par : out STD_LOGIC
    );
end ej12;

architecture Behavioral of ej12 is

	type tipo_estado is (par, impar);
	signal estadoActual, estadoSiguiente : tipo_estado;

begin
	
	SYNC: process(clk, rst)
	begin
		if rising_edge(clk) then
			if (rst = '1') then 
				estadoActual <= par;
			else
				estadoActual <= estadoSiguiente;
			end if;
		end if;
	end process SYNC;
	
	COMB: process(estadoActual, entrada)
	begin
	
		estadoSiguiente <= estadoActual;

		case estadoActual is
		
			when par =>
				paridad_par <= '1';
				if (entrada = '1') then
					estadoSiguiente <= impar;
				end if;
				
			when impar =>
				paridad_par <= '0';
				if (entrada = '1') then
					estadoSiguiente <= par;
				end if;
			
	end case;
	end process COMB;

end Behavioral;

