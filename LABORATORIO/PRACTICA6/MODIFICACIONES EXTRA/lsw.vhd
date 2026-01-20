--------------------------------------------------------------------------------
-- INSTRUCCIÓN LSW (LOAD SWITCHES) PARA RISC-V MULTICICLO
-- 
-- Comportamiento:
--   lsw rd, #imm -> si (imm = 0): rd <- SignExt(SW[3:0]), PC <- PC + 4
--                   si (imm != 0): rd <- SignExt(SW[7:4]), PC <- PC + 4
--
-- Código de operación: "0010001"
--
-- Este archivo documenta TODOS los cambios necesarios en cada archivo del proyecto.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- ██████╗ ██╗███████╗ ██████╗██╗   ██╗███╗   ███╗██╗   ██╗██╗  ████████╗██╗ ██████╗██╗ ██████╗██╗      ██████╗ 
-- ██╔══██╗██║██╔════╝██╔════╝██║   ██║████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔════╝██║██╔════╝██║     ██╔═══██╗
-- ██████╔╝██║███████╗██║     ██║   ██║██╔████╔██║██║   ██║██║     ██║   ██║██║     ██║██║     ██║     ██║   ██║
-- ██╔══██╗██║╚════██║██║     ╚██╗ ██╔╝██║╚██╔╝██║██║   ██║██║     ██║   ██║██║     ██║██║     ██║     ██║   ██║
-- ██║  ██║██║███████║╚██████╗ ╚████╔╝ ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║╚██████╗██║╚██████╗███████╗╚██████╔╝
-- ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝  ╚═══╝  ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝ ╚═════╝╚═╝ ╚═════╝╚══════╝ ╚═════╝ 
--
-- ARCHIVO: RISCVMulticiclo.vhd (TOP LEVEL)
-- CAMBIOS NECESARIOS: Añadir puerto de entrada para los switches
--------------------------------------------------------------------------------

entity RISCVMulticiclo_modificado is
    port( 
        clk               : in  std_logic;
        rst               : in  std_logic;
        display           : out std_logic_vector(6 downto 0);
        display_enable    : out std_logic_vector(3 downto 0);
        modo              : in  std_logic;
        siguiente         : in  std_logic;
        -- ===================== NUEVO PUERTO =====================
        switches          : in  std_logic_vector(7 downto 0)  -- SW[7:0] de la placa
        -- ========================================================
    );
end RISCVMulticiclo_modificado;

architecture ejemplo of RISCVMulticiclo_modificado is
    -- Declaración del componente rutaDeDatos modificado
    component rutaDeDatos is
        port( 
            clk      : in  std_logic;
            rst      : in  std_logic;
            control  : in  std_logic_vector(17 downto 0);
            estado   : out std_logic_vector(11 downto 0);
            A2       : out std_logic_vector(31 downto 0);
            PCout    : out std_logic_vector(31 downto 0);
            -- ===================== NUEVO PUERTO =====================
            switches : in  std_logic_vector(7 downto 0)
            -- ========================================================
        );
    end component;
    
    signal control : std_logic_vector(17 downto 0);
    signal estado  : std_logic_vector(11 downto 0);
    signal A2      : std_logic_vector(31 downto 0);
    signal PC      : std_logic_vector(31 downto 0);
begin

    -- Instanciación de rutaDeDatos con el nuevo puerto switches
    RD: rutaDeDatos port map(
        clk      => clk,
        rst      => rst,
        control  => control,
        estado   => estado,
        A2       => A2,
        PCout    => PC,
        -- ===================== NUEVA CONEXIÓN =====================
        switches => switches
        -- ==========================================================
    );

end ejemplo;


--------------------------------------------------------------------------------
-- ██████╗ ██╗   ██╗████████╗ █████╗     ██████╗ ███████╗    ██████╗  █████╗ ████████╗ ██████╗ ███████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔══██╗    ██╔══██╗██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗██╔════╝
-- ██████╔╝██║   ██║   ██║   ███████║    ██║  ██║█████╗      ██║  ██║███████║   ██║   ██║   ██║███████╗
-- ██╔══██╗██║   ██║   ██║   ██╔══██║    ██║  ██║██╔══╝      ██║  ██║██╔══██║   ██║   ██║   ██║╚════██║
-- ██║  ██║╚██████╔╝   ██║   ██║  ██║    ██████╔╝███████╗    ██████╔╝██║  ██║   ██║   ╚██████╔╝███████║
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝    ╚═════╝ ╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
--
-- ARCHIVO: rutaDeDatos.vhd
-- CAMBIOS NECESARIOS: Añadir lógica para leer switches y conectar al mux ResSrc
--------------------------------------------------------------------------------

