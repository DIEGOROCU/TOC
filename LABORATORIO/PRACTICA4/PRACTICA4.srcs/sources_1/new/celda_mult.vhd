----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2025 10:21:16
-- Design Name: 
-- Module Name: celda_mult - Behavioral
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

entity celda_mult is
    Port ( 
        M_in : in std_logic;
        n_in : in std_logic;
        Ar_in : in std_logic;
        Pp_in : in std_logic;
        
        M_out : out std_logic;
        n_out : out std_logic;
        Ar_out : out std_logic;
        Pp_out : out std_logic
    );
end celda_mult;

architecture Behavioral of celda_mult is

signal andAux, sumaAux: std_logic;

begin

    andAux <= M_in and n_in;
    sumaAux <= andAux xor Pp_in;

    Pp_out <= sumaAux xor Ar_in;
    Ar_out <= (andAux and Pp_in) or (Ar_in and (sumaAux or Pp_in));

    M_out <= M_in;
    n_out <= n_in;

end Behavioral;
