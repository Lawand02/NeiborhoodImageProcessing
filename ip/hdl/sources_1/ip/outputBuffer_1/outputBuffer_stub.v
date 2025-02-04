// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Mon Jan 27 16:29:48 2025
// Host        : DESKTOP-0BRJA0I running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {d:/FPGA/Vivado
//               Project/ip_repo/ImageProcessing/ImageProcessing.srcs/sources_1/ip/outputBuffer_1/outputBuffer_stub.v}
// Design      : outputBuffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_2,Vivado 2018.2" *)
module outputBuffer(wr_rst_busy, rd_rst_busy, s_aclk, s_aresetn, 
  s_axis_tvalid, s_axis_tready, s_axis_tdata, s_axis_tuser, m_axis_tvalid, m_axis_tready, 
  m_axis_tdata, m_axis_tuser, axis_prog_full)
/* synthesis syn_black_box black_box_pad_pin="wr_rst_busy,rd_rst_busy,s_aclk,s_aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],s_axis_tuser[0:0],m_axis_tvalid,m_axis_tready,m_axis_tdata[7:0],m_axis_tuser[0:0],axis_prog_full" */;
  output wr_rst_busy;
  output rd_rst_busy;
  input s_aclk;
  input s_aresetn;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tuser;
  output axis_prog_full;
endmodule
