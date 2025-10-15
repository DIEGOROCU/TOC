----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 19:28:49
-- Design Name: 
-- Module Name: multiplicador - Behavioral
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
-- use the numeric_std library for arithmetic operations
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code. 
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult8b is

    port ( 
        X : in  std_logic_vector(3 downto 0);
        Y : in  std_logic_vector(3 downto 0);
        Z : out std_logic_vector(7 downto 0) 
    );

end mult8b;

architecture Behavioral of mult8b is

begin

    COMB: process(X, Y)
    begin
        Z <= std_logic_vector(unsigned(X) * unsigned(Y));
    end process COMB;


end Behavioral;
