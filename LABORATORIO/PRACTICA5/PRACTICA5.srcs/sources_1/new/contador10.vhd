library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador10 is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enable : in STD_LOGIC;
        cuenta10 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end contador10;

architecture Behavioral of contador10 is
    signal cuenta : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin

    process(clk, rst)
    begin
        if rst = '1' then
            cuenta <= "0000";

        elsif rising_edge(clk) then
            if enable = '1' then
                if cuenta = "1001" then
                    cuenta <= "0000";
                else
                    cuenta <= std_logic_vector(unsigned(cuenta) + 1);
                end if;
            end if;
        end if;
    end process;

    cuenta10 <= cuenta;

end Behavioral;
