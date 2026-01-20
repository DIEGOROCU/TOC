----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 11:34:27
-- Design Name: 
-- Module Name: red_iterativa_comparadores - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity red_iterativa_comparadores is
    generic (
        num_bits : natural := 4;
        num_entradas : natural := 4
    );
    port(
        X : in std_logic_vector (num_entradas*num_bits-1 downto 0);
        S : out std_logic_vector (num_bits-1 downto 0)
    );
end red_iterativa_comparadores;

architecture Behavioral of red_iterativa_comparadores is

component comparador is
    generic (
        num_bits : natural := 4
    );
    Port (
        A: in std_logic_vector (num_bits-1 downto 0);
        B: in std_logic_vector (num_bits-1 downto 0);
        S: out std_logic_vector (num_bits-1 downto 0)
    );
end component comparador;

type C_type is array (num_entradas downto 0) of std_logic_vector(num_bits-1 downto 0);
signal aux: C_type;

begin

-- Semilla genérica para reducción cuando buscamos el máximo con comparador (signed):
-- debemos inicializar con el valor mínimo representable en signed (-2^(num_bits-1)).
-- Usamos to_signed para crear esa representación con el ancho correcto.
aux(0) <= std_logic_vector(to_signed(-2**(num_bits-1), num_bits));

gen_celdas: for i in 0 to num_entradas-1 generate
comparador_i: comparador 
    generic map(
        num_bits => num_bits
    )
    port map(
        A=>aux(i),
        B=>X((i+1)*num_bits-1 downto num_bits*i),
        S=>aux(i+1)
    );

end generate  gen_celdas;

S <= aux(num_entradas);
end Behavioral;
