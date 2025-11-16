library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-------------------------------------------------------------------------------
-- Entidad
-------------------------------------------------------------------------------
entity tb_tragaperras is
end tb_tragaperras;

-------------------------------------------------------------------------------
-- Arquitectura
-------------------------------------------------------------------------------

architecture beh of tb_tragaperras is

-- Declaracion del componente que vamos a simular
    component tragaperrasASM
        port (
            rst             : in  STD_LOGIC;
            clk             : in  STD_LOGIC;        
            inicio          : in  STD_LOGIC;
            fin             : in  STD_LOGIC;
            opCodeleds      : out STD_LOGIC_VECTOR (2 downto 0);
            ruleta01        : out STD_LOGIC_VECTOR (3 downto 0);
            ruleta02        : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

-- Entradas
  signal rst             : std_logic;
  signal clk             : std_logic;
  signal inicio          : std_logic;
  signal fin             : std_logic;  

-- Salidas
  signal opCodeleds      : STD_LOGIC_VECTOR (2 downto 0);
  signal ruleta01        : STD_LOGIC_VECTOR (3 downto 0);
  signal ruleta02        : STD_LOGIC_VECTOR (3 downto 0);

-- Clock
  constant clk_period : time := 10ns;
  
begin

-- Instanciacion de la unidad a simular 
  dut : tragaperrasASM
        port map(
            rst             => rst,
            clk             => clk,
            inicio          => inicio,
            fin             => fin,
            opCodeleds      => opCodeleds,
            ruleta01        => ruleta01,
            ruleta02        => ruleta02
      );

    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

-- Proceso de estimulos
  p_stim : process
    variable i : natural := 0;
  begin
    rst <= '1';
    inicio <= '0';
    fin <= '0';
    wait for 35 ns;
    rst <= '0';
    wait for 20 ns;
      
    i_loop : for i in 1 to 15 loop    
        inicio <= '1';
        wait for clk_period;
        inicio <= '0';
        wait for clk_period;
        wait for 5ms*i; 
        fin <= '1';
        wait for clk_period;
        fin <= '0';    
        wait until opCodeLeds /= "000";
        if (opCodeLeds = "010") then
            if (ruleta01 = ruleta02) then
                report "INFO: �Has acertado!";
            else
                report "ERROR_1: los leds y los displays no concuerdan";
            end if;
        else
            if (ruleta01 = ruleta02) then
                report "ERROR_2: los leds y los displays no concuerdan";
            else
                report "INFO: Has fallado";
            end if;    
        end if;
        wait until opCodeLeds = "100";
        wait for 10*clk_period;
    end loop i_loop;
    
    wait;
  end process p_stim;

end beh;
