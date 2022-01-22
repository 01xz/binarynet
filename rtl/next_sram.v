`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 09:42:38
// Design Name: 
// Module Name: next_sram
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


module next_sram(
//INPUT
cs1_rd,
cs1_wr,
cs2_rd,
cs2_wr,
oe1_rd,
oe1_wr,
oe2_rd,
oe2_wr,
we1_rd,
we1_wr,
we2_rd,
we2_wr,
data1_rd,
data_wr,
data2_rd,
addr_rd,
addr_wr,
clk
//OUTPUT
    );
parameter  data_width = 16 ;
parameter  addr_width = 13; 
input cs1_rd;
input cs1_wr;
input cs2_rd;
input cs2_wr;
input oe1_rd;
input oe1_wr;
input oe2_rd;
input oe2_wr;
input we1_rd;
input we1_wr;
input we2_rd;
input we2_wr;
output [data_width-1:0] data1_rd;
input [data_width-1:0] data_wr;
output [data_width-1:0] data2_rd;
input [addr_width-1:0] addr_rd;
input [addr_width-1:0] addr_wr;
input clk;

DUAL_SRAM //统一定义1口用于读，二口用于写
#( data_width,addr_width)
U_SRAM1(
     .clk(clk),
     .a1(addr_rd),//address
     .cs1(cs1_rd),// chip select
     .oe1(oe1_rd),// output enable
     .we1(we1_rd),// write enable
     .d1(data1_rd),// data
    // 
     .a2(addr_wr),//address
     .cs2(cs1_wr),// chip select
     .oe2(oe1_wr),// output enable
     .we2(we1_wr),// write enable
     .d2(data_wr)// data
    );
 
 DUAL_SRAM //统一定义1口用于读，二口用于写
#( data_width,addr_width)
U_SRAM2(
     .clk(clk),
     .a1(addr_rd),//address
     .cs1(cs2_rd),// chip select
     .oe1(oe2_rd),// output enable
     .we1(we2_rd),// write enable
     .d1(data2_rd),// data
    // 
     .a2(addr_wr),//address
     .cs2(cs2_wr),// chip select
     .oe2(oe2_wr),// output enable
     .we2(we2_wr),// write enable
     .d2(data_wr)// data
    );   



endmodule
