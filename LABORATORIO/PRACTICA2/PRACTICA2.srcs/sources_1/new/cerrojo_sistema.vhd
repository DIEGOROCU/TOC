library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cerrojo_sistema is
  Port ( 
    rst       : in  std_logic;
    clk       : in  std_logic;
    boton     : in  std_logic;
    clave     : in  std_logic_vector (7 downto 0);
    bloqueado : out std_logic_vector (15 downto 0);
    display   : out std_logic_vector (6 downto 0);
    s_display : out std_logic_vector (3 downto 0)
  
  );
end cerrojo_sistema;

architecture struct of cerrojo_sistema is

    type estado is (abierto_est, intentos_3_est, intentos_2_est, intentos_1_est, bloqueado_est);
    -- Se puede anadir el estado desbloqueado_est
    component cerrojo
      PORT (
        rst			: IN  std_logic;
        clk			: IN  std_logic;
        boton		: IN  std_logic;
        clave 		: IN  std_logic_vector (7 DOWNTO 0);
        bloqueado 	: OUT std_logic_vector (15 DOWNTO 0);
        display		: OUT std_logic_vector (6 DOWNTO 0);
        s_display	: OUT std_logic_vector (3 DOWNTO 0)
      );
    END component;

    component conv_7seg
      PORT (
        x       : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0)
      );
    END component;

    component debouncer
      PORT (
        rst: IN std_logic;
        clk: IN std_logic;
        x: IN std_logic;
        xDeb: OUT std_logic;
        xDebFallingEdge: OUT std_logic;
        xDebRisingEdge: OUT std_logic
      );
    END component;

    signal estadoActual, estadoSiguiente : estado;
    signal intentos_restantes : std_logic_vector (3 downto 0);
    signal bloqueado_int : "1111111111111111";
    signal clave_guardada : std_logic_vector (7 downto 0);
    signal boton_presionado : std_logic;

begin
  cerrojo_my: cerrojo
    port map (
      rst       => rst,
      clk       => clk,
      boton     => boton,
      clave     => clave,
      bloqueado => bloqueado,
      display   => display,
      s_display => s_display
    );

    conv_7seg_my: conv_7seg
      port map (
        intentos_restantes       => "1000",
        display => display
      );

    debouncer_my: debouncer
      port map (
        rst => rst,
        clk => clk,
        x => boton,
        xDeb => open,
        xDebFallingEdge => open,
        xDebRisingEdge => boton_presionado
      );

    SYNC: process(clk, rst)
      begin
        if (rst = '1') then
          estadoActual <= abierto_est;
          bloqueado_int <= (others => '1');
          clave_guardada <= (others => '0');
        elsif rising_edge(clk) then
          estadoActual <= estadoSiguiente;
          bloqueado_int <= bloqueado;
        end if;
      end process SYNC;


      COMB: process(boton, clave, bloqueado_int, clave_guardada, estadoActual, estadoSiguiente)
      begin

        estadoSiguiente <= estadoActual;
        bloqueado_int <= bloqueado;

        case estadoActual is
          when abierto_est =>
            if (boton_presionado = '1') then
              estadoSiguiente <= intentos_3_est;
              clave_guardada <= clave;
            end if;
          when intentos_1_est =>
            if (boton_presionado = '1') then
              if (clave = clave_guardada) then
                estadoSiguiente <= abierto_est;
              else
                estadoSiguiente <= intentos_2_est;
              end if;
            end if;
          when intentos_2_est =>
            if (boton_presionado = '1') then
              if (clave = clave_guardada) then
                estadoSiguiente <= abierto_est;
              else
                estadoSiguiente <= intentos_1_est;
              end if;
            end if;
          when intentos_3_est =>
            if (boton_presionado = '1') then
              if (clave = clave_guardada) then
                estadoSiguiente <= abierto_est;
              else
                estadoSiguiente <= bloqueado_est;
              end if;
            end if;
          when bloqueado_est =>
            if (clave = clave_guardada) then
              estadoSiguiente <= abierto_est;
            end if;
        end case;
      end process COMB;

end struct;
