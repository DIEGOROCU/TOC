library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tragaperrasASM is
    port (
        rst             : in  STD_LOGIC;
        clk             : in  STD_LOGIC;        
        inicio          : in  STD_LOGIC;
        fin             : in  STD_LOGIC;
        opCodeleds      : out STD_LOGIC_VECTOR (2 downto 0);
        ruleta01        : out STD_LOGIC_VECTOR (3 downto 0);
        ruleta02        : out STD_LOGIC_VECTOR (3 downto 0);
        creditos        : out STD_LOGIC_VECTOR (3 downto 0)
    );
end tragaperrasASM;

architecture Behavioral of tragaperrasASM is

    ----------------------------------------------------------------------------
    -- Estados
    ----------------------------------------------------------------------------
    type estado_t is (ESPERA, GIRANDO, INTERMEDIO, PREMIO, NOPREMIO, BLOQUEADO);
    signal estado_actual, estado_siguiente : estado_t;

    ----------------------------------------------------------------------------
    -- Se�ales de contadores y enables
    ----------------------------------------------------------------------------
    signal cuenta10_01, cuenta10_02, cuenta_medio, cuenta_cred : STD_LOGIC_VECTOR (3 downto 0);
    signal enable_01, enable_02, enable_medio, enable_cred : STD_LOGIC;
    signal dir_aux : STD_LOGIC;
    -- reset del contador de tiempo
    signal reset_medio : STD_LOGIC := '0';

    signal clk_1, clk_2, clk_medio : STD_LOGIC;

    ----------------------------------------------------------------------------
    -- Componentes
    ----------------------------------------------------------------------------
    component contador10
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            enable : in STD_LOGIC;
            cuenta10 : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    component contador_creditos
        port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            enable : in  STD_LOGIC;   -- habilita la operaci�n en cada pulso de reloj
            dir    : in  STD_LOGIC;   -- direcci�n: '1' = subir (+3), '0' = bajar (-1)
            cuenta_creditos : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component divisor
    port (
        rst: in STD_LOGIC;
        clk: in STD_LOGIC;
        cuenta_medio_segundo: out STD_LOGIC;
        cuenta_display1: out STD_LOGIC;
        cuenta_display2: out STD_LOGIC
    );
    end component;

begin

    ----------------------------------------------------------------------------
    -- Divisor de frecuencia
    ----------------------------------------------------------------------------
    MI_DIVISOR: divisor
        port map (
            rst => rst,
            clk => clk,
            cuenta_medio_segundo => clk_medio,
            cuenta_display1 => clk_1,
            cuenta_display2 => clk_2
        );

    ----------------------------------------------------------------------------
    -- Contadores de ruletas
    ----------------------------------------------------------------------------
    RULETA01_COMP: contador10
        port map (
            clk => clk_1,
            rst => rst,
            enable => enable_01,
            cuenta10 => cuenta10_01
        );

    RULETA02_COMP: contador10
        port map (
            clk => clk_2,
            rst => rst,
            enable => enable_02,
            cuenta10 => cuenta10_02
        );

    ----------------------------------------------------------------------------
    -- Contador de tiempos PREMIO/NOPREMIO
    ----------------------------------------------------------------------------
    MEDIOSEG_CONT: contador10
        port map (
            clk => clk_medio,
            rst => reset_medio,
            enable => enable_medio,
            cuenta10 => cuenta_medio
        );
        
    CREDITOS_CONT: contador_creditos
        port map (
            clk => clk,
            rst => rst,
            enable => enable_cred,
            dir => dir_aux,
            cuenta_creditos => cuenta_cred
        );

    ----------------------------------------------------------------------------
    -- Proceso secuencial: Actualizar estado
    ----------------------------------------------------------------------------
    SYNC_PROCESS: process(clk, rst)
    begin
        if rst = '1' then
            estado_actual <= ESPERA;
        elsif rising_edge(clk) then
            estado_actual <= estado_siguiente;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Proceso combinacional: L�gica del FSM
    ----------------------------------------------------------------------------
    COMB_PROCESS: process(estado_actual, inicio, fin, cuenta10_01, cuenta10_02, cuenta_medio)
    begin
        -- Valores por defecto
        estado_siguiente <= estado_actual;
        enable_01 <= '0';
        enable_02 <= '0';
        enable_medio <= '0';
        enable_cred <= '0';
        reset_medio <= '0';
        opCodeleds <= "000";

        ruleta01 <= cuenta10_01;
        ruleta02 <= cuenta10_02;

        case estado_actual is

            ----------------------------------------------------------------------------
            -- ESPERA
            ----------------------------------------------------------------------------
            when ESPERA =>
                opCodeleds <= "100";
                if inicio = '1' then
                    enable_cred <= '1';
                    dir_aux <= '0';
                    estado_siguiente <= GIRANDO;
                end if;

            ----------------------------------------------------------------------------
            -- GIRANDO
            ----------------------------------------------------------------------------
            when GIRANDO =>
                enable_01 <= '1';
                enable_02 <= '1';
                if fin = '1' then
                    estado_siguiente <= INTERMEDIO;
                end if;

            ----------------------------------------------------------------------------
            -- INTERMEDIO: decidir premio o no premio
            ----------------------------------------------------------------------------
            when INTERMEDIO =>
                -- Reiniciar contador de espera
                reset_medio <= '1';
                if cuenta10_01 = cuenta10_02 then
                    enable_cred <= '1';
                    dir_aux <= '1';
                    estado_siguiente <= PREMIO;
                else
                    estado_siguiente <= NOPREMIO;
                end if;

            ----------------------------------------------------------------------------
            -- PREMIO
            ----------------------------------------------------------------------------
            when PREMIO =>
                opCodeleds <= "010";
                enable_medio <= '1';       
                if cuenta_medio = "1001" then
                    estado_siguiente <= ESPERA;
                end if;

            ----------------------------------------------------------------------------
            -- NOPREMIO
            ----------------------------------------------------------------------------
            when NOPREMIO =>
                opCodeleds <= "011";
                enable_medio <= '1';
                if cuenta_cred = "0000" then
                   estado_siguiente <= BLOQUEADO;    
                elsif cuenta_medio = "1001" then
                    estado_siguiente <= ESPERA;
                end if;
                
            when BLOQUEADO =>
                opCodeleds <= "000";
                enable_01 <= '0';
                enable_02 <= '0';
                enable_medio <= '0';
                enable_cred <= '0';
                estado_siguiente <= BLOQUEADO;
        end case;
        creditos <= cuenta_cred;
    end process;

end Behavioral;
