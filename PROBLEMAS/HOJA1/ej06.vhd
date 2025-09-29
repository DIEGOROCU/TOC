library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ej06 is
    Port ( 
		clk 							: in  STD_LOGIC;
		start_stop						: in  STD_LOGIC;
		ciclo_rapido 					: in  STD_LOGIC;
 		entrar_agua   					: out STD_LOGIC;
		calentar_agua   				: out STD_LOGIC;
		mover_aspas  					: out STD_LOGIC;
		abrir_cajentin_detergente		: out STD_LOGIC;
		secar  							: out STD_LOGIC
    );
end ej06;

architecture Behavioral of ej06 is

	type tipo_estado is (inicial, lavado, aclarado, secado);
	signal estadoActual, estadoSiguiente : tipo_estado;
	
	signal contador, contadorSiguiente : std_logic_vector(1 downto 0);

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
	
	COMB: process(estadoActual, ciclo_rapido, contador)
	begin
	
		estadoSiguiente 				<= estadoActual;
		contadorSiguiente 				<= contador;
		entrar_agua   					<= '0';
		calentar_agua   				<= '0';
		mover_aspas  					<= '0';
		abrir_cajentin_detergente		<= '0';
		secar  							<= '0';

		case estadoActual is
		
			when inicial =>
				estadoSiguiente <= lavado;
				
			when lavado =>
				mover_aspas <= '1';
				if (contador = "00") then
					entrar_agua <= '1';
					calentar_agua <= '1';
				elsif (contador = "01") then
					abrir_cajentin_detergente <= '1';
				end if;
				if ((ciclo_rapido = '1' and contador = "01") or 
				    (ciclo_rapido = '0' and  contador = "11")) then
					estadoSiguiente <= aclarado;
					contadorSiguiente <= (others => '0');
				else
					contadorSiguiente <= contador + 1;
				end if;				
			
			when aclarado =>
				mover_aspas <= '1';
				if (contador = "00") then
					entrar_agua <= '1';
				end if;
				if (ciclo_rapido = '1' or 
				   (ciclo_rapido = '0' and contador = "01")) then
					estadoSiguiente <= secado;
					contadorSiguiente <= (others => '0');
				else
					contadorSiguiente <= contador + 1;		
				end if;			
				
			when secado =>
				secar <= '1';
				estadoSiguiente <= inicial;
				
		end case;
	end process COMB;

end Behavioral;

