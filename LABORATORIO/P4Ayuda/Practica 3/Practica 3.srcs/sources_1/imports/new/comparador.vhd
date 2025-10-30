----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2023 09:06:17
-- Design Name: 
-- Module Name: comparador - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.all;

entity comparador is
    PORT (
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        S: out std_logic_vector(7 downto 0);
    );
end comparador;

architecture Behavioral of Comparador is
begin
    process (A, B)
    begin
        if A > B then
          S <= A;
        else
          S <= B;
        end if;
    end process;
end Behavioral;
