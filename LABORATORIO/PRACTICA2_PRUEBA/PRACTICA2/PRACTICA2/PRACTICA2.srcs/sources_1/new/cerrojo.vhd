library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cerrojo is
  Port ( 
    rst       : in  std_logic;
    clk       : in  std_logic;
    boton     : in  std_logic;
    clave     : in  std_logic_vector (7 downto 0);
    num_intentos   : in std_logic_vector (3 downto 0);
    bloqueado : out std_logic_vector (15 DOWNTO 0);
    display   : out std_logic_vector (3 downto 0);
    led_tipo   : out std_logic_vector (2 downto 0)
  );
end cerrojo;

architecture Behavioral of cerrojo is

    type estado is (abierto_est, intermedio_est, bloqueado_est);
    signal estadoActual, estadoSiguiente : estado;
    signal clave_guardada : std_logic_vector (7 downto 0);
    signal boton_presionado : std_logic;
    signal intentos_restantes, intentos_restantes_sig : std_logic_vector (3 downto 0);

begin

    SYNC: process(clk, rst)
      begin
        if (rst = '1') then
          estadoActual <= abierto_est;
          clave_guardada <= (others => '0');
          boton_presionado <= '0';
          intentos_restantes <= num_intentos;
        elsif rising_edge(clk) then
          estadoActual <= estadoSiguiente;
          intentos_restantes <= intentos_restantes_sig;
          boton_presionado <= boton; -- Sincronizar el boton
          if (boton = '1' and estadoActual = abierto_est) then
            clave_guardada <= clave; -- Guardar la clave ingresada
            intentos_restantes <= num_intentos;
          end if;
        end if;
      end process SYNC;


      COMB: process(boton_presionado, clave, clave_guardada, estadoActual, intentos_restantes, intentos_restantes_sig)
      begin
      
        estadoSiguiente <= estadoActual; -- Por defecto, permanecer en el mismo estado
        intentos_restantes_sig <= intentos_restantes;
        led_tipo <= "001";

        case estadoActual is
          when abierto_est =>
            bloqueado <= (others => '1'); -- Desbloqueado
            if (boton_presionado = '1' and num_intentos /= "0000") then
              estadoSiguiente <= intermedio_est;
              led_tipo <= "000";
            end if;
            
          when intermedio_est =>
            bloqueado <= (others => '0'); -- Bloqueado
            led_tipo <= "000";
            if (boton_presionado = '1' and clave /= clave_guardada) then
              intentos_restantes_sig <= std_logic_vector(unsigned(intentos_restantes) - 1); -- Si hemos fallado un intento, lo restamos
            elsif (boton_presionado = '1') then
              estadoSiguiente <= abierto_est; -- Volver a abierto si la clave es correcta   
              intentos_restantes_sig <= num_intentos;
              led_tipo <= "001";           
            end if;
            if (intentos_restantes = "0000") then
              estadoSiguiente <= bloqueado_est; -- Si nos hemos quedado sin intentios, bloqueamos el candado
              led_tipo <= "010";                         
            end if;
            
          when bloqueado_est =>
            bloqueado <= (others => '0'); -- Bloqueado
            estadoSiguiente <= bloqueado_est; -- Permanecer bloqueado
            led_tipo <= "010";
        end case;
        
        display <= intentos_restantes_sig; -- intentos restantes
        
      end process COMB;

end Behavioral;