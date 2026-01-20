# TOC: laboratorio y problemas de VHDL

Repositorio docente que recopila las practicas de laboratorio y ejercicios resueltos de Tecnica/Organizacion de Computadores. Incluye proyectos de Vivado listos para sintetizar y simular, junto con pequeños ejercicios de VHDL para afianzar logica combinacional, maquinas de estados y diseno de procesadores.

## Estructura
- LABORATORIO: practicas numeradas (PRACTICA1-6) empaquetadas como proyectos de Vivado (`*.xpr`, carpetas `*.srcs`, `*.runs`, `*.sim`).
	- PRACTICA6:RISC-V: implementacion multiciclo de un CPU RISC-V con datapath y unidad de control descritos en VHDL (`ALU.vhd`, `bancoDeRegistros.vhd`, `unidadDeControl.vhd`, `rutaDeDatos.vhd`, etc.).
	- PRACTICA6:BlockRam: variantes de memorias RAM en bloque con configuraciones y pruebas adicionales.
	- Otras practicas (1-5): contienen proyectos intermedios de logica combinacional y secuencial, controladores y memorias, listos para abrir en Vivado.
- PROBLEMAS: coleccion de ejercicios cortos de VHDL. Incluye circuitos combinacionales (p.ej. deteccion de primos y condiciones mixtas en `ej02.vhd`) y maquinas de estados sincrónicas (p.ej. `ej05.vhd`). Subcarpetas con mas componentes reusables (`MUX`, `DECO`, `comparadores`, etc.).

## Practica 6 (CPU RISC-V multiciclo)
- Top: `RISCVMulticiclo.vhd` instancia la `unidadDeControl` y la `rutaDeDatos` y enlaza un bus de control de 18 bits y un vector de estado de 12 bits.
- ALU: operaciones de suma, resta, AND, OR y comparacion signed, decodificando `ALUop`, `funct3`, `funct7` y el bit 5 del opcode. Señal `Zero` indica resultado nulo para saltos condicionales.
- Unidad de control: maquina de estados finitos que secuencia instrucciones tipo R, I, load/store, `jal` y ramas `beq`. Genera señales de escritura de PC, IR, registros A/B, MDR, fuente de direccion de memoria y muxes de ALU y resultados.
- Bloques de soporte: banco de registros, memoria de datos/instrucciones, extensores de signo, multiplexores y registros intermedios para el datapath.
- Testbench: `TestBenchRISCVMulticiclo.vhd` permite simular el conjunto completo.

## Conocimientos academicos implicados
- Lenguaje VHDL: sintaxis, concurrencia, aliasado de señales y uso de paquetes `std_logic_1164` y `numeric_std`.
- Logica combinacional: decodificadores, multiplexores, comparadores, deteccion de patrones, evaluacion de expresiones booleanas.
- Sistemas secuenciales: maquinas de estados finitos sincrónicas, registros, control de reset y sincronizacion con reloj.
- Arquitectura de computadores: ciclo de instruccion multiciclo, particion de datapath/control, especificacion RISC-V (campos `opcode`, `funct3`, `funct7`), señales de control típicas (`ALUSrc`, `MemWr`, `PCWr`, etc.).
- Memorias y perifericos: RAM en bloque, lecturas/escrituras sincronas, direccionamiento, extensor de signo.
- Flujo de herramientas EDA: uso de Vivado para sintesis, implementacion, generacion de bitstreams y simulacion basada en testbench.

## Como usar
1) Abrir el proyecto deseado en Vivado (doble clic sobre el `*.xpr` o desde Vivado con "Open Project").
2) Revisar y editar fuentes en `*.srcs/ficheros` o `ficheros/` segun la practica.
3) Simular con los bancos de pruebas incluidos (`*.sim` o ficheros `TestBench*.vhd`).
4) Ejecutar sintesis e implementacion (`Run Synthesis`, `Run Implementation`) antes de generar bitstream si se despliega en FPGA.

## Notas
- Los proyectos usan rutas relativas dentro del arbol `LABORATORIO`; manten la estructura para evitar rutas rotas en Vivado.
- El repo no incluye dependencias externas: todo el codigo HDL esta versionado en texto plano.
