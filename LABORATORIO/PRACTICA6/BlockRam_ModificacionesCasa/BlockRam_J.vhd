library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity BlockRam is
	port (
		clka, wea, ena : in STD_LOGIC;
		addra : in STD_LOGIC_VECTOR (8 downto 0);
		dina : in STD_LOGIC_VECTOR (31 downto 0);
		douta : out STD_LOGIC_VECTOR (31 downto 0)
	);
end BlockRam;

architecture Behavioral of BlockRam is

	type ram_type is array (0 to 511) of std_logic_vector (31 downto 0);
	signal ram : ram_type := 
									(
									   x"00067613", -- andi x12 x12 0      0x00000000  andi a2, a2, 0
									   x"02402503", -- lw x10 36 x0        0x00000004  lw a0, 36(zero)
									   x"02802583", -- lw x11 40 x0        0x00000008  lw a1, 40(zero)
									   x"00058863", -- beq x11 x0 16       0x0000000C  beq a1, zero, 16
									   x"00a60633", -- add x12 x12 x10     0x00000010  add a2, a2, a0
									   x"fff58593", -- addi x11 x11 -1     0x00000014  addi a1, a1, -1
									 --x"fe000ae3", -- beq x0 x0 -12       0x00000018  beq zero, zero, -12
									   x"00C00002", -- j 12                0x00000018  j 12
									   x"02c02623", -- sw x12 44 x0        0x0000001C  sw a2, 44(zero)
									 --x"00000063", -- beq x0 x0 0         0x00000020  beq zero, zero, 0
									   x"02000002", -- j 32                0x00000020  j 32									   
									   x"00000007", -- VALOR A             0x00000024  7
									   x"00000003", -- VALOR B             0x00000028  3
									   x"00000000", -- Resultado	       0x0000002C								   
									   others => x"00000000"
									);

begin

	process( clka )
	begin
		if rising_edge(clka) then
			if ena = '1' then
				if wea = '1' then
					ram(to_integer(unsigned(addra))) <= dina;
					douta <= dina;
				else
					douta <= ram(to_integer(unsigned(addra)));
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

