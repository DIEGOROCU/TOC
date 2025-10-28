library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cerrojo is
  Port ( 
    rst       : in  std_logic;
    clk       : in  std_logic;
    boton     : in  std_logic;
    clave     : in  std_logic_vector (7 downto 0);
    num_intentos : in std_logic_vector (3 downto 0);
    bloqueado : out std_logic_vector (15 DOWNTO 0);
    display   : out std_logic_vector (3 downto 0)
  );
end cerrojo;

architecture Behavioral of cerrojo is

    type estado is (abierto_est, intermedio_est, bloqueado_est);
    signal estadoActual, estadoSiguiente : estado;
    signal clave_guardada : std_logic_vector (7 downto 0);
    signal boton_presionado : std_logic;
    signal intentos_restantes : std_logic_vector (3 downto 0);
    

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
          boton_presionado <= boton; -- Sincronizar el boton
          if (boton = '1' and estadoActual = abierto_est) then
            clave_guardada <= clave; -- Guardar la clave ingresada
            intentos_restantes <= num_intentos; -- Reiniciar intentos
          end if;
        end if;
      end process SYNC;


      COMB: process(boton_presionado, clave, clave_guardada, estadoActual)
      begin

        estadoSiguiente <= estadoActual; -- Por defecto, permanecer en el mismo estado
        display <= intentos_restantes; -- Mostrar los intentos restantes por defecto

        case estadoActual is
          when abierto_est =>
            bloqueado <= (others => '1'); -- Desbloqueado
            if (boton_presionado = '1' and num_intentos /= "0000") then
              estadoSiguiente <= intermedio_est; -- Ir a intermedio al presionar el boton
            end if;
          when intermedio_est =>
            bloqueado <= (others => '0'); -- Bloqueado
            if (boton_presionado = '1' and clave /= clave_guardada) then
              intentos_restantes <= std_logic_vector(unsigned(intentos_restantes) - 1);
            elsif (boton_presionado = '1') then
              estadoSiguiente <= abierto_est; -- Volver a abierto si la clave es correcta              
            end if;
            if (intentos_restantes = "0000") then
              estadoSiguiente <= bloqueado_est; -- Ir a bloqueado si no quedan intentos
            end if;
          when bloqueado_est =>
            bloqueado <= (others => '0'); -- Bloqueado
            estadoSiguiente <= bloqueado_est; -- Permanecer bloqueado
        end case;
      end process COMB;

end Behavioral;