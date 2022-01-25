`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/25 15:27:29
// Design Name: 
// Module Name: weight_sram3
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


module weight_sram3(
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

cs4_rd,
oe4_rd,
we4_rd,
data4_rd,
addr4_rd,
cs4_wr,
oe4_wr,
we4_wr,
data4_wr,
addr4_wr,
clk
    );
parameter weight_width = 32;
parameter addr_width1 = 12,addr_width2 = 10;
parameter bn_width = 16;
parameter addr_width3 = 8;
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
input [addr_width1-1:0]addr2_rd;
input cs2_wr;
input oe2_wr;
input we2_wr;
input [weight_width-1:0] data2_wr;
input [addr_width1-1:0] addr2_wr;

input cs3_rd;
input oe3_rd;
input we3_rd;
output[weight_width-1:0]data3_rd;
input [addr_width2-1:0] addr3_rd;
input cs3_wr;
input oe3_wr;
input we3_wr;
input [weight_width-1:0] data3_wr;
input [addr_width2-1:0] addr3_wr;

input cs4_rd;
input oe4_rd;
input we4_rd;
output[bn_width-1:0]data4_rd;
input [addr_width3-1:0] addr4_rd;
input cs4_wr;
input oe4_wr;
input we4_wr;
input [bn_width-1:0] data4_wr;
input [addr_width3-1:0] addr4_wr;

input clk;

 DUAL_SRAM //统一定义1口用于读，二口用于写
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
 DUAL_SRAM //统一定义1口用于读，二口用于写
#(weight_width,addr_width1)
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
 DUAL_SRAM //统一定义1口用于读，二口用于写
#( weight_width,addr_width2)
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
  DUAL_SRAM //统一定义1口用于读，二口用于写
#( weight_width,addr_width2)
U_SRAM4(
     .clk(clk),
     .a1(addr4_rd),//address
     .cs1(cs4_rd),// chip select
     .oe1(oe4_rd),// output enable
     .we1(we4_rd),// write enable
     .d1(data4_rd),// data
    // 
     .a2(addr4_wr),//address
     .cs2(cs4_wr),// chip select
     .oe2(oe4_wr),// output enable
     .we2(we4_wr),// write enable
     .d2(data4_wr)// data
    );    
endmodule
