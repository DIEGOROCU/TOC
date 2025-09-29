library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ej04 is
    Port ( 
		a   : in  STD_LOGIC_VECTOR(3 downto 0);
      odd : out STD_LOGIC
    );
end ej04;

architecture RTL of ej04 is

	component XOR1bit
		 Port ( 
			x : in  STD_LOGIC;
			y : in  STD_LOGIC;
			z : out STD_LOGIC
		 );
	end component;

	signal sig1 : std_logic;
	signal sig2 : std_logic;

begin		
	
	unit_10 : XOR1bit
		 Port map ( 
			x => a(0),
			y => a(1),
			z => sig1
		 );
		 
	unit_11 : XOR1bit
		 Port map ( 
			x => a(2),
			y => a(3),
			z => sig2
		 );		 

	unit_2 : XOR1bit
		 Port map ( 
			x => sig1,
			y => sig2,
			z => odd
		 );

end RTL;

