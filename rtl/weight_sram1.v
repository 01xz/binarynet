`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 12:42:27
// Design Name: 
// Module Name: weight_sram1
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


module weight_sram1(
//INPUT
cs1_rd,
cs1_wr,
oe1_rd,
oe1_wr,
we1_rd,
we1_wr,
cs2_rd,
cs2_wr,
oe2_rd,
oe2_wr,
we2_rd,
we2_wr,
data1_rd,
data1_wr,
data2_rd,
data2_wr,
addr1_rd,
addr1_wr,
addr2_rd,
addr2_wr,
clk
    );
parameter weight_width = 8;
parameter addr_width = 9;
parameter bn_width = 16;
parameter bn_addr_width = 7;
input cs1_rd;
input cs1_wr;
input oe1_rd;
input oe1_wr;
input we1_rd;
input we1_wr;
input cs2_rd;
input cs2_wr;
input oe2_rd;
input oe2_wr;
input we2_rd;
input we2_wr;
output [7:0] data1_rd;
input [7:0] data1_wr;
output [15:0] data2_rd;
input [15:0] data2_wr;
input [8:0] addr1_rd;
input [8:0] addr1_wr;
input [6:0] addr2_rd;
input [6:0] addr2_wr;
input clk;

DUAL_SRAM //统一定义1口用于读，二口用于写
#( weight_width,addr_width)
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
 
 DUAL_SRAM //统一定义1口用于读，二口用于写
#( bn_width,bn_addr_width)
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


endmodule
