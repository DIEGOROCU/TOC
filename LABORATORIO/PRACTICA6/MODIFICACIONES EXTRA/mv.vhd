--------------------------------------------------------------------------------
-- INSTRUCCIONES MOVE (MV) PARA RISC-V MULTICICLO
-- 
-- Dos variantes:
--   1) mv rd, #imm   -> rd <- SignExt(imm), PC <- PC + 4   | opcode = "0010000"
--   2) mv rd, rs1    -> rd <- rs1, PC <- PC + 4            | opcode = "0010010"
--
-- Este archivo documenta TODOS los cambios necesarios en cada archivo del proyecto.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- ██╗   ██╗███╗   ██╗██╗██████╗  █████╗ ██████╗ 
-- ██║   ██║████╗  ██║██║██╔══██╗██╔══██╗██╔══██╗
-- ██║   ██║██╔██╗ ██║██║██║  ██║███████║██║  ██║
-- ██║   ██║██║╚██╗██║██║██║  ██║██╔══██║██║  ██║
-- ╚██████╔╝██║ ╚████║██║██████╔╝██║  ██║██████╔╝
--  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝ 
--                                                
-- ARCHIVO: unidadDeControl.vhd
-- CAMBIOS NECESARIOS:
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- OPCIÓN A: Reusar estados existentes (MÁS SIMPLE, RECOMENDADA)
-- ============================================================================
-- 
-- La idea es que:
--   - mv rd, #imm es como addi rd, x0, imm  -> reutilizar S8 (tipo I) + S7
--   - mv rd, rs1  es como add rd, rs1, x0   -> reutilizar S6 (tipo R) + S7
--
-- Solo necesitamos detectar los opcodes en S1 y redirigir a los estados correctos.
--
-- En el proceso COMB, dentro de WHEN S1, añadir:
--------------------------------------------------------------------------------

entity opcionA_unidadDeControl_fragmento is
end opcionA_unidadDeControl_fragmento;

architecture ejemplo of opcionA_unidadDeControl_fragmento is
    signal AWr, BWr, ALUoutWr : std_logic;
    signal ALUop, ALUsrcA, ALUsrcB : std_logic_vector(1 downto 0);
    signal op : std_logic_vector(6 downto 0);
    type states is (S0, S1, S2, S6, S7, S8, S9, S10);
    signal nextState : states;
begin

    process_fragmento: process(op)
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
            elsif (op = "0010000") then
                nextState <= S8;
            elsif (op = "0010010") then
                nextState <= S6;
            -- ========================================================
            end if;
    end process;

end ejemplo;


--------------------------------------------------------------------------------
-- ============================================================================
-- OPCIÓN B: Crear estados nuevos dedicados (MÁS EXPLÍCITO)
-- ============================================================================
--
-- Añadir nuevos estados S11 y S12 para las instrucciones move.
-- Esto es más claro pero requiere más cambios.
--------------------------------------------------------------------------------

entity opcionB_unidadDeControl_fragmento is
end opcionB_unidadDeControl_fragmento;

architecture ejemplo of opcionB_unidadDeControl_fragmento is
    signal ALUoutWr : std_logic;
    signal ALUsrcA, ALUsrcB, ALUop : std_logic_vector(1 downto 0);
    type states is (S0, S1, S7, S11, S12);
    signal nextState : states;
begin

    -- 1) Modificar la declaración de estados:
    -- TYPE states IS (S0, S0bis, S1, S2, S3, S3bis, S4, S5, S6, S7, S8, S9, S10, S11, S12);

    -- 2) NUEVOS ESTADOS A AÑADIR EN EL CASE:

    estado_S11: process
    begin
        -- WHEN S11 =>  -- mv rd, #imm: rd <- SignExt(imm)
        -- Necesitamos pasar el inmediato extendido al banco de registros
        -- Usamos la ALU para pasar el dato: ALUout = 0 + imm
        ALUoutWr <= '1';
        ALUsrcA <= "11";
        ALUsrcB <= "01";
        ALUop <= "00";
        nextState <= S7;
        wait;
    end process;

    estado_S12: process
    begin
        -- WHEN S12 =>  -- mv rd, rs1: rd <- rs1
        -- Pasamos rs1 (que está en registro A) sumándole 0
        ALUoutWr <= '1';
        ALUsrcA <= "10";
        ALUsrcB <= "11";
        ALUop <= "00";
        nextState <= S7;
        wait;
    end process;

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
-- CAMBIOS NECESARIOS (solo si se usa OPCIÓN C):
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- OPCIÓN C: Modificar mux ResSrc para tener acceso directo al inmediato
-- ============================================================================
--
-- Actualmente el mux ResSrc tiene:
--   "00" -> ALUOut
--   "01" -> MDR
--   "10" -> salidaALU
--   "11" -> x"00000000" (no usado)
--
-- CAMBIO: Conectar el inmediato extendido a entrada3
--------------------------------------------------------------------------------

entity opcionC_rutaDeDatos_fragmento is
end opcionC_rutaDeDatos_fragmento;

architecture ejemplo of opcionC_rutaDeDatos_fragmento is
    signal ALUOut, MDR, salidaALU, signo_extendido : std_logic_vector(31 downto 0);
    signal salidaResSrc : std_logic_vector(31 downto 0);
    signal ResSrc : std_logic_vector(1 downto 0);
    
    component multiplexor4a1
        generic(bits_entradas: positive := 32);
        port(
            entrada0, entrada1, entrada2, entrada3 : in std_logic_vector(bits_entradas-1 downto 0);
            seleccion : in std_logic_vector(1 downto 0);
            salida : out std_logic_vector(bits_entradas-1 downto 0)
        );
    end component;
