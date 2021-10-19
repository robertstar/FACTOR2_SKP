// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Mon May  3 11:34:37 2021
// Host        : pc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/master/factor2_vhdl_test1_020521/factor2_vhdl_test1.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2020.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[7:0],probe3[0:0],probe4[0:0],probe5[11:0],probe6[0:0],probe7[11:0],probe8[0:0],probe9[4:0],probe10[7:0],probe11[0:0],probe12[0:0],probe13[7:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [7:0]probe2;
  input [0:0]probe3;
  input [0:0]probe4;
  input [11:0]probe5;
  input [0:0]probe6;
  input [11:0]probe7;
  input [0:0]probe8;
  input [4:0]probe9;
  input [7:0]probe10;
  input [0:0]probe11;
  input [0:0]probe12;
  input [7:0]probe13;
endmodule