entity rutaDeDatos_modificado is
    port( 
        clk      : in  std_logic;
        rst      : in  std_logic;
        control  : in  std_logic_vector(17 downto 0);
        estado   : out std_logic_vector(11 downto 0);
        A2       : out std_logic_vector(31 downto 0);
        PCout    : out std_logic_vector(31 downto 0);
        -- ===================== NUEVO PUERTO =====================
        switches : in  std_logic_vector(7 downto 0)
        -- ========================================================
    );
end rutaDeDatos_modificado;

architecture ejemplo of rutaDeDatos_modificado is
    
    -- Señales existentes (simplificadas para el ejemplo)
    signal IR                : std_logic_vector(31 downto 0);
    signal ALUOut            : std_logic_vector(31 downto 0);
    signal MDR               : std_logic_vector(31 downto 0);
    signal salidaALU         : std_logic_vector(31 downto 0);
    signal salidaResSrc      : std_logic_vector(31 downto 0);
    signal ResSrc            : std_logic_vector(1 downto 0);
    
    -- ===================== NUEVAS SEÑALES =====================
    signal sw_seleccionados  : std_logic_vector(3 downto 0);
    signal sw_sign_extended  : std_logic_vector(31 downto 0);
    -- ==========================================================
    
    component multiplexor4a1
        generic(bits_entradas: positive := 32);
        port(
            entrada0, entrada1, entrada2, entrada3 : in std_logic_vector(bits_entradas-1 downto 0);
            seleccion : in std_logic_vector(1 downto 0);
            salida : out std_logic_vector(bits_entradas-1 downto 0)
        );
    end component;
    
begin

    -- =========================================================================
    -- NUEVA LÓGICA PARA LSW:
    -- =========================================================================
    
    -- 1. Selección de switches según IR(20) (bit 0 del inmediato tipo I)
    --    IR(20) = '0' -> imm = 0 -> usar SW[3:0]
    --    IR(20) = '1' -> imm != 0 -> usar SW[7:4]
    sw_seleccionados <= switches(3 downto 0) when IR(20) = '0' else
                        switches(7 downto 4);
    
    -- 2. Extensión de signo de 4 bits a 32 bits
    --    El bit más significativo (sw_seleccionados(3)) se replica en los bits superiores
    sw_sign_extended <= (31 downto 4 => sw_seleccionados(3)) & sw_seleccionados;
    
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
    --   entrada3 => sw_sign_extended  (NUEVO: switches extendidos)
    
    mux_ResSrc : multiplexor4a1 port map(
        entrada0  => ALUOut,
        entrada1  => MDR,
        entrada2  => salidaALU,
        entrada3  => sw_sign_extended,  -- CAMBIO: antes era x"00000000"
        seleccion => ResSrc,
        salida    => salidaResSrc
    );

end ejemplo;


--------------------------------------------------------------------------------
-- ██╗   ██╗███╗   ██╗██╗██████╗  █████╗ ██████╗ 
-- ██║   ██║████╗  ██║██║██╔══██╗██╔══██╗██╔══██╗
-- ██║   ██║██╔██╗ ██║██║██║  ██║███████║██║  ██║
-- ██║   ██║██║╚██╗██║██║██║  ██║██╔══██║██║  ██║
-- ╚██████╔╝██║ ╚████║██║██████╔╝██║  ██║██████╔╝
--  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝ 
--                                                
-- ARCHIVO: unidadDeControl.vhd
-- CAMBIOS NECESARIOS: Añadir detección de opcode y nuevo estado
--------------------------------------------------------------------------------

entity unidadDeControl_modificado is
end unidadDeControl_modificado;

architecture ejemplo of unidadDeControl_modificado is
    signal AWr, BWr, ALUoutWr, BRWr : std_logic;
    signal ALUop, ALUsrcA, ALUsrcB, ResSrc : std_logic_vector(1 downto 0);
    signal op : std_logic_vector(6 downto 0);
    
    -- ===================== NUEVO ESTADO =====================
    type states is (S0, S0bis, S1, S2, S3, S3bis, S4, S5, S6, S7, S8, S9, S10, S_LSW);
    -- ========================================================
    
    signal currentState, nextState : states;
