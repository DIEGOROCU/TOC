----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2025 09:53:16
-- Design Name: 
-- Module Name: red_mult - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Red de multiplicación (array multiplier)
-- 
-- Dependencies: celda_mult.vhd
-- 
-- Revision:
-- Revision 0.02 - Código corregido y condiciones de contorno revisadas
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity red_mult is
    generic (
        num_bits : natural := 4
    );
    port(
        X : in  std_logic_vector (num_bits*2-1 downto 0);
        S : out std_logic_vector (num_bits*2-1 downto 0)
    );
end red_mult;

architecture Behavioral of red_mult is

    ------------------------------------------------------------------
    -- Tipos y señales intermedias
    -- Definimos 'matrix' como array de vectores para poder asignar filas completas
    ------------------------------------------------------------------
    type matrix is array (0 to num_bits) of std_logic_vector(num_bits*2 downto 0);
    signal M, n, Ar, Pp : matrix;

    ------------------------------------------------------------------
    -- Declaración del componente celda
    ------------------------------------------------------------------
    component celda_mult is
        Port ( 
            M_in  : in  std_logic;
            n_in  : in  std_logic;
            Ar_in : in  std_logic;
            Pp_in : in  std_logic;
            
            M_out  : out std_logic;
            n_out  : out std_logic;
            Ar_out : out std_logic;
            Pp_out : out std_logic
        );
    end component;

    ------------------------------------------------------------------
    -- Señales de contorno (entradas iniciales)
    ------------------------------------------------------------------
    signal columna_inicial : std_logic_vector(num_bits*2 downto 0);
    signal fila_inicial    : std_logic_vector(num_bits*2 downto 0);

begin

    ------------------------------------------------------------------
    -- Inicialización de contornos
    -- Estas señales representarían los valores iniciales en la parte
    -- superior (Pp) y en la izquierda (Ar, n, M).
    -- Aquí se pueden conectar a 'X' u otros valores según la lógica deseada.
    ------------------------------------------------------------------
    columna_inicial <= (others => '0');
    fila_inicial    <= (others => '0');

    -- Borde superior (Pp) y lateral izquierdo (Ar)
    Pp(0) <= columna_inicial;
    Ar(0) <= fila_inicial;

    -- Inicializamos los bordes superiores e izquierdos del resto de matrices
    M(0) <= (others => '0');
    n(0) <= (others => '0');

    ------------------------------------------------------------------
    -- Generación de la red de celdas
    ------------------------------------------------------------------
    gen_filas: for i in 0 to num_bits-1 generate
        gen_columnas: for j in 0 to num_bits-1 generate 
            u : celda_mult port map (
                M_in  => M(i)(j),
                n_in  => n(i)(j),
                Ar_in => Ar(i)(j),
                Pp_in => Pp(i)(j),

                M_out  => M(i+1)(j),
                n_out  => n(i)(j+1),
                Ar_out => Ar(i)(j+1),
                Pp_out => Pp(i+1)(j)
            );
        end generate gen_columnas;
    end generate gen_filas;

    ------------------------------------------------------------------
    -- Resultado final
    -- Tomamos la última fila y columna como salida
    ------------------------------------------------------------------
    S <= Pp(num_bits)(num_bits*2-1 downto 0) & Ar(num_bits)(num_bits-1 downto 0);

end Behavioral;
