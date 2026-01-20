library IEEE;
use IEEE.std_logic_1164.all;

entity RISCVMulticiclo is
	port( 
		clk		          : in  std_logic;
		rst	              : in  std_logic;
		display	          : out std_logic_vector(6 downto 0);
		display_enable    : out std_logic_vector(3 downto 0);
		modo		      : in 	std_logic;
		siguiente         : in 	std_logic		
	);
end RISCVMulticiclo;

architecture RISCVMulticicloArch of RISCVMulticiclo is

	component unidadDeControl is
		port( 
			clk		  : in  std_logic;
			rst  	  : in  std_logic;
			control	  : out std_logic_vector(17 downto 0);
			estado    : in  std_logic_vector(11 downto 0);
			modo	  : in  std_logic;
		    siguiente : in  std_logic
		);
	end component;

	component rutaDeDatos is
		port( 
			clk		: in  std_logic;
			rst 	: in  std_logic;
			control	: in  std_logic_vector(17 downto 0);
			estado  : out std_logic_vector(11 downto 0);
			A2		: out std_logic_vector(31 downto 0);
			PCout	: out std_logic_vector(31 downto 0)		    
		);
	end component;

	component displays
        port ( 
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

	component debouncer
	  GENERIC(
		 FREQ   : natural := 10000;  	-- frecuencia de operacion en KHz
		 BOUNCE : natural := 100  		-- tiempo de rebote en ms
	  );
	  PORT (
		 rst: IN std_logic;
		 clk: IN std_logic;
		 x: IN std_logic;
		 xDeb: OUT std_logic;
		 xDebFallingEdge: OUT std_logic;
		 xDebRisingEdge: OUT std_logic
	  );
	END component;

	component clk_100Mhz_to_10Mhz
	  PORT (
		 clk_in1: IN std_logic;
		 clk_out1: OUT std_logic
	  );
	END component;
  
	signal control : std_logic_vector(17 downto 0);
	signal estado  : std_logic_vector(11 downto 0);
	
	signal A2 : std_logic_vector(31 downto 0);
	signal PC : std_logic_vector(31 downto 0);
	signal siguienteDebouncer : std_logic;
	signal clk_10Mhz : std_logic;

begin

    divisor_reloj : clk_100Mhz_to_10Mhz port map (clk_in1 => clk, clk_out1 => clk_10Mhz);

    eliminadorRebotesModo : debouncer port map(rst => rst, clk => clk_10Mhz, x => siguiente, xDeb => open, xDebFallingEdge => open, xDebRisingEdge => siguienteDebouncer);

    UC : unidadDeControl port map(clk => clk_10Mhz, rst => rst, control => control, estado => estado, modo => modo, siguiente => siguienteDebouncer);
		
    RD: rutaDeDatos port map(clk => clk_10Mhz, rst => rst, control => control, estado => estado, A2 => A2, PCout => PC); 
    
    displays_i : displays port map(rst => rst, clk => clk, digito_0 => A2(3 downto 0), digito_1 => A2(7 downto 4), digito_2 => "0000", digito_3 => PC(5 downto 2), display => display, display_enable => display_enable);

end RISCVMulticicloArch;