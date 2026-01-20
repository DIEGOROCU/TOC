----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 19:55:04
-- Design Name: 
-- Module Name: sumador - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sumador is
  Port (
    A : IN   std_logic_vector(7 downto 0);
    B : IN   std_logic_vector(7 downto 0);
    C : OUT  std_logic_vector(7 downto 0)   
  );
end sumador;

architecture Behavioral of sumador is

begin

  C <= A + B;

end Behavioral;

