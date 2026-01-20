library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity efectosLEDs is
  Port (
    rst             : IN  std_logic;
    clk             : IN  std_logic;
    opCode          : IN  std_logic_vector(2 downto 0);
    LEDs            : OUT std_logic_vector(15 downto 0)   
  );
end efectosLEDs;

architecture Behavioral of efectosLEDs is

    signal apagar : std_logic_vector(15 downto 0) := (others=>'0');
    signal encender : std_logic_vector(15 downto 0) := (others=>'1');
    signal parpadear : std_logic_vector(15 downto 0) := (others=>'0');
    signal alternar : std_logic_vector(15 downto 0) := "1010101010101010";
    signal barraProgreso : std_logic_vector(31 downto 0) := "11111111111111110000000000000000";
    
    signal cuenta : std_logic_vector(25 downto 0);

begin

    with opCode select
        LEDs <= apagar                      when "000",
                encender                    when "001",
                parpadear                   when "010",
                alternar                    when "011",
                barraProgreso(15 downto 0)  when "100",
                apagar                      when others;

    contador:
    process(rst, clk)
    begin
        if ( rising_edge(clk) ) then
            if ( rst = '1' ) then
                apagar <= (others=>'0');
                encender <= (others=>'1');
                parpadear <= (others=>'0');
                alternar <= "1010101010101010";
                barraProgreso <= "11111111111111110000000000000000";
                cuenta <= (OTHERS=>'0');
            elsif ( cuenta = "10111110101111000010000000" ) then -- 50.000.000 (0,5 segundos para un reloj de 100MHz)
                parpadear <= not parpadear;  
                alternar <= not alternar;
                barraProgreso <= barraProgreso(0) & barraProgreso(31 downto 1);          
                cuenta <= (OTHERS=>'0');
            else
                cuenta <= cuenta + '1';
            end if;
        end if;            
    end process contador;

end Behavioral;
