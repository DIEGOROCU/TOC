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
									 --x"0006f693", -- andi x13 x13 0      0x00000000  andi a3, a3, 0
									   x"00000690", -- mv x13 0            0x00000000  mv a3, 0
									   x"02802503", -- lw x10 40 x0        0x00000004  lw a0, 40(zero)
									   x"02c02583", -- lw x11 44 x0        0x00000008  lw a1, 44(zero)
									   x"00058863", -- beq x11 x0 16       0x0000000C  beq a1, zero, 16
									   x"00a686b3", -- add x13 x13 x10     0x00000010  add a3, a3, a0
									   x"fff58593", -- addi x11 x11 -1     0x00000014  addi a1, a1, -1
									   x"fe000ae3", -- beq x0 x0 -12       0x00000018  beq zero, zero, -12									   
									 --x"00068613", -- addi x12 x13 0      0x0000001C  addi a2, a3, zero
									   x"00068612", -- mv x12 x13          0x0000001C  mv a2, a3									   
									   x"02c02623", -- sw x12 48 x0        0x00000020  sw a2, 48(zero)
									   x"00000063", -- beq x0 x0 0         0x00000024  beq zero, zero, 0
									   x"00000007", -- VALOR A             0x00000028  7
									   x"00000003", -- VALOR B             0x0000002C  3
									   x"00000000", -- Resultado	       0x00000030								   
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

