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
        display		: OUT std_logic_vector (3 DOWNTO 0)
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

    signal intentos_restantes : std_logic_vector (3 downto 0);
    signal boton_presionado : std_logic;
    signal bloqueado_salida : std_logic_vector (15 DOWNTO 0);
    signal salidaProcesada : std_logic_vector (6 downto 0);

begin

  cerrojo_my: cerrojo
    port map (
      rst         => rst,
      clk         => clk,
      boton       => boton_presionado,
      clave       => clave,
      bloqueado   => bloqueado_salida,
      display     => intentos_restantes
    );

  conv_7seg_my: conv_7seg
    port map (
      x         => intentos_restantes,
      display   => salidaProcesada
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
  bloqueado <= bloqueado_salida;
  s_display <= intentos_restantes;
  display <= salidaProcesada;

end struct;
