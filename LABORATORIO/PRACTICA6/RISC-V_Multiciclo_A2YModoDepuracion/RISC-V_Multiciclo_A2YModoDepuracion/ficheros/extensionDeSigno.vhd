library ieee; 
use ieee.std_logic_1164.all; 

entity extesnionDeSigno is  
	port( 
		IR	              : in  std_logic_vector(31 downto 0);
		signo_extendido   : out std_logic_vector(31 downto 0)  
	); 
end extesnionDeSigno; 

architecture extesnionDeSignoArch of extesnionDeSigno is 

  signal s1                 : std_logic_vector (31 downto 0);
  signal s2                 : std_logic_vector (31 downto 0);
  signal s3                 : std_logic_vector (31 downto 0);
  signal s4                 : std_logic_vector (31 downto 0);

begin 

	s1(11 downto 0) <= IR(31 downto 20);
	s1(31 downto 12) <= (others=>'1') when (IR(31) = '1') else (others=>'0');
	
	s2(4 downto 0) <= IR(11 downto 7);
	s2(11 downto 5) <= IR(31 downto 25);
	s2(31 downto 12) <= (others=>'1') when (IR(31) = '1') else (others=>'0');
	
	s3(10 downto 5) <= IR(30 downto 25);
	s3(4 downto 1) <= IR(11 downto 8);
	s3(0) <= '0';  
	s3(12) <= IR(31);
	s3(11) <= IR(7);
	s3(31 downto 13) <= (others=>'1') when (IR(31) = '1') else (others=>'0');
	
	s4(10 downto 1) <= IR(30 downto 21);
	s4(19 downto 12) <= IR(19 downto 12);
	s4(0) <= '0';
	s4(11) <= IR(20);
	s4(20) <= IR(31);
	s4(31 downto 21) <= (others=>'1') when (IR(31) = '1') else (others=>'0');
	
	signo_extendido <= s1 when (IR(6 downto 0) = "0000011" or IR(6 downto 0) = "0010011") else
				       s2 when (IR(6 downto 0) = "0100011") else
					   s3 when (IR(6 downto 0) = "1100011") else  
					   s4 when (IR(6 downto 0) = "1101111") else 
					   (others=>'0');
	
end extesnionDeSignoArch;