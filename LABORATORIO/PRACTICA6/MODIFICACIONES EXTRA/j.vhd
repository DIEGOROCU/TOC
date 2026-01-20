-- =============================================================================
-- INSTRUCCIÓN J (JUMP INCONDICIONAL) PARA RISC-V MULTICICLO
-- =============================================================================
-- 
-- Comportamiento:
--   j dir -> PC <- "00000000000" & imm[20:0]
--            (Los 11 bits superiores son 0, los 21 bits inferiores son el inmediato)
--
-- Código de operación: "0000010"
--
-- Este archivo documenta TODOS los cambios necesarios en cada archivo del proyecto.
-- =============================================================================

library IEEE;
use IEEE.std_logic_1164.all;

-- =============================================================================
--  _   _ _   _ ___ ____    _    ____  ____  _____    ____ ___  _   _ _____ ____   ___  _     
-- | | | | \ | |_ _|  _ \  / \  |  _ \|  _ \| ____|  / ___/ _ \| \ | |_   _|  _ \ / _ \| |    
-- | | | |  \| || || | | |/ _ \ | | | | | | |  _|   | |  | | | |  \| | | | | |_) | | | | |    
-- | |_| | |\  || || |_| / ___ \| |_| | |_| | |___  | |__| |_| | |\  | | | |  _ <| |_| | |___ 
--  \___/|_| \_|___|____/_/   \_\____/|____/|_____|  \____\___/|_| \_| |_| |_| \_\\___/|_____|
--
-- ARCHIVO: unidadDeControl.vhd
-- CAMBIOS NECESARIOS: Añadir detección de opcode y nuevo estado
-- =============================================================================

entity unidadDeControl_J is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;
        estado   : in  std_logic_vector(11 downto 0);
        control  : out std_logic_vector(17 downto 0)
    );
end unidadDeControl_J;

architecture behavioral of unidadDeControl_J is

    -- ===================== NUEVO ESTADO =====================
    type states is (S0, S0bis, S1, S2, S3, S3bis, S4, S5, S6, S7, S8, S9, S10, S_JUMP);
    -- ========================================================
    
    signal currentState, nextState : states;
    
    -- Señales de control
    signal PCWr, AddrSrc, MemWr, IRWr, BRWr : std_logic;
    signal AWr, BWr, ALUoutWr               : std_logic;
    signal ALUsrcA                          : std_logic_vector(1 downto 0);
    signal ALUsrcB                          : std_logic_vector(1 downto 0);
    signal ALUop                            : std_logic_vector(1 downto 0);
    signal ResSrc                           : std_logic_vector(1 downto 0);
    
    -- Extraer campos del estado
    signal Zero     : std_logic;
    signal op       : std_logic_vector(6 downto 0);
    signal funct7_5 : std_logic;
    signal funct3   : std_logic_vector(2 downto 0);

