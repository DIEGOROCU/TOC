library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ej10 is
    Port ( 
		clk 		: in  STD_LOGIC;
		rst 		: in  STD_LOGIC;
      entrada	: in  STD_LOGIC;
      salida   : out STD_LOGIC
    );
end ej10;

architecture Behavioral of ej10 is

	type tipo_estado is (S0, S1, S2, S3);
	signal estadoActual, estadoSiguiente : tipo_estado;

begin
	
	SYNC: process(clk, rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				estadoActual <= S0;
			else
				estadoActual <= estadoSiguiente;
			end if;
		end if;
	end process SYNC;
	
	COMB: process(estadoActual, entrada)
	begin
	
		estadoSiguiente <= estadoActual;
		salida <= '0';

		case estadoActual is
		
			when S0 =>
				if (entrada = '1') then
					estadoSiguiente <= S1;
				end if;
				
			when S1 =>
				if (entrada = '0') then
					estadoSiguiente <= S2;
				end if;			
			
			when S2 =>
				if (entrada = '0') then
					estadoSiguiente <= S0;
				else
					estadoSiguiente <= S3;
				end if;			
				
			when S3 =>
				if (entrada = '0') then
					estadoSiguiente <= S2;
					salida <= '1';
				else
					estadoSiguiente <= S1;
				end if;
				
		end case;
	end process COMB;

end Behavioral;

