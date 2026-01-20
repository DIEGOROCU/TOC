## =============================================================================
## ARCHIVO DE CONSTRAINTS PARA BASYS3 - RISC-V MULTICICLO CON MODIFICACIONES
## =============================================================================
## Incluye:
##   - Switches SW[7:0] para instrucción LSW
##   - Display 7 segmentos
##   - Botones (reset, siguiente)
##   - Señal modo (SW15)
## =============================================================================

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
## =============================================================================
## Switches - SW[7:0] para instrucción LSW (lectura de switches)
## =============================================================================
## LSW usa:
##   - SW[3:0] cuando imm=0 (IR(20)='0')
##   - SW[7:4] cuando imm=1 (IR(20)='1')
## =============================================================================
set_property PACKAGE_PIN V17 [get_ports {switches[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}]
set_property PACKAGE_PIN V16 [get_ports {switches[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}]
set_property PACKAGE_PIN W16 [get_ports {switches[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
set_property PACKAGE_PIN W17 [get_ports {switches[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}]
set_property PACKAGE_PIN W15 [get_ports {switches[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[4]}]
set_property PACKAGE_PIN V15 [get_ports {switches[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[5]}]
set_property PACKAGE_PIN W14 [get_ports {switches[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[6]}]
set_property PACKAGE_PIN W13 [get_ports {switches[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switches[7]}]

## SW[8:14] - No usados actualmente (comentados)
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]

## SW15 - Señal modo (para selección de modo de operación)
set_property PACKAGE_PIN R2 [get_ports {modo}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {modo}]
 

## =============================================================================
## LEDs - No usados actualmente (comentados)
## =============================================================================
#set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
#set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
#set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
#set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
#set_property PACKAGE_PIN U14 [get_ports {led[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
#set_property PACKAGE_PIN V14 [get_ports {led[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
#set_property PACKAGE_PIN V13 [get_ports {led[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
#set_property PACKAGE_PIN V3 [get_ports {led[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
#set_property PACKAGE_PIN W3 [get_ports {led[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
#set_property PACKAGE_PIN U3 [get_ports {led[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
#set_property PACKAGE_PIN P3 [get_ports {led[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
#set_property PACKAGE_PIN N3 [get_ports {led[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
#set_property PACKAGE_PIN P1 [get_ports {led[14]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
#set_property PACKAGE_PIN L1 [get_ports {led[15]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
	
	
## =============================================================================
## 7 Segment Display - Para mostrar resultados
## =============================================================================
## display[6:0] = {g, f, e, d, c, b, a} (segmentos)
## display_enable[3:0] = ánodos (activo bajo)
## =============================================================================
set_property PACKAGE_PIN W7 [get_ports {display[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[0]}]
set_property PACKAGE_PIN W6 [get_ports {display[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[1]}]
set_property PACKAGE_PIN U8 [get_ports {display[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[2]}]
set_property PACKAGE_PIN V8 [get_ports {display[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[3]}]
set_property PACKAGE_PIN U5 [get_ports {display[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[4]}]
set_property PACKAGE_PIN V5 [get_ports {display[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[5]}]
set_property PACKAGE_PIN U7 [get_ports {display[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display[6]}]

## Punto decimal (no usado)
#set_property PACKAGE_PIN V7 [get_ports dp]							
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]

## Habilitación de dígitos (ánodos, activo bajo)
set_property PACKAGE_PIN U2 [get_ports {display_enable[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display_enable[0]}]
set_property PACKAGE_PIN U4 [get_ports {display_enable[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display_enable[1]}]
set_property PACKAGE_PIN V4 [get_ports {display_enable[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display_enable[2]}]
set_property PACKAGE_PIN W4 [get_ports {display_enable[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {display_enable[3]}]


## =============================================================================
## Buttons
## =============================================================================
## siguiente (btnC) - Avanzar ciclo en modo paso a paso
## rst (btnL) - Reset del sistema
## =============================================================================
set_property PACKAGE_PIN U18 [get_ports siguiente]						
	set_property IOSTANDARD LVCMOS33 [get_ports siguiente]
#set_property PACKAGE_PIN T18 [get_ports btnU]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnU]
set_property PACKAGE_PIN W19 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]
#set_property PACKAGE_PIN T17 [get_ports btnR]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnR]
#set_property PACKAGE_PIN U17 [get_ports btnD]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]


## =============================================================================
## RESUMEN DE PUERTOS ACTIVOS:
## =============================================================================
## ENTRADAS:
##   - clk              : Reloj del sistema (100 MHz)
##   - rst              : Reset (btnL)
##   - siguiente        : Avanzar ciclo (btnC)
##   - modo             : Selección de modo (SW15)
##   - switches[7:0]    : Switches para instrucción LSW
##
## SALIDAS:
##   - display[6:0]     : Segmentos del display 7 segmentos
##   - display_enable[3:0] : Habilitación de dígitos
##
## =============================================================================
## CONEXIÓN CON INSTRUCCIONES PERSONALIZADAS:
## =============================================================================
## 
## LSW (Load from Switches):
##   - lsw rd, #0  -> Lee switches[3:0] (SW3-SW0)
##   - lsw rd, #1  -> Lee switches[7:4] (SW7-SW4)
##   - El valor se extiende con signo a 32 bits
##
## MV (Move):
##   - mv rd, #imm -> Carga inmediato en rd
##   - mv rd, rs1  -> Copia rs1 a rd
##
## J (Jump):
##   - j dir       -> PC <- "00000000000" & imm[20:0]
##
## =============================================================================