begin

    -- Extraer campos
    Zero     <= estado(11);
    op       <= estado(10 downto 4);
    funct7_5 <= estado(3);
    funct3   <= estado(2 downto 0);

    -- =========================================================================
    -- PROCESO DE TRANSICIÓN DE ESTADOS
    -- =========================================================================
    process(currentState, op, Zero, funct3, funct7_5)
    begin
        -- Valores por defecto
        PCWr     <= '0';
        AddrSrc  <= '0';
        MemWr    <= '0';
        IRWr     <= '0';
        BRWr     <= '0';
        AWr      <= '0';
        BWr      <= '0';
        ALUoutWr <= '0';
        ALUsrcA  <= "00";
        ALUsrcB  <= "00";
        ALUop    <= "00";
        ResSrc   <= "00";
        nextState <= S0;
        
        case currentState is
            when S0 =>
                -- Fetch: PC+4, leer memoria
                AddrSrc  <= '0';
                ALUsrcA  <= "00";
                ALUsrcB  <= "10";
                ALUop    <= "00";
                ALUoutWr <= '1';
                PCWr     <= '1';
                nextState <= S0bis;
                
            when S0bis =>
                -- Guardar instrucción en IR
                IRWr <= '1';
                nextState <= S1;
                
            when S1 =>
                -- Decode: leer registros, calcular dirección
                AWr      <= '1';
                BWr      <= '1';
                ALUop    <= "00";
                ALUsrcA  <= "01";
                ALUsrcB  <= "01";
                ALUoutWr <= '1';
                
                if (op = "0000011" or op = "0100011") then
                    nextState <= S2;         -- Load/Store
                elsif (op = "0010011") then
                    nextState <= S8;         -- ADDI, ANDI, etc.
                elsif (op = "0110011") then
                    nextState <= S6;         -- ADD, SUB, etc.
                elsif (op = "1101111") then
                    nextState <= S9;         -- JAL
                elsif (op = "1100011") then
                    nextState <= S10;        -- BEQ
                -- ===================== NUEVO CÓDIGO =====================
                elsif (op = "0000010") then
                    nextState <= S_JUMP;     -- j dir (jump incondicional)
                -- ========================================================
                else
                    nextState <= S0;
                end if;
                
            -- ... (otros estados S2-S10 sin cambios) ...
            
            -- =========================================================================
            -- NUEVO ESTADO S_JUMP: Cargar dirección absoluta en PC
            -- =========================================================================
            when S_JUMP =>
                -- PC <- "00000000000" & IR[31:11]
                -- El inmediato de 21 bits se concatena con 11 ceros superiores.
                -- Esto se hace en el datapath usando entrada3 del mux ResSrc.
                
                PCWr     <= '1';     -- Habilita escritura en PC
                ResSrc   <= "11";    -- Selecciona jump_address (entrada3 del mux)
                nextState <= S0;     -- Volver a fetch
                
            when others =>
                nextState <= S0;
        end case;
    end process;

    -- Registro de estado
    process(clk, reset)
    begin
        if reset = '1' then
            currentState <= S0;
        elsif rising_edge(clk) then
            currentState <= nextState;
        end if;
    end process;

    -- Concatenar señales de control
    control <= PCWr & AddrSrc & MemWr & IRWr & BRWr & AWr & BWr & ALUoutWr &
               ALUsrcA & ALUsrcB & ALUop & ResSrc;

end behavioral;


-- =============================================================================
--  ____  _   _ _____  _      ____  _____   ____    _  _____ ___  ____  
-- |  _ \| | | |_   _|/ \    |  _ \| ____| |  _ \  / \|_   _/ _ \/ ___| 
-- | |_) | | | | | | / _ \   | | | |  _|   | | | |/ _ \ | || | | \___ \ 
-- |  _ <| |_| | | |/ ___ \  | |_| | |___  | |_| / ___ \| || |_| |___) |
-- |_| \_\\___/  |_/_/   \_\ |____/|_____| |____/_/   \_\_| \___/|____/ 
--
-- ARCHIVO: rutaDeDatos.vhd
-- CAMBIOS NECESARIOS: Añadir lógica para construir dirección de salto absoluto
-- =============================================================================

entity rutaDeDatos_J is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        control : in  std_logic_vector(17 downto 0);
        estado  : out std_logic_vector(11 downto 0)
    );
end rutaDeDatos_J;

architecture behavioral of rutaDeDatos_J is
    
    -- Señales existentes
    signal IR                : std_logic_vector(31 downto 0);
    signal ALUOut            : std_logic_vector(31 downto 0);
    signal MDR               : std_logic_vector(31 downto 0);
    signal salidaALU         : std_logic_vector(31 downto 0);
    signal salidaResSrc      : std_logic_vector(31 downto 0);
    signal ResSrc            : std_logic_vector(1 downto 0);
    
    -- ===================== NUEVA SEÑAL =====================
    signal jump_address      : std_logic_vector(31 downto 0);
    -- =======================================================
    
    component multiplexor4a1
        generic(bits_entradas: positive := 32);
        port(
            entrada0, entrada1, entrada2, entrada3 : in std_logic_vector(bits_entradas-1 downto 0);
            seleccion : in std_logic_vector(1 downto 0);
            salida    : out std_logic_vector(bits_entradas-1 downto 0)
        );
    end component;
    
