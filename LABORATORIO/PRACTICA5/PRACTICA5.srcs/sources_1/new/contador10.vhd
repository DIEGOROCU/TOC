----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2025 16:10:54
-- Design Name: 
-- Module Name: contador10 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

    PROCESS(clk, rst)
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
            else
                cuenta <= "0000";
        end if;
    end PROCESS;

    cuenta10 <= cuenta;

end Behavioral;
