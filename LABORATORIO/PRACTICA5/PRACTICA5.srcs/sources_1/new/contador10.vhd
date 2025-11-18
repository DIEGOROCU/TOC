library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador10 is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enable : in STD_LOGIC;
        cuenta10 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end contador10;

architecture Behavioral of contador10 is
    signal cuenta : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    -- Componente divisor existente en el proyecto
    component divisor is
        port (
            rst: in STD_LOGIC;
            clk: in STD_LOGIC;
            cuenta_medio_segundo: out STD_LOGIC;
            cuenta_display1: out STD_LOGIC;
            cuenta_display2: out STD_LOGIC
        );
    end component;
    signal cuenta_medio_segundo : STD_LOGIC;
    signal cuenta_display1 : STD_LOGIC;
    signal cuenta_display2 : STD_LOGIC;
begin

    -- Instanciar el divisor existente. Usaremos la señal `cuenta_medio_segundo`
    -- como 'clock-enable' para avanzar el contador periódicamente.
    div_inst: divisor
      port map (
        rst => rst,
        clk => clk,
        cuenta_medio_segundo => cuenta_medio_segundo,
        cuenta_display1 => cuenta_display1,
        cuenta_display2 => cuenta_display2
      );

    process(clk, rst)
    begin
        if rst = '1' then
            cuenta <= "0000";

        elsif rising_edge(clk) then
            -- Avanzar solo cuando el divisor produce el pulso y el enable externo esté activo
            if enable = '1' and cuenta_medio_segundo = '1' then
                if cuenta = "1001" then
                    cuenta <= "0000";
                else
                    cuenta <= std_logic_vector(unsigned(cuenta) + 1);
                end if;
            end if;
        end if;
    end process;

    cuenta10 <= cuenta;

end Behavioral;
