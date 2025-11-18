// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Sun Dec  8 15:23:43 2024
// Host        : DESKTOP-LIPDCB0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/hlocal/RISC-V_Multiciclo_A2YModoDepuracion/RISC-V_Multiciclo_A2YModoDepuracion.gen/sources_1/ip/clk_100Mhz_to_10Mhz/clk_100Mhz_to_10Mhz_stub.v
// Design      : clk_100Mhz_to_10Mhz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_100Mhz_to_10Mhz(clk_out1, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_in1" */
/* synthesis syn_force_seq_prim="clk_out1" */;
  output clk_out1 /* synthesis syn_isclock = 1 */;
  input clk_in1;
endmodule
