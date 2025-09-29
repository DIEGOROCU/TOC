library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ej11 is
    Port ( 
		reloj			: in  STD_LOGIC;
		rst				: in  STD_LOGIC;
		Activa 			: in  STD_LOGIC;
		A		 		: in  STD_LOGIC;
		P				: out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end ej11;

architecture Behavioral of ej11 is

	signal rstContador : std_logic;
	signal salidaRegDespla : std_logic_vector(3 downto 0);
	signal cuenta : unsigned(2 downto 0);
	
begin
	
	rstContador <= '1' when (rst = '1' or (Activa = '1' and cuenta = "101")) else '0';
 	
	contador: process(reloj, rstContador)
	begin
		if (rstContador = '1') then
			cuenta <= (others=>'0');
		elsif rising_edge(reloj) then
			if (Activa = '1') then
				cuenta <= cuenta + 1;
			end if;
		end if;
	end process contador;
	
	registro: process(reloj, rst)
	begin
		if (rst = '1') then
			P <= (others=>'0');
		elsif rising_edge(reloj) then
			if (Activa ='1' and cuenta = "101") then
				P <= salidaRegDespla;
			end if;
		end if;
	end process registro;
	
	regDespla: process(reloj, rst)
	begin
		if (rst = '1') then
			salidaRegDespla <= (others=>'0');
		elsif rising_edge(reloj) then
			if (Activa = '1' and (to_integer(cuenta) < 5) and 
											(to_integer(cuenta) > 0))then
				salidaRegDespla <= A&salidaRegDespla(3 downto 1);
			end if;
		end if;
	end process regDespla;

end Behavioral;







