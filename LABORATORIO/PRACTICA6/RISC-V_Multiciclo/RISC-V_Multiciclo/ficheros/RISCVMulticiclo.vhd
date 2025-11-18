library IEEE;
use IEEE.std_logic_1164.all;

entity RISCVMulticiclo is
	port( 
		clk		          : in  std_logic;
		rst	              : in  std_logic	
	);
end RISCVMulticiclo;

architecture RISCVMulticicloArch of RISCVMulticiclo is

	component unidadDeControl is
		port( 
			clk		  : in  std_logic;
			rst  	  : in  std_logic;
			control	  : out std_logic_vector(17 downto 0);
			estado    : in  std_logic_vector(11 downto 0)
		);
	end component;

	component rutaDeDatos is
		port( 
			clk		: in  std_logic;
			rst 	: in  std_logic;
			control	: in  std_logic_vector(17 downto 0);
			estado  : out std_logic_vector(11 downto 0)		    
		);
	end component;
  
	signal control : std_logic_vector(17 downto 0);
	signal estado  : std_logic_vector(11 downto 0);

begin

    UC : unidadDeControl port map(clk => clk, rst => rst, control => control, estado => estado);
		
    RD: rutaDeDatos port map(clk => clk, rst => rst, control => control, estado => estado); 

end RISCVMulticicloArch;