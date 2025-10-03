library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cerrojo is
  Port ( 
    rst       : in  std_logic;
    clk       : in  std_logic;
    boton     : in  std_logic;
    clave     : in  std_logic_vector (7 downto 0);
    bloqueado : out std_logic_vector (15 DOWNTO 0);
    display   : out std_logic_vector (3 downto 0)
  );
end cerrojo;

architecture Behavioral of cerrojo is

    type estado is (abierto_est, intentos_3_est, intentos_2_est, intentos_1_est, bloqueado_est);
    signal estadoActual, estadoSiguiente : estado;
    signal clave_guardada : std_logic_vector (7 downto 0);

begin

    SYNC: process(clk, rst)
      begin
        if (rst = '1') then
          estadoActual <= abierto_est;
          clave_guardada <= (others => '0');
        elsif rising_edge(clk) then
          estadoActual <= estadoSiguiente;
          if (boton = '1' and estadoActual = abierto_est) then
            clave_guardada <= clave; -- Guardar la clave ingresada
          end if;
        end if;
      end process SYNC;


      COMB: process(boton, clave, clave_guardada, estadoActual)
      begin

        estadoSiguiente <= abierto_est; -- Valor por defecto

        case estadoActual is
          when abierto_est =>
            display <= "0011"; -- 3 intentos restantes
            bloqueado <= (others => '1'); -- Desbloqueado
            if (boton = '1') then
              estadoSiguiente <= intentos_3_est;
            end if;
          when intentos_1_est =>
            display <= "0011"; -- 3 intentos restantes
            bloqueado <= (others => '0'); -- Bloqueado
            if (boton = '1' and clave /= clave_guardada) then
              estadoSiguiente <= intentos_2_est;
            end if;
          when intentos_2_est =>
            display <= "0010"; -- 2 intentos restantes
            bloqueado <= (others => '0'); -- Bloqueado
            if (boton = '1' and clave /= clave_guardada) then
              estadoSiguiente <= intentos_1_est;
            end if;
          when intentos_3_est =>
            display <= "0001"; -- 1 intento restante
            bloqueado <= (others => '0'); -- Bloqueado
            if (boton = '1' and clave /= clave_guardada) then
              estadoSiguiente <= bloqueado_est;
            end if;
          when bloqueado_est =>
            display <= "0000"; -- 0 intentos restantes
            bloqueado <= (others => '0'); -- Bloqueado
            estadoSiguiente <= bloqueado_est; -- Permanecer bloqueado
        end case;
      end process COMB;

end Behavioral;

