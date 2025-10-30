----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2023 11:24:10
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparador is
generic (
    num_bits: natural:=4
);

    Port (
    A: in std_logic_vector(num_bits-1 downto 0);
    B: in std_logic_vector(num_bits-1 downto 0);
    S: out std_logic_vector (num_bits-1 downto 0);
    G: out std_logic
    
     );
end comparador;

architecture Behavioral of comparador is

begin
process (A, B)
    begin
        if signed(A) <= signed(B) then
            S <= A;
            G <= '0';
        else
            S <= B;
            G <= '1';
        end if;
    end process;
end Behavioral;
