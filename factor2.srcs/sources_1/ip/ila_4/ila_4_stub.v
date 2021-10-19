// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu May  6 14:47:18 2021
// Host        : pc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/master/factor2_vhdl_test1_040521_1935/factor2_vhdl_test1.srcs/sources_1/ip/ila_4/ila_4_stub.v
// Design      : ila_4
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2020.2" *)
module ila_4(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, 
  probe18, probe19, probe20, probe21, probe22, probe23, probe24, probe25)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[3:0],probe1[0:0],probe2[0:0],probe3[7:0],probe4[7:0],probe5[0:0],probe6[0:0],probe7[7:0],probe8[3:0],probe9[0:0],probe10[7:0],probe11[7:0],probe12[1:0],probe13[0:0],probe14[7:0],probe15[7:0],probe16[0:0],probe17[0:0],probe18[0:0],probe19[7:0],probe20[7:0],probe21[0:0],probe22[0:0],probe23[0:0],probe24[0:0],probe25[31:0]" */;
  input clk;
  input [3:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [7:0]probe3;
  input [7:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [7:0]probe7;
  input [3:0]probe8;
  input [0:0]probe9;
  input [7:0]probe10;
  input [7:0]probe11;
  input [1:0]probe12;
  input [0:0]probe13;
  input [7:0]probe14;
  input [7:0]probe15;
  input [0:0]probe16;
  input [0:0]probe17;
  input [0:0]probe18;
  input [7:0]probe19;
  input [7:0]probe20;
  input [0:0]probe21;
  input [0:0]probe22;
  input [0:0]probe23;
  input [0:0]probe24;
  input [31:0]probe25;
endmodule