begin

    -- CAMBIO EN EL MUX ResSrc:
    -- Antes: entrada3 => x"00000000"
    -- Ahora: entrada3 => signo_extendido
    
    mux_ResSrc : multiplexor4a1 port map(
        entrada0  => ALUOut,
        entrada1  => MDR,
        entrada2  => salidaALU,
        entrada3  => signo_extendido,
        seleccion => ResSrc,
        salida    => salidaResSrc
    );
    
    -- Con este cambio, en la unidad de control para mv rd, #imm:
    --   ResSrc <= "11";  -- selecciona signo_extendido directamente
    --   BRWr <= '1';
    --   nextState <= S0;

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
-- CAMBIOS EN EL PROGRAMA:
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- CODIFICACIÓN DE LAS INSTRUCCIONES MOVE:
-- ============================================================================
--
-- mv rd, #imm (tipo I, opcode = 0010000):
--   | imm[11:0]  | rs1   | funct3 | rd    | opcode  |
--   | 31------20 | 19-15 | 14-12  | 11-7  | 6-----0 |
--   
--   mv x13, #0:
--   imm = 000000000000, rs1 = 00000 (x0), funct3 = 000, rd = 01101 (x13)
--   Binario: 0000_0000_0000_00000_000_01101_0010000
--   Hex: 0x00000690
--
-- mv rd, rs1 (tipo R, opcode = 0010010):
--   | funct7  | rs2   | rs1   | funct3 | rd    | opcode  |
--   | 31---25 | 24-20 | 19-15 | 14-12  | 11-7  | 6-----0 |
--   
--   mv x12, x13:
--   funct7 = 0000000, rs2 = 00000 (x0), rs1 = 01101 (x13), funct3 = 000, rd = 01100 (x12)
--   Binario: 0000000_00000_01101_000_01100_0010010
--   Hex: 0x00068612
--------------------------------------------------------------------------------

entity BlockRam_modificado is
end BlockRam_modificado;

architecture ejemplo of BlockRam_modificado is
    type ram_type is array (0 to 511) of std_logic_vector(31 downto 0);
    
    -- PROGRAMA MODIFICADO CON INSTRUCCIONES MOVE:
    signal ram : ram_type := (
        x"00000690",    -- mv x13, #0         0x00  mv a3, 0          ; a3 = 0
        x"00068612",    -- mv x12, x13        0x04  mv a2, a3         ; a2 = a3 = 0
        x"02802503",    -- lw x10, 40(x0)     0x08  lw a0, 40(zero)   ; a0 = 7
        x"02C02583",    -- lw x11, 44(x0)     0x0C  lw a1, 44(zero)   ; a1 = 3
        x"00058863",    -- beq x11, x0, 16    0x10  beq a1, zero, 16
        x"00a60633",    -- add x12, x12, x10  0x14  add a2, a2, a0
        x"fff58593",    -- addi x11, x11, -1  0x18  addi a1, a1, -1
        x"fe000ae3",    -- beq x0, x0, -12    0x1C  beq zero, zero, -12
        x"03002023",    -- sw x12, 48(x0)     0x20  sw a2, 48(zero)
        x"00000063",    -- beq x0, x0, 0      0x24  beq zero, zero, 0 (halt)
        x"00000007",    -- VALOR A            0x28  7
        x"00000003",    -- VALOR B            0x2C  3
        x"00000000",    -- Resultado          0x30
        others => x"00000000"
    );
    
    -- NOTA: Los offsets cambian porque añadimos 2 instrucciones al inicio:
    --   VALOR A: dirección 0x28 = 40 decimal
    --   VALOR B: dirección 0x2C = 44 decimal
    --   Resultado: dirección 0x30 = 48 decimal
    
begin
end ejemplo;


--------------------------------------------------------------------------------
-- ██████╗ ███████╗███████╗██╗   ██╗███╗   ███╗███████╗███╗   ██╗
-- ██╔══██╗██╔════╝██╔════╝██║   ██║████╗ ████║██╔════╝████╗  ██║
-- ██████╔╝█████╗  ███████╗██║   ██║██╔████╔██║█████╗  ██╔██╗ ██║
-- ██╔══██╗██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║
-- ██║  ██║███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗██║ ╚████║
-- ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝
--
-- RESUMEN DE IMPLEMENTACIÓN RECOMENDADA (OPCIÓN A):
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ============================================================================
-- CAMBIOS MÍNIMOS REQUERIDOS (OPCIÓN A):
-- ============================================================================
--
-- 1. En unidadDeControl.vhd, dentro de WHEN S1, añadir después de beq:
--
--        elsif (op = "0010000") then
--            nextState <= S8;
--        elsif (op = "0010010") then
--            nextState <= S6;
--
-- 2. En BlockRam.vhd, actualizar el programa con las instrucciones move.
--
-- ============================================================================
-- JUSTIFICACIÓN DE POR QUÉ FUNCIONA:
-- ============================================================================
--
-- Para mv rd, #imm (reutiliza S8):
--   - S8 hace: ALUout = A + imm con ALUop="10"
--   - Si codificamos rs1=x0 en la instrucción, entonces A=0
--   - Resultado: ALUout = 0 + imm = imm ✓
--   - S7 escribe ALUout en rd ✓
--
-- Para mv rd, rs1 (reutiliza S6):
--   - S6 hace: ALUout = A + B con ALUop="10", funct3="000", funct7_5='0'
--   - Si codificamos rs2=x0 en la instrucción, entonces B=0
--   - Resultado: ALUout = rs1 + 0 = rs1 ✓
--   - S7 escribe ALUout en rd ✓
--
-- ============================================================================
-- FIN DEL DOCUMENTO
-- ============================================================================
--------------------------------------------------------------------------------

