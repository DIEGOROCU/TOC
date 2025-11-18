library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity bancoDeRegistros is
	port( 
		clk		  : in  std_logic;
		rst		  : in  std_logic;
		RA1		  : in  std_logic_vector(4 downto 0);
		RA2		  : in  std_logic_vector(4 downto 0);
		WE        : in  std_logic;
		WA		  : in  std_logic_vector(4 downto 0);
		WD    	  : in  std_logic_vector(31 downto 0);
		RD1   	  : out std_logic_vector(31 downto 0);
		RD2   	  : out std_logic_vector(31 downto 0);
		A2			: out std_logic_vector(31 downto 0)
	);
end bancoDeRegistros;

architecture bancoDeRegistrosArch of bancoDeRegistros is
   
	type banco_regsitro_type  is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal bancoDeRegistros : banco_regsitro_type;
	
begin

	escritura:
	process(clk, rst)
	begin
		if (rst = '1') then
			for i in 0 to 31 loop
				bancoDeRegistros(i) <= (others=>'0');
			end loop;		
		elsif rising_edge(clk) then
			if (WE = '1'and WA /= "00000") then
            bancoDeRegistros(to_integer(unsigned(WA))) <= WD;
         end if;
		end if;
   end process;
	
	lectura:
	RD1 <= bancoDeRegistros(to_integer(unsigned(RA1)));
	RD2 <= bancoDeRegistros(to_integer(unsigned(RA2)));
	
	A2 <= bancoDeRegistros(12);

end bancoDeRegistrosArch;