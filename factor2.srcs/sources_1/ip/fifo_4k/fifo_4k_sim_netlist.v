// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Mon Apr 19 08:33:30 2021
// Host        : pc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/vladimir/Downloads/factor2_vhdl_test1_190421/factor2_vhdl_test1.srcs/sources_1/ip/fifo_4k/fifo_4k_sim_netlist.v
// Design      : fifo_4k
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tfgg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fifo_4k,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module fifo_4k
   (wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    rd_data_count);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [9:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [9:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output [11:0]rd_data_count;

  wire [9:0]din;
  wire [9:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire [11:0]rd_data_count;
  wire rd_en;
  wire wr_clk;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [11:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [11:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "12" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "10" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "10" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "1" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "2" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "4kx9" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "4093" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "4092" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "12" *) 
  (* C_RD_DEPTH = "4096" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "12" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "12" *) 
  (* C_WR_DEPTH = "4096" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "12" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  fifo_4k_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[11:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(rd_data_count),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[11:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "12" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module fifo_4k_xpm_cdc_gray
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [11:0]src_in_bin;
  input dest_clk;
  output [11:0]dest_out_bin;

  wire [11:0]async_path;
  wire [10:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [11:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [11:0]\dest_graysync_ff[1] ;
  wire [11:0]dest_out_bin;
  wire [10:0]gray_enc;
  wire src_clk;
  wire [11:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[10]),
        .Q(\dest_graysync_ff[0] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[11]),
        .Q(\dest_graysync_ff[0] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[6]),
        .Q(\dest_graysync_ff[0] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[7]),
        .Q(\dest_graysync_ff[0] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[8]),
        .Q(\dest_graysync_ff[0] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[9]),
        .Q(\dest_graysync_ff[0] [9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [10]),
        .Q(\dest_graysync_ff[1] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [11]),
        .Q(\dest_graysync_ff[1] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [6]),
        .Q(\dest_graysync_ff[1] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [7]),
        .Q(\dest_graysync_ff[1] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [8]),
        .Q(\dest_graysync_ff[1] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [9]),
        .Q(\dest_graysync_ff[1] [9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(binval[1]),
        .O(binval[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[10]_i_1 
       (.I0(\dest_graysync_ff[1] [10]),
        .I1(\dest_graysync_ff[1] [11]),
        .O(binval[10]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(binval[6]),
        .I4(\dest_graysync_ff[1] [4]),
        .I5(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(binval[6]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(binval[6]),
        .I3(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(binval[6]),
        .I2(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[5]_i_1 
       (.I0(\dest_graysync_ff[1] [5]),
        .I1(binval[6]),
        .O(binval[5]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[6]_i_1 
       (.I0(\dest_graysync_ff[1] [6]),
        .I1(\dest_graysync_ff[1] [8]),
        .I2(\dest_graysync_ff[1] [10]),
        .I3(\dest_graysync_ff[1] [11]),
        .I4(\dest_graysync_ff[1] [9]),
        .I5(\dest_graysync_ff[1] [7]),
        .O(binval[6]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[7]_i_1 
       (.I0(\dest_graysync_ff[1] [7]),
        .I1(\dest_graysync_ff[1] [9]),
        .I2(\dest_graysync_ff[1] [11]),
        .I3(\dest_graysync_ff[1] [10]),
        .I4(\dest_graysync_ff[1] [8]),
        .O(binval[7]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[8]_i_1 
       (.I0(\dest_graysync_ff[1] [8]),
        .I1(\dest_graysync_ff[1] [10]),
        .I2(\dest_graysync_ff[1] [11]),
        .I3(\dest_graysync_ff[1] [9]),
        .O(binval[8]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[9]_i_1 
       (.I0(\dest_graysync_ff[1] [9]),
        .I1(\dest_graysync_ff[1] [11]),
        .I2(\dest_graysync_ff[1] [10]),
        .O(binval[9]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[10]),
        .Q(dest_out_bin[10]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [11]),
        .Q(dest_out_bin[11]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[6]),
        .Q(dest_out_bin[6]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[7]),
        .Q(dest_out_bin[7]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[8]),
        .Q(dest_out_bin[8]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[9]),
        .Q(dest_out_bin[9]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[10]_i_1 
       (.I0(src_in_bin[11]),
        .I1(src_in_bin[10]),
        .O(gray_enc[10]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[5]_i_1 
       (.I0(src_in_bin[6]),
        .I1(src_in_bin[5]),
        .O(gray_enc[5]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[6]_i_1 
       (.I0(src_in_bin[7]),
        .I1(src_in_bin[6]),
        .O(gray_enc[6]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[7]_i_1 
       (.I0(src_in_bin[8]),
        .I1(src_in_bin[7]),
        .O(gray_enc[7]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[8]_i_1 
       (.I0(src_in_bin[9]),
        .I1(src_in_bin[8]),
        .O(gray_enc[8]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[9]_i_1 
       (.I0(src_in_bin[10]),
        .I1(src_in_bin[9]),
        .O(gray_enc[9]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[10] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[10]),
        .Q(async_path[10]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[11] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[11]),
        .Q(async_path[11]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[5]),
        .Q(async_path[5]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[6] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[6]),
        .Q(async_path[6]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[7] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[7]),
        .Q(async_path[7]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[8] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[8]),
        .Q(async_path[8]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[9] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[9]),
        .Q(async_path[9]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "12" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module fifo_4k_xpm_cdc_gray__2
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [11:0]src_in_bin;
  input dest_clk;
  output [11:0]dest_out_bin;

  wire [11:0]async_path;
  wire [10:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [11:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [11:0]\dest_graysync_ff[1] ;
  wire [11:0]dest_out_bin;
  wire [10:0]gray_enc;
  wire src_clk;
  wire [11:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[10]),
        .Q(\dest_graysync_ff[0] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[11]),
        .Q(\dest_graysync_ff[0] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[6]),
        .Q(\dest_graysync_ff[0] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[7]),
        .Q(\dest_graysync_ff[0] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[8]),
        .Q(\dest_graysync_ff[0] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[9]),
        .Q(\dest_graysync_ff[0] [9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [10]),
        .Q(\dest_graysync_ff[1] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [11]),
        .Q(\dest_graysync_ff[1] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [6]),
        .Q(\dest_graysync_ff[1] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [7]),
        .Q(\dest_graysync_ff[1] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [8]),
        .Q(\dest_graysync_ff[1] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [9]),
        .Q(\dest_graysync_ff[1] [9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(binval[1]),
        .O(binval[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[10]_i_1 
       (.I0(\dest_graysync_ff[1] [10]),
        .I1(\dest_graysync_ff[1] [11]),
        .O(binval[10]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(binval[6]),
        .I4(\dest_graysync_ff[1] [4]),
        .I5(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(binval[6]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(binval[6]),
        .I3(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(binval[6]),
        .I2(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[5]_i_1 
       (.I0(\dest_graysync_ff[1] [5]),
        .I1(binval[6]),
        .O(binval[5]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[6]_i_1 
       (.I0(\dest_graysync_ff[1] [6]),
        .I1(\dest_graysync_ff[1] [8]),
        .I2(\dest_graysync_ff[1] [10]),
        .I3(\dest_graysync_ff[1] [11]),
        .I4(\dest_graysync_ff[1] [9]),
        .I5(\dest_graysync_ff[1] [7]),
        .O(binval[6]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[7]_i_1 
       (.I0(\dest_graysync_ff[1] [7]),
        .I1(\dest_graysync_ff[1] [9]),
        .I2(\dest_graysync_ff[1] [11]),
        .I3(\dest_graysync_ff[1] [10]),
        .I4(\dest_graysync_ff[1] [8]),
        .O(binval[7]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[8]_i_1 
       (.I0(\dest_graysync_ff[1] [8]),
        .I1(\dest_graysync_ff[1] [10]),
        .I2(\dest_graysync_ff[1] [11]),
        .I3(\dest_graysync_ff[1] [9]),
        .O(binval[8]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[9]_i_1 
       (.I0(\dest_graysync_ff[1] [9]),
        .I1(\dest_graysync_ff[1] [11]),
        .I2(\dest_graysync_ff[1] [10]),
        .O(binval[9]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[10]),
        .Q(dest_out_bin[10]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [11]),
        .Q(dest_out_bin[11]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[6]),
        .Q(dest_out_bin[6]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[7]),
        .Q(dest_out_bin[7]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[8]),
        .Q(dest_out_bin[8]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[9]),
        .Q(dest_out_bin[9]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[10]_i_1 
       (.I0(src_in_bin[11]),
        .I1(src_in_bin[10]),
        .O(gray_enc[10]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[5]_i_1 
       (.I0(src_in_bin[6]),
        .I1(src_in_bin[5]),
        .O(gray_enc[5]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[6]_i_1 
       (.I0(src_in_bin[7]),
        .I1(src_in_bin[6]),
        .O(gray_enc[6]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[7]_i_1 
       (.I0(src_in_bin[8]),
        .I1(src_in_bin[7]),
        .O(gray_enc[7]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[8]_i_1 
       (.I0(src_in_bin[9]),
        .I1(src_in_bin[8]),
        .O(gray_enc[8]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[9]_i_1 
       (.I0(src_in_bin[10]),
        .I1(src_in_bin[9]),
        .O(gray_enc[9]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[10] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[10]),
        .Q(async_path[10]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[11] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[11]),
        .Q(async_path[11]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[5]),
        .Q(async_path[5]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[6] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[6]),
        .Q(async_path[6]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[7] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[7]),
        .Q(async_path[7]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[8] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[8]),
        .Q(async_path[8]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[9] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[9]),
        .Q(async_path[9]),
        .R(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 114992)
`pragma protect data_block
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
GohKFabtrahmyMEG7rTqk4unIPJZjEc=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