begin

    -- =========================================================================
    -- NUEVA LÓGICA PARA JUMP:
    -- =========================================================================
    
    -- Construir dirección de salto absoluto:
    -- PC <- "00000000000" & imm[20:0]
    -- 
    -- El inmediato de 21 bits viene de IR[31:11] (bits superiores de la instrucción)
    -- Los 11 bits superiores del PC serán siempre 0
    --
    -- NOTA: El formato exacto del inmediato depende de cómo se codifique la instrucción.
    -- Aquí asumimos que imm[20:0] está en IR[31:11].
    
    jump_address <= "00000000000" & IR(31 downto 11);
    
    -- =========================================================================
    -- MODIFICACIÓN DEL MUX ResSrc:
    -- =========================================================================
    -- Antes:
    --   entrada0 => ALUOut
    --   entrada1 => MDR  
    --   entrada2 => salidaALU
    --   entrada3 => x"00000000"  (no usado)
    --
    -- Ahora:
    --   entrada0 => ALUOut
    --   entrada1 => MDR
    --   entrada2 => salidaALU
    --   entrada3 => jump_address  (NUEVO: dirección de salto absoluto)
    
    mux_ResSrc : multiplexor4a1 port map(
        entrada0  => ALUOut,
        entrada1  => MDR,
        entrada2  => salidaALU,
        entrada3  => jump_address,  -- CAMBIO: dirección de salto absoluto
        seleccion => ResSrc,
        salida    => salidaResSrc
    );

end behavioral;


-- =============================================================================
--  ____  _     ___   ____ _  ______      _    __  __ 
-- | __ )| |   / _ \ / ___| |/ /  _ \    / \  |  \/  |
-- |  _ \| |  | | | | |   | ' /| |_) |  / _ \ | |\/| |
-- | |_) | |__| |_| | |___| . \|  _ <  / ___ \| |  | |
-- |____/|_____\___/ \____|_|\_\_| \_\/_/   \_\_|  |_|
--
-- ARCHIVO: BlockRam.vhd
-- CAMBIOS EN EL PROGRAMA: Usar J en lugar de BEQ para saltos incondicionales
-- =============================================================================

-- =============================================================================
-- CODIFICACIÓN DE LA INSTRUCCIÓN J:
-- =============================================================================
--
-- j dir (opcode = 0000010):
--   El formato usa el inmediato en los bits superiores:
--   
--   | imm[20:0]      | xxxx   | opcode  |
--   | 31-----------11| 10---7 | 6-----0 |
--   
--   Los bits 10:7 se ignoran (pueden ser 0000).
--
-- EJEMPLOS DE CODIFICACIÓN:
--
--   j 0x0C (saltar a dirección 12):
--     imm[20:0] = 12 = 0x0C = 0b0_0000_0000_0000_0000_1100
--     IR[31:11] = 0_0000_0000_0000_0000_1100
--     IR[10:7]  = 0000
--     IR[6:0]   = 0000010
--     Completo: 0000_0000_0000_0000_0110_0000_0000_0010 = 0x00006002
--
--   j 0x18 (saltar a dirección 24):
--     imm[20:0] = 24 = 0x18 = 0b0_0000_0000_0000_0001_1000
--     IR[31:11] = 0_0000_0000_0000_0001_1000
--     Completo: 0000_0000_0000_0000_1100_0000_0000_0010 = 0x0000C002
-- =============================================================================

entity BlockRam_J is
    port(
        clk     : in  std_logic;
        addr    : in  std_logic_vector(8 downto 0);
        dataIn  : in  std_logic_vector(31 downto 0);
        dataOut : out std_logic_vector(31 downto 0);
        we      : in  std_logic
    );
end BlockRam_J;

