-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
-- Date        : Sun Dec  8 15:23:43 2024
-- Host        : DESKTOP-LIPDCB0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/hlocal/RISC-V_Multiciclo_A2YModoDepuracion/RISC-V_Multiciclo_A2YModoDepuracion.gen/sources_1/ip/clk_100Mhz_to_10Mhz/clk_100Mhz_to_10Mhz_stub.vhdl
-- Design      : clk_100Mhz_to_10Mhz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_100Mhz_to_10Mhz is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_100Mhz_to_10Mhz;

architecture stub of clk_100Mhz_to_10Mhz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
