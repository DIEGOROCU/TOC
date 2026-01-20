----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 19:56:49
-- Design Name: 
-- Module Name: multiplicador2 - Behavioral
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

entity mult8b is

    port ( 
        X : in  std_logic_vector(3 downto 0);
        Y : in  std_logic_vector(3 downto 0);
        Z : out std_logic_vector(7 downto 0) 
    );


end mult8b;

architecture struct of mult8b is

    -- Declaración del componente sumador
    component sumador
        Port (
            A : IN   std_logic_vector(7 downto 0);
            B : IN   std_logic_vector(7 downto 0);
            C : OUT  std_logic_vector(7 downto 0)   
        );
    END component;

    -- Declaración de señales internas para conectar los sumadores
    signal sum1_in_left : std_logic_vector(7 downto 0);
    signal sum1_in_right : std_logic_vector(7 downto 0);
    signal sum1_out : std_logic_vector(7 downto 0);

    signal sum2_in_left : std_logic_vector(7 downto 0);
    signal sum2_out : std_logic_vector(7 downto 0);

    signal sum3_in_left : std_logic_vector(7 downto 0);
    signal sum3_out : std_logic_vector(7 downto 0);

begin

    comb: process(X, Y)
    begin
        -- Example logic for the inputs of the sumadores
        -- X & y_1 
        sum1_in_left <= "000" & (X(3) and Y(1)) & (X(2) and Y(1)) & (X(1) and Y(1)) & (X(0) and Y(1)) & "0";
        -- X & y_0
        sum1_in_right <= "0000" & (X(3) and Y(0)) & (X(2) and Y(0)) & (X(1) and Y(0)) & (X(0) and Y(0));
    
        -- X & y_2
        sum2_in_left <= "00" & (X(3) and Y(2)) & (X(2) and Y(2)) & (X(1) and Y(2)) & (X(0) and Y(2)) & "00";
    
        -- X & y_3
        sum3_in_left <= "0" & (X(3) and Y(3)) & (X(2) and Y(3)) & (X(1) and Y(3)) & (X(0) and Y(3)) & "000";
    
    end process;

    -- Instancia del primer sumador
    sumador1: sumador
        port map (
            A => sum1_in_left,
            B => sum1_in_right,
            C => sum1_out
        );

    -- Instancia del segundo sumador
    sumador2: sumador
        port map (
            A => sum2_in_left,
            B => sum1_out,
            C => sum2_out
        );

    -- Instancia del tercer sumador
    sumador3: sumador
        port map (
            A => sum3_in_left,
            B => sum2_out,
            C => sum3_out
        );

    
    Z <= sum3_out;

end struct;
