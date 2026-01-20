library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst: in STD_LOGIC;
        clk: in STD_LOGIC; -- reloj de entrada de la entity superior
        cuenta_medio_segundo: out STD_LOGIC;
        cuenta_display1: out STD_LOGIC;
        cuenta_display2: out STD_LOGIC
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(25 downto 0);
  
  begin
  
  contador:
  PROCESS(rst, clk)
  BEGIN
    IF (rst='1') THEN
      cuenta<= (OTHERS=>'0');
    ELSIF(rising_edge(clk)) THEN
      IF (cuenta="10111110101111000010000000") THEN -- 50.000.000 (0,5 segundos para un reloj de 100MHz)
        cuenta<= (OTHERS=>'0');        
      ELSE
        cuenta <= cuenta+'1';
      END IF;
    END IF;
  END PROCESS contador;
  
  cuenta_medio_segundo <= '1' when (cuenta="10111110101111000010000000") else '0';
  cuenta_display1 <= '1' when (cuenta(2 downto 0) = "100") else '0';
  cuenta_display2 <= '1' when (cuenta(3 downto 0) = "1001") else '0';

end divisor_arch;
