library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

entity tragaperrasASMBasys3 is
    port (
        rst             : in  STD_LOGIC;
        clk             : in  STD_LOGIC;        
        inicio          : in  STD_LOGIC;
        fin             : in  STD_LOGIC;
        leds            : out STD_LOGIC_VECTOR(15 DOWNTO 0);
        display         : out STD_LOGIC_VECTOR (6 downto 0);
        display_enable  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end tragaperrasASMBasys3;

architecture behavioural of tragaperrasASMBasys3 is

    component debouncer
      port (
        rst: IN std_logic;
        clk: IN std_logic;
        x: IN std_logic;
        xDeb: OUT std_logic;
        xDebFallingEdge: OUT std_logic;
        xDebRisingEdge: OUT std_logic
      );
    end component;   
  
    component displays
        Port ( 
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;       
            digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
            display : out  STD_LOGIC_VECTOR (6 downto 0);
            display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
         );
    end component;
    
    component efectosLEDs
      Port (
        rst             : IN  std_logic;
        clk             : IN  std_logic;
        opCode          : IN  std_logic_vector(2 downto 0);
        LEDs            : OUT std_logic_vector(15 downto 0)   
      );
    end component;

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

    signal inicio_debouncer: std_logic;
    signal fin_debouncer: std_logic;

    signal opCodeLeds: std_logic_vector(2 downto 0);
    signal ruleta01: std_logic_vector(3 downto 0);
    signal ruleta02: std_logic_vector(3 downto 0);
  
begin

    debouncer_incio : debouncer
        port map(
            rst             => rst,
            clk             => clk,
            x               => inicio,
            xDeb            => open,
            xDebFallingEdge => open,
            xDebRisingEdge  => inicio_debouncer
          );
          
    debouncer_fin : debouncer
        port map(
            rst             => rst,
            clk             => clk,
            x               => fin,
            xDeb            => open,
            xDebFallingEdge => open,
            xDebRisingEdge  => fin_debouncer
          );          
    
    tragaperrasASM_i : tragaperrasASM
        port map (
            rst             => rst,
            clk             => clk,        
            inicio          => inicio_debouncer,
            fin             => fin_debouncer,
            opCodeleds      => opCodeLeds,
            ruleta01        => ruleta01,
            ruleta02        => ruleta02
        );
   
    displays_i : displays
        port map ( 
            rst             => rst,
            clk             => clk,       
            digito_0        => ruleta01,
            digito_1        => ruleta02,
            digito_2        => "0000",
            digito_3        => "0000",
            display         => display,
            display_enable  => display_enable
         );   

    efectosLEDs_i : efectosLEDs
        port map (
            rst     => rst,
            clk     => clk, 
            opCode  => opCodeLeds,
            LEDs    => leds   
        );
      

end behavioural;
