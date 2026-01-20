library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ej07 is
    Port ( 
		clk 							: in  STD_LOGIC;
		start_stop						: in  STD_LOGIC;
		dar_cera 						: in  STD_LOGIC;
		salida_agua   					: out STD_LOGIC;
		salida_aire   					: out STD_LOGIC;
		mover_rollos  					: out STD_LOGIC;
		salida_jabon					: out STD_LOGIC;
		encerar  						: out STD_LOGIC
    );
end ej07;

architecture Behavioral of ej07 is

	type tipo_estado is (inicial, jabon, rodillo, agua, secar, cera);
	signal estadoActual, estadoSiguiente : tipo_estado;
	
	signal contador, contadorSiguiente : std_logic_vector(0 downto 0);

begin
	
	SYNC: process(clk, start_stop)
	begin
		if (start_stop = '0') then
			contador <= (others => '0');
			estadoActual <= inicial;
		elsif rising_edge(clk) then
			estadoActual <= estadoSiguiente;
			contador <= contadorSiguiente;
		end if;
	end process SYNC;
	
	COMB: process(estadoActual, dar_cera, contador)
	begin
	
		estadoSiguiente 		<= estadoActual;
		contadorSiguiente 		<= contador;
		salida_agua   			<= '0';
		salida_aire   			<= '0';
		mover_rollos  			<= '0';
		salida_jabon			<= '0';
		encerar  				<= '0';

		case estadoActual is
		
			when inicial =>
				estadoSiguiente <= jabon;
				
			when jabon =>
				salida_jabon <= '1';
				estadoSiguiente <= rodillo;
			
			when rodillo =>
				mover_rollos <= '1';
				if (contador = "1") then
					estadoSiguiente <= agua;
					contadorSiguiente <= (others => '0');
				else
					contadorSiguiente <= contador + 1;
				end if;
				
			when agua =>
				salida_agua <= '1';
				estadoSiguiente <= secar;
				
			when secar =>
				salida_aire <= '1';
				if (dar_cera = '1') then
					estadoSiguiente <= cera;
				else
					estadoSiguiente <= inicial;
				end if;
				
			when cera =>
				dar_cera <= '1';
				if (contador = "1") then
					estadoSiguiente <= inicial;
					contadorSiguiente <= (others => '0');
				else
					contadorSiguiente <= contador + 1;	
				end if;
				
		end case;
	end process COMB;

end Behavioral;

