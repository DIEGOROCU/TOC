library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ej05 is
    Port ( 
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		x   : in  STD_LOGIC;
		z   : out STD_LOGIC
    );
end ej05;

architecture Behavioral of ej05 is

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
	
	COMB: process(estadoActual, x)
	begin
	
		estadoSiguiente <= estadoActual;
		z <= '0';

		case estadoActual is
		
			when S0 =>
				if (x = '0') then
					estadoSiguiente <= S1;
				end if;
				
			when S1 =>
				if (x = '0') then
					estadoSiguiente <= S2;
				else
					estadoSiguiente <= S0;
				end if;			
			
			when S2 =>
				if (x = '1') then
					estadoSiguiente <= S3;
				end if;			
				
			when S3 =>
				if (x = '0') then
					estadoSiguiente <= S1;
				else
					estadoSiguiente <= S0;
					z <= '1';
				end if;
				
		end case;
	end process COMB;

end Behavioral;

