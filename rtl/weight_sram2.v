`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/24 11:51:12
// Design Name: 
// Module Name: weight_sram2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module weight_sram2(
cs1_rd,
oe1_rd,
we1_rd,
data1_rd,
addr1_rd,
cs1_wr,
oe1_wr,
we1_wr,
data1_wr,
addr1_wr,

cs2_rd,
oe2_rd,
we2_rd,
data2_rd,
addr2_rd,
cs2_wr,
oe2_wr,
we2_wr,
data2_wr,
addr2_wr,

cs3_rd,
oe3_rd,
we3_rd,
data3_rd,
addr3_rd,
cs3_wr,
oe3_wr,
we3_wr,
data3_wr,
addr3_wr,

clk
    );
parameter weight_width = 64;
parameter bn_width = 16;
parameter addr_width1 = 11,  addr_width2= 8, addr_width3 = 7;

input cs1_rd;
input oe1_rd;
input we1_rd;
output[weight_width-1:0] data1_rd;
input [addr_width1-1:0] addr1_rd;
input cs1_wr;
input oe1_wr;
input we1_wr;
input [weight_width-1:0] data1_wr;
input [addr_width1-1:0]addr1_wr;

input cs2_rd;
input oe2_rd;
input we2_rd;
output[weight_width-1:0] data2_rd;
input [addr_width2-1:0]addr2_rd;
input cs2_wr;
input oe2_wr;
input we2_wr;
input [weight_width-1:0] data2_wr;
input [addr_width2-1:0] addr2_wr;

input cs3_rd;
input oe3_rd;
input we3_rd;
output[bn_width-1:0]data3_rd;
input [addr_width3-1:0] addr3_rd;
input cs3_wr;
input oe3_wr;
input we3_wr;
input [bn_width-1:0] data3_wr;
input [addr_width3-1:0] addr3_wr;

input clk;

 DUAL_SRAM //ͳһ����1�����ڶ�����������д
#( weight_width,addr_width1)
U_SRAM1(
     .clk(clk),
     .a1(addr1_rd),//address
     .cs1(cs1_rd),// chip select
     .oe1(oe1_rd),// output enable
     .we1(we1_rd),// write enable
     .d1(data1_rd),// data
    // 
     .a2(addr1_wr),//address
     .cs2(cs1_wr),// chip select
     .oe2(oe1_wr),// output enable
     .we2(we1_wr),// write enable
     .d2(data1_wr)// data
    );   
 DUAL_SRAM //ͳһ����1�����ڶ�����������д
#(weight_width,addr_width2)
U_SRAM2(
     .clk(clk),
     .a1(addr2_rd),//address
     .cs1(cs2_rd),// chip select
     .oe1(oe2_rd),// output enable
     .we1(we2_rd),// write enable
     .d1(data2_rd),// data
    // 
     .a2(addr2_wr),//address
     .cs2(cs2_wr),// chip select
     .oe2(oe2_wr),// output enable
     .we2(we2_wr),// write enable
     .d2(data2_wr)// data
    );   
 DUAL_SRAM //ͳһ����1�����ڶ�����������д
#( bn_width,addr_width3)
U_SRAM3(
     .clk(clk),
     .a1(addr3_rd),//address
     .cs1(cs3_rd),// chip select
     .oe1(oe3_rd),// output enable
     .we1(we3_rd),// write enable
     .d1(data3_rd),// data
    // 
     .a2(addr3_wr),//address
     .cs2(cs3_wr),// chip select
     .oe2(oe3_wr),// output enable
     .we2(we3_wr),// write enable
     .d2(data3_wr)// data
    );       
endmodule
