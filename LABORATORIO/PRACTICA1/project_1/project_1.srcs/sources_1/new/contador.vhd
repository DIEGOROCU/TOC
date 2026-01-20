----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2025 09:16:46
-- Design Name: 
-- Module Name: contador - Behavioral
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

entity contador is
    port (
    rst    : IN  std_logic;
    clk    : IN  std_logic;
    cuenta : IN  std_logic;
    S      : OUT std_logic_vector(3 downto 0)   
  );
end contador;

architecture struct of contador is
    component sumador
    port (
      A : IN   std_logic_vector(3 downto 0);
      B : IN   std_logic_vector(3 downto 0);
      C : OUT  std_logic_vector(3 downto 0)   
    );
    end component;
    component divisor
    port (
        rst         : in  std_logic;
        clk_entrada : in  std_logic;
        clk_salida  : out std_logic
    );
    end component;
    component registro
    port (
    rst  : IN  std_logic;
    clk  : IN  std_logic;
    load : IN  std_logic;
    E    : IN  std_logic_vector(3 downto 0);
    S    : OUT std_logic_vector(3 downto 0)   
  );
  end component;
  signal suma_res: std_logic_vector(3 downto 0);
  signal registro_res: std_logic_vector(3 downto 0);
  signal division_res: std_logic;
begin
    mod_div: divisor port map (rst, clk, division_res);
    mod_sum: sumador port map ("0001", registro_res, suma_res);
    mod_reg: registro port map (rst, division_res, cuenta, suma_res, registro_res);
    S <= registro_res;
end architecture struct;
