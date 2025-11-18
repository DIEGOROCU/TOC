set_property SRC_FILE_INFO {cfile:c:/hlocal/RISC-V_Multiciclo_A2YModoDepuracion/RISC-V_Multiciclo_A2YModoDepuracion.gen/sources_1/ip/clk_100Mhz_to_10Mhz/clk_100Mhz_to_10Mhz.xdc rfile:../../../RISC-V_Multiciclo_A2YModoDepuracion.gen/sources_1/ip/clk_100Mhz_to_10Mhz/clk_100Mhz_to_10Mhz.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
