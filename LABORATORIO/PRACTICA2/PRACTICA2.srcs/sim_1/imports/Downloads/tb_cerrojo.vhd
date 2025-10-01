----------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity tb_cerrojo is
end tb_cerrojo;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture beh of tb_cerrojo is
    -- Component Declaration for the Unit Under Test (UUT)
    component cerrojo
      port (
        rst			: IN  std_logic;
        clk			: IN  std_logic;
        boton		: IN  std_logic;
        clave 		: IN  std_logic_vector (7 DOWNTO 0);
        bloqueado 	: OUT std_logic_vector (15 DOWNTO 0);
        display		: OUT std_logic_vector (6 DOWNTO 0);
        s_display	: OUT std_logic_vector (3 DOWNTO 0)
      );
    END component;

    -- Inputs
    signal rst			: std_logic;
    signal clk			: std_logic;
    signal boton		: std_logic;
    signal clave 		: std_logic_vector (7 DOWNTO 0);
    
    -- Outputs
    signal bloqueado 	: std_logic_vector (15 DOWNTO 0);
    signal display		: std_logic_vector (6 DOWNTO 0);
    signal s_display	: std_logic_vector (3 DOWNTO 0);
    
    -- Clock
    constant clk_period : time := 10ns;

begin

	-- Instantiate the Unit Under Test (UUT)
    UUT : cerrojo
      port map (
        rst			=> rst,
        clk			=> clk,
        boton		=> boton,
        clave 		=> clave,
        bloqueado 	=> bloqueado,
        display		=> display,
        s_display	=> s_display 
      );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

   -- Stimulus process
    p_stim : process
    begin
        rst <= '1';
        boton <= '0';
        clave <= "00000000";        
        wait for 45ns;
        rst <= '0';
        
        -- Introduzco la clave y se acierta a la primera
        clave <= "10101010";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
        
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for 10*clk_period;
        
        
        -- Introduzco la clave y se acierta a la segunda
        clave <= "11110000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
       
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
       
        clave <= "11110000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for 10*clk_period;
        
        -- Introduzco la clave y se acierta a la tercera
        clave <= "11001100";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
       
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
        
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;        
       
        clave <= "11001100";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for 10*clk_period;
        
        -- Introduzco la clave y se bloquea (aunque luego le meta la clave correcta)
        clave <= "00110011";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
       
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
        
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;
        
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;                
       
        clave <= "00110011";
        boton <= '1';
        wait for clk_period;
        boton <= '0';
        wait for clk_period;  
        
        clave <= "00000000";
        boton <= '1';
        wait for clk_period;
        
        boton <= '0'; 
                                             
        wait;
    end process p_stim;
end beh;
