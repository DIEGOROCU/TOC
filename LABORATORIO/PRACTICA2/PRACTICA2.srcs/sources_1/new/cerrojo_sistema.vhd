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

architecture Behavioral of cerrojo_sistema is

    --type estado is (sin_contrasena)

begin


end Behavioral;