architecture behavioral of BlockRam_J is
    type ram_type is array (0 to 511) of std_logic_vector(31 downto 0);
    
    -- PROGRAMA MODIFICADO CON INSTRUCCIÓN J:
    -- Reemplaza "beq x0, x0, offset" por "j dir" para saltos incondicionales
    signal ram : ram_type := (
        x"00067613",    -- 0x00: andi x12, x12, 0    ; a2 = 0 (acumulador)
        x"02402503",    -- 0x04: lw x10, 36(x0)      ; a0 = Mem[36] = 7
        x"02802583",    -- 0x08: lw x11, 40(x0)      ; a1 = Mem[40] = 3
        x"00058863",    -- 0x0C: beq x11, x0, 16     ; si a1=0, saltar a 0x1C
        x"00a60633",    -- 0x10: add x12, x12, x10   ; a2 += a0
        x"fff58593",    -- 0x14: addi x11, x11, -1   ; a1 -= 1
        x"00006002",    -- 0x18: j 0x0C              ; volver al test (CAMBIO!)
        x"02c02623",    -- 0x1C: sw x12, 44(x0)      ; Mem[44] = a2 (resultado)
        x"00010002",    -- 0x20: j 0x20              ; halt con j (CAMBIO!)
        x"00000007",    -- 0x24: VALOR A = 7
        x"00000003",    -- 0x28: VALOR B = 3
        x"00000000",    -- 0x2C: Resultado (7*3 = 21)
        others => x"00000000"
    );
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(unsigned(addr))) <= dataIn;
            end if;
            dataOut <= ram(to_integer(unsigned(addr)));
        end if;
    end process;
end behavioral;


-- =============================================================================
--  ____  _____ ____  _   _ __  __ _____ _   _ 
-- |  _ \| ____/ ___|| | | |  \/  | ____| \ | |
-- | |_) |  _| \___ \| | | | |\/| |  _| |  \| |
-- |  _ <| |___ ___) | |_| | |  | | |___| |\  |
-- |_| \_\_____|____/ \___/|_|  |_|_____|_| \_|
--
-- RESUMEN DE CAMBIOS REQUERIDOS:
-- =============================================================================

-- =============================================================================
-- LISTA DE ARCHIVOS A MODIFICAR:
-- =============================================================================
--
-- 1. unidadDeControl.vhd:
--    - Añadir estado S_JUMP al tipo states
--    - En S1: añadir elsif (op = "0000010") then nextState <= S_JUMP;
--    - Añadir caso:
--        WHEN S_JUMP =>
--            PCWr <= '1';
--            ResSrc <= "11";
--            nextState <= S0;
--
-- 2. rutaDeDatos.vhd:
--    - Añadir señal: jump_address
--    - Añadir lógica: jump_address <= "00000000000" & IR(31 downto 11);
--    - Modificar mux_ResSrc: entrada3 => jump_address
--
-- 3. BlockRam.vhd:
--    - Reemplazar "beq x0, x0, offset" por "j dir" donde corresponda
--
-- =============================================================================
-- FLUJO DE EJECUCIÓN DE J:
-- =============================================================================
--
-- S0     → Fetch: PC+4, leer instrucción
-- S0bis  → IRWr: guardar instrucción en IR
-- S1     → Decode: detectar op="0000010" → ir a S_JUMP
-- S_JUMP → PCWr='1', ResSrc="11" selecciona jump_address
--          PC <- "00000000000" & IR[31:11]
--          → volver a S0
--
-- Total: 4 ciclos por instrucción j
--
-- =============================================================================
-- COMPARACIÓN J vs BEQ (branch always):
-- =============================================================================
--
-- | Instrucción      | Ciclos | Uso                          |
-- |------------------|--------|------------------------------|
-- | beq x0, x0, off  | 4      | Salto relativo al PC         |
-- | j dir            | 4      | Salto absoluto a dirección   |
--
-- Ventaja de J: La dirección es absoluta, no relativa.
--               No requiere calcular offset.
--
-- =============================================================================
-- TABLA DE CODIFICACIÓN DE INSTRUCCIONES J:
-- =============================================================================
--
-- | Dirección | Instrucción hex | Descripción        |
-- |-----------|-----------------|---------------------|
-- | j 0x00    | 0x00000002      | Saltar a 0x00      |
-- | j 0x04    | 0x00002002      | Saltar a 0x04      |
-- | j 0x08    | 0x00004002      | Saltar a 0x08      |
-- | j 0x0C    | 0x00006002      | Saltar a 0x0C      |
-- | j 0x10    | 0x00008002      | Saltar a 0x10      |
-- | j 0x14    | 0x0000A002      | Saltar a 0x14      |
-- | j 0x18    | 0x0000C002      | Saltar a 0x18      |
-- | j 0x1C    | 0x0000E002      | Saltar a 0x1C      |
-- | j 0x20    | 0x00010002      | Saltar a 0x20      |
--
-- =============================================================================
-- FIN DEL DOCUMENTO
-- =============================================================================

