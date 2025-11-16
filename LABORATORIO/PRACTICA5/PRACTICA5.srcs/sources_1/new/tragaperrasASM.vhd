----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2025 15:59:13
-- Design Name: 
-- Module Name: tragaperrasASM - Behavioral
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

entity tragaperrasASM is
    port (
        rst             : in  STD_LOGIC;
        clk             : in  STD_LOGIC;        
        inicio          : in  STD_LOGIC;
        fin             : in  STD_LOGIC;
        opCodeleds      : out STD_LOGIC_VECTOR (2 downto 0);
        ruleta01        : out STD_LOGIC_VECTOR (3 downto 0);
        ruleta02        : out STD_LOGIC_VECTOR (3 downto 0)
    );
end tragaperrasASM;

architecture Behavioral of tragaperrasASM is

    -- Definimos los estados
    type estado_t is (ESPERA, GIRANDO, INTERMEDIO, PREMIO, NOPREMIO);
    signal estado_actual, estado_siguiente : estado_t;

    -- Señales para los contadores de las ruletas
    signal cuenta10_01, cuenta10_02 : STD_LOGIC_VECTOR (3 downto 0);
    signal enable_01, enable_02 : STD_LOGIC;

    -- Componente contador modulo 10
    component contador10
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            enable : in STD_LOGIC;
            cuenta10 : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

begin

    -- Instanciamos los contadores para las ruletas
    RULETA01: contador10
        port map (
            clk => clk,
            rst => rst,
            enable => enable_01,
            cuenta10 => cuenta10_01
        );

    RULETA02: contador10
        port map (
            clk => clk,
            rst => rst,
            enable => enable_02,
            cuenta10 => cuenta10_02
        );

    SYNC_PROCESS: process(clk, rst)
    begin
        if rst = '1' then
            estado_actual <= ESPERA;
        elsif rising_edge(clk) then
            estado_actual <= estado_siguiente;
        end if;
    end process;

    COMB_PROCESS: process(estado_actual, inicio, fin)
    begin
        -- Valores por defecto
        estado_siguiente <= estado_actual;
        enable_01 <= '0';
        enable_02 <= '0';
        opCodeleds <= "000";
        ruleta01 <= cuenta10_01;
        ruleta02 <= cuenta10_02;

        case estado_actual is
            when ESPERA =>
                opCodeleds <= "100";
                enable_01 <= '0';
                enable_02 <= '0';
                if inicio = '1' then
                    estado_siguiente <= GIRANDO;
                end if;

            when GIRANDO =>
                opCodeleds <= "000";
                enable_01 <= '1';
                enable_02 <= '1';
                if fin = '1' then
                    estado_siguiente <= INTERMEDIO;
                end if;

            -- Estado para los registros intermedios
            when INTERMEDIO =>
                enable_01 <= '0';
                enable_02 <= '0';
                if cuenta10_01 = cuenta10_02 then
                    estado_siguiente <= PREMIO;
                else
                    estado_siguiente <= NOPREMIO;
                end if;
                
            when PREMIO =>
                opCodeleds <= "010";
                enable_01 <= '0';
                enable_02 <= '0';
                estado_siguiente <= ESPERA;

            when NOPREMIO =>
                opCodeleds <= "011";
                enable_01 <= '0';
                enable_02 <= '0';
                estado_siguiente <= ESPERA;

        end case;
    end process;

end Behavioral;
