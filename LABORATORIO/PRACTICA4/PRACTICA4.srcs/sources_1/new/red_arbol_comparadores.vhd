----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2025 11:35:59
-- Design Name: 
-- Module Name: red_arbol_comparadores - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity red_arbol_comparadores is
    generic (
        num_bits : natural := 4;
        num_entradas : natural := 4
    );
    port(
        X : in std_logic_vector (num_entradas*num_bits-1 downto 0);
        S : out std_logic_vector (num_bits-1 downto 0)
    );
end red_arbol_comparadores;

architecture Behavioral of red_arbol_comparadores is

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

function Log2( input:integer ) return integer is
    variable temp,log:integer;
begin
    temp:=input;
    log:=0;
        while (temp >1) loop
            temp:=temp/2;
            log:=log+1;
        end loop;
    return log;
end function log2;

type C_type is array (Log2(num_entradas) downto 0, num_entradas-1 downto 0) of std_logic_vector(num_bits-1 downto 0);
signal aux : C_type;

begin
gen_entradas: for i in 0 to num_entradas-1 generate
  aux(0, i) <= X(i * num_bits + num_bits - 1 downto i * num_bits);
end generate gen_entradas;

gen_niveles: for i in 0 to Log2(num_entradas)-1 generate
    gen_compradores: for j in 0 to (num_entradas/2**(i+1))-1 generate 
        comparador_i: comparador 
            generic map(
                num_bits => num_bits
            )
            port map (
                A => aux(i, j),
                B => aux(i, (j+num_entradas/2**(i+1))),
                S => aux(i + 1,j)
    );
    end generate gen_compradores;
end generate gen_niveles;
S <= aux(Log2(num_entradas),0);
end Behavioral;

