library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_creditos is
    port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        enable : in  STD_LOGIC;   -- habilita la operación en cada pulso de reloj
        dir    : in  STD_LOGIC;   -- dirección: '1' = subir (+3), '0' = bajar (-1)
        cuenta_creditos : out STD_LOGIC_VECTOR (3 downto 0)
    );
end contador_creditos;

architecture Behavioral of contador_creditos is
    -- Señal interna usada para el conteo (similar a `contador10`)
    signal cuenta : STD_LOGIC_VECTOR (3 downto 0) := "0101"; -- valor por defecto 5
begin

    -- Lógica síncrona: en flanco de reloj, usar directamente `clk` de entrada.
    -- El control `enable` habilita la operación en cada flanco de reloj.
    process(clk, rst)
    begin
        if rst = '1' then
            cuenta <= "0101"; -- 5
        elsif rising_edge(clk) then
            if enable = '1' then
                if dir = '1' then
                    -- sumar 3, saturando en 15: si cuenta >= 13 -> 15, else +3
                    if cuenta >= "1101" then -- 13
                        cuenta <= "1111"; -- 15
                    else
                        cuenta <= std_logic_vector(unsigned(cuenta) + 3);
                    end if;
                else
                    -- dir = '0' -> restar 1, saturando en 0
                    if cuenta = "0000" then
                        cuenta <= "0000";
                    else
                        cuenta <= std_logic_vector(unsigned(cuenta) - 1);
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Exportar la señal interna hacia el puerto de salida
    cuenta_creditos <= cuenta;

end Behavioral;