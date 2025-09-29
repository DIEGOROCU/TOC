library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ej09 is
    Port ( 
		clk 		: in  STD_LOGIC;
		rst 		: in  STD_LOGIC;
		ruido		: in  STD_LOGIC;
		chupete		: in  STD_LOGIC;
		sonido		: out STD_LOGIC;
		llanto		: out STD_LOGIC
    );
end ej09;

architecture Behavioral of ej09 is

	type tipo_estado is (tranquila, habla, dormida, asustada);
	signal estadoActual, estadoSiguiente : tipo_estado;

begin
	
	SYNC: process(clk, rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				estadoActual <= tranquila;
			else
				estadoActual <= estadoSiguiente;
			end if;
		end if;
	end process SYNC;
	
	COMB: process(estadoActual, ruido, chupete)
	begin
	
		estadoSiguiente <= estadoActual;
		sonido <= '0';
		llanto <= '0';

		case estadoActual is
		
			when tranquila =>
				if (ruido = '1') then
					estadoSiguiente <= habla;
				elsif (chupete = '1') then
					estadoSiguiente <= dormida;
				end if;
				
			when habla =>
				sonido <= '1';
				if (chupete = '1') then
					estadoSiguiente <= dormida;
				end if;
			
			when dormida =>
				if (chupete = '0' and ruido = '1') then
					estadoSiguiente <= asustada;
				end if;
			
			when asustada =>
				sonido <= '1';
				llanto <= '1';
				
				-- if (ruido = '0') then
					-- if (chupete = '0') then
						-- estadoSiguiente <= tranquila;
					-- else
						-- estadoSiguiente <= dormida;
					-- elsif
				-- end if;
				
				if (ruido = '0' and chupete = '0') then
					estadoSiguiente <= tranquila;
				elsif (ruido = '0' and chupete = '1') then
					estadoSiguiente <= dormida;
				end if;
				
				
		end case;
	end process COMB;

end Behavioral;