begin

    -- =========================================================================
    -- MODIFICACIÓN EN S1: Detectar opcode de LSW
    -- =========================================================================
    
    proceso_S1: process(op)
    begin
        -- WHEN S1 =>
            AWr <= '1';
            BWr <= '1';
            ALUop <= "00";
            ALUsrcA <= "01";
            ALUsrcB <= "01";
            ALUoutWr <= '1';
            
            if (op = "0000011" or op = "0100011") then
                nextState <= S2;
            elsif (op = "0010011") then
                nextState <= S8;
            elsif (op = "0110011") then
                nextState <= S6;
            elsif (op = "1101111") then
                nextState <= S9;
            elsif (op = "1100011") then
                nextState <= S10;
            -- ===================== NUEVO CÓDIGO =====================
            elsif (op = "0010001") then  -- lsw rd, #imm
                nextState <= S_LSW;
            -- ========================================================
            end if;
    end process;
    
    -- =========================================================================
    -- NUEVO ESTADO S_LSW: Escribir switches en registro destino
    -- =========================================================================
    
    proceso_S_LSW: process
    begin
        -- WHEN S_LSW =>
        --   La selección de SW[3:0] o SW[7:4] se hace automáticamente
        --   en el datapath según IR(20).
        --   Solo necesitamos:
        --   1. Seleccionar sw_sign_extended como entrada al banco de registros
        --   2. Habilitar escritura en el banco de registros
        
        ResSrc <= "11";  -- Selecciona entrada3 del mux = sw_sign_extended
        BRWr <= '1';     -- Habilita escritura en banco de registros
        nextState <= S0; -- Volver a fetch
        wait;
    end process;

end ejemplo;


--------------------------------------------------------------------------------
-- ██████╗ ██╗      ██████╗  ██████╗██╗  ██╗██████╗  █████╗ ███╗   ███╗
-- ██╔══██╗██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔══██╗██╔══██╗████╗ ████║
-- ██████╔╝██║     ██║   ██║██║     █████╔╝ ██████╔╝███████║██╔████╔██║
-- ██╔══██╗██║     ██║   ██║██║     ██╔═██╗ ██╔══██╗██╔══██║██║╚██╔╝██║
-- ██████╔╝███████╗╚██████╔╝╚██████╗██║  ██╗██║  ██║██║  ██║██║ ╚═╝ ██║
-- ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
--
-- ARCHIVO: BlockRam.vhd
-- CAMBIOS EN EL PROGRAMA: Usar LSW en lugar de LW para leer operandos
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- CODIFICACIÓN DE LA INSTRUCCIÓN LSW:
-- ============================================================================
--
-- lsw rd, #imm (tipo I, opcode = 0010001):
--   | imm[11:0]  | rs1   | funct3 | rd    | opcode  |
--   | 31------20 | 19-15 | 14-12  | 11-7  | 6-----0 |
--   
-- lsw x10, #0 (leer SW[3:0] en a0):
--   imm = 000000000000, rs1 = 00000 (ignorado), funct3 = 000, rd = 01010 (x10)
--   Binario: 0000_0000_0000_00000_000_01010_0010001
--   Hex: 0x00000511
--
-- lsw x11, #1 (leer SW[7:4] en a1):
--   imm = 000000000001, rs1 = 00000 (ignorado), funct3 = 000, rd = 01011 (x11)
--   Binario: 0000_0000_0001_00000_000_01011_0010001
--   Hex: 0x00100591
--------------------------------------------------------------------------------

entity BlockRam_modificado is
end BlockRam_modificado;

architecture ejemplo of BlockRam_modificado is
    type ram_type is array (0 to 511) of std_logic_vector(31 downto 0);
    
    -- PROGRAMA MODIFICADO CON INSTRUCCIÓN LSW:
    -- Lee los operandos desde los switches de la placa en lugar de memoria
    signal ram : ram_type := (
        x"00067613",    -- andi x12, x12, 0   0x00  andi a2, a2, 0    ; a2 = 0 (acumulador)
        x"00000511",    -- lsw x10, #0        0x04  lsw a0, 0         ; a0 = SignExt(SW[3:0])
        x"00100591",    -- lsw x11, #1        0x08  lsw a1, 1         ; a1 = SignExt(SW[7:4])
        x"00058863",    -- beq x11, x0, 16    0x0C  beq a1, zero, 16  ; si a1=0, saltar bucle
        x"00a60633",    -- add x12, x12, x10  0x10  add a2, a2, a0    ; a2 += a0
        x"fff58593",    -- addi x11, x11, -1  0x14  addi a1, a1, -1   ; a1 -= 1
        x"fe000ae3",    -- beq x0, x0, -12    0x18  beq zero,zero,-12 ; volver al bucle
        x"02c02023",    -- sw x12, 32(x0)     0x1C  sw a2, 32(zero)   ; guardar resultado
        x"00000063",    -- beq x0, x0, 0      0x20  beq zero,zero,0   ; halt
        x"00000000",    -- Resultado          0x24
        others => x"00000000"
    );
    
    -- EJEMPLO DE EJECUCIÓN:
    --   Si SW[3:0] = 0111 (7) y SW[7:4] = 0011 (3):
    --   - a0 = 7
    --   - a1 = 3  
    --   - El bucle calcula a2 = 7 + 7 + 7 = 21 (7 * 3)
    --   - El display mostrará 0x15 = 21
    
