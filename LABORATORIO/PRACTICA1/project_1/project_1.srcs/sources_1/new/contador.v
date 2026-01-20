library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        rst         : in  std_logic;
        clk_entrada : in  std_logic;
        clk_salida  : out std_logic
    );
end divisor;

architecture divisor_arch of divisor is

 signal cuenta  : std_logic_vector(25 downto 0);
 signal clk_aux : std_logic;
  
  
begin
 
  clk_salida<=clk_aux;
  
  contador:
  process(rst, clk_entrada)
  begin
    if (rst='1') then
      cuenta<= (others=>'0');
      clk_aux<='0';
    elsif(rising_edge(clk_entrada)) then
      IF (cuenta="10111110101111000010000000") then
      	clk_aux <= not clk_aux;
        cuenta<= (others=>'0');
      else
        cuenta <= cuenta+'1';
        clk_aux<=clk_aux;
      end if;
    end if;
  end process contador;

end divisor_arch;
