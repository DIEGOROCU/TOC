--Librerias necesarias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
 
ENTITY simu08 IS
END simu08;
 
ARCHITECTURE behavior OF simu08 IS 
 
-- Declaración del componente que vamos a simular
 
	component ej08
		 Port ( 
			clk 		: in  STD_LOGIC;
			rst 		: in  STD_LOGIC;
			entrada	: in  STD_LOGIC;
			salida   : out STD_LOGIC
		 );
	end component;

--Entradas
    signal rst : std_logic;
    signal clk : std_logic;
    signal entrada : std_logic;
		
--Salidas
    signal salida : std_logic;
   
--Se define el periodo de reloj 
    constant clk_period : time := 100 ns;
 
BEGIN
 
-- Instanciacion de la unidad a simular 

   uut: ej08 PORT MAP (
          rst => rst,
          clk => clk,
          entrada => entrada,
          salida => salida
        );

-- Definicion del process de reloj
	reloj_process :process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process;
 

--Proceso de estimulos
	stim_proc: process
	begin		
		rst <= '1';
		entrada <= '0';
		wait for 150 ns;
		
		rst <= '0';
		entrada <= '1';
		wait for 2*clk_period;

		entrada <= '0';
		wait for clk_period/4;
		
		entrada <= '1';
		wait for clk_period;

		entrada <= '0';
		wait for 2*clk_period;

		entrada <= '1';
		wait for clk_period;

		wait;	
	end process;

END;