begin
end ejemplo;


--------------------------------------------------------------------------------
-- ██████╗ ██████╗ ███╗   ██╗███████╗████████╗██████╗  █████╗ ██╗███╗   ██╗████████╗███████╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║╚══██╔══╝██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║███████╗   ██║   ██████╔╝███████║██║██╔██╗ ██║   ██║   ███████╗
-- ██║     ██║   ██║██║╚██╗██║╚════██║   ██║   ██╔══██╗██╔══██║██║██║╚██╗██║   ██║   ╚════██║
-- ╚██████╗╚██████╔╝██║ ╚████║███████║   ██║   ██║  ██║██║  ██║██║██║ ╚████║   ██║   ███████║
-- ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
--
-- ARCHIVO: constraints (.xdc)
-- CAMBIOS NECESARIOS: Mapear switches de la placa Basys3
--------------------------------------------------------------------------------

-- En el archivo de constraints (Basys3_Master.xdc), asegurarse de que los
-- switches estén mapeados correctamente:
--
-- ## Switches
-- set_property PACKAGE_PIN V17 [get_ports {switches[0]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
-- set_property PACKAGE_PIN V16 [get_ports {switches[1]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
-- set_property PACKAGE_PIN W16 [get_ports {switches[2]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
-- set_property PACKAGE_PIN W17 [get_ports {switches[3]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]
-- set_property PACKAGE_PIN W15 [get_ports {switches[4]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]
-- set_property PACKAGE_PIN V15 [get_ports {switches[5]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[5]}]
-- set_property PACKAGE_PIN W14 [get_ports {switches[6]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[6]}]
-- set_property PACKAGE_PIN W13 [get_ports {switches[7]}]
-- set_property IOSTANDARD LVCMOS33 [get_ports {switches[7]}]


--------------------------------------------------------------------------------
-- ██████╗ ███████╗███████╗██╗   ██╗███╗   ███╗███████╗███╗   ██╗
-- ██╔══██╗██╔════╝██╔════╝██║   ██║████╗ ████║██╔════╝████╗  ██║
-- ██████╔╝█████╗  ███████╗██║   ██║██╔████╔██║█████╗  ██╔██╗ ██║
-- ██╔══██╗██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║
-- ██║  ██║███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗██║ ╚████║
-- ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝
--
-- RESUMEN DE CAMBIOS REQUERIDOS:
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- LISTA DE ARCHIVOS A MODIFICAR:
-- ============================================================================
--
-- 1. RISCVMulticiclo.vhd (top level):
--    - Añadir puerto: switches : in std_logic_vector(7 downto 0)
--    - Propagar el puerto a rutaDeDatos
--
-- 2. rutaDeDatos.vhd:
--    - Añadir puerto: switches : in std_logic_vector(7 downto 0)
--    - Añadir señales: sw_seleccionados, sw_sign_extended
--    - Añadir lógica de selección según IR(20)
--    - Modificar mux_ResSrc: entrada3 => sw_sign_extended
--
-- 3. unidadDeControl.vhd:
--    - Añadir estado S_LSW al tipo states
--    - En S1: añadir elsif (op = "0010001") then nextState <= S_LSW;
--    - Añadir caso WHEN S_LSW con ResSrc <= "11"; BRWr <= '1';
--
-- 4. BlockRam.vhd:
--    - Modificar programa para usar lsw en lugar de lw
--
-- 5. Constraints (.xdc):
--    - Verificar mapeo de switches SW[7:0]
--
-- ============================================================================
-- CODIFICACIÓN DE INSTRUCCIONES LSW:
-- ============================================================================
--
-- | Instrucción     | Hex        | Descripción              |
-- |-----------------|------------|--------------------------|
-- | lsw x10, #0     | 0x00000511 | a0 = SignExt(SW[3:0])    |
-- | lsw x11, #1     | 0x00100591 | a1 = SignExt(SW[7:4])    |
--
-- ============================================================================
-- FLUJO DE EJECUCIÓN DE LSW:
-- ============================================================================
--
-- S0     → Fetch: PC+4, leer instrucción
-- S0bis  → IRWr: guardar instrucción en IR
-- S1     → Decode: detectar op="0010001" → ir a S_LSW
-- S_LSW  → ResSrc="11" selecciona sw_sign_extended
--          BRWr='1' escribe en rd
--          → volver a S0
--
-- Total: 4 ciclos por instrucción lsw
--
-- ============================================================================
-- FIN DEL DOCUMENTO
-- ============================================================================
--------------------------------------------------------------------------------

