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
cs1,
cs2,
cs3,
cs4,
cs5,
cs6,
cs7,
cs8,
cs9,
oe1,
oe9,
we1,
we2,
we3,
we4,
we5,
we6,
we7,
we8,
we9,
data1,
data2,
data3,
data4,
data5,
data6,
data7,
data8,
data9,
addr1,
addr2,
addr3,
addr4,
addr5,
addr6,
addr7,
addr8,
addr9,
clk
    );
parameter weight_width = 1;
parameter addr_width = 9;
parameter bn_addr_width = 7;
parameter bn_width = 16;
input cs1;
input cs2;
input cs3;
input cs4;
input cs5;
input cs6;
input cs7;
input cs8;
input cs9;
input oe1;
input oe9;
input we1;
input we2;
input we3;
input we4;
input we5;
input we6;
input we7;
input we8;
input we9;
inout data1;
inout data2;
inout data3;
inout data4;
inout data5;
inout data6;
inout data7;
inout data8;
inout [bn_width-1:0] data9;
input [addr_width-1:0]addr1;
input [addr_width-1:0]addr2;
input [addr_width-1:0]addr3;
input [addr_width-1:0]addr4;
input [addr_width-1:0]addr5;
input [addr_width-1:0]addr6;
input [addr_width-1:0]addr7;
input [addr_width-1:0]addr8;
input [bn_addr_width-1:0]addr9;
input clk;

sram
#(weight_width,addr_width)
 U_SRAM1(
    .a(addr1),
    .clk(clk),
    .cs(cs1),
    .oe(oe1),
    .we(we1),
    .d(data1)
    );  
sram
#(weight_width,addr_width)
 U_SRAM2(
    .a(addr2),
    .clk(clk),
    .cs(cs2),
    .oe(oe1),
    .we(we2),
    .d(data2)
    );  
sram
#(weight_width,addr_width)
 U_SRAM3(
    .a(addr3),
    .clk(clk),
    .cs(cs3),
    .oe(oe1),
    .we(we3),
    .d(data3)
    );  
sram
#(weight_width,addr_width)
 U_SRAM4(
    .a(addr4),
    .clk(clk),
    .cs(cs4),
    .oe(oe1),
    .we(we4),
    .d(data4)
    );  
sram
#(weight_width,addr_width)
 U_SRAM5(
    .a(addr5),
    .clk(clk),
    .cs(cs5),
    .oe(oe1),
    .we(we5),
    .d(data5)
    );  
sram
#(weight_width,addr_width)
 U_SRAM6(
    .a(addr6),
    .clk(clk),
    .cs(cs6),
    .oe(oe1),
    .we(we6),
    .d(data6)
    );  
sram
#(weight_width,addr_width)
 U_SRAM7(
    .a(addr7),
    .clk(clk),
    .cs(cs7),
    .oe(oe1),
    .we(we7),
    .d(data7)
    );  
sram
#(weight_width,addr_width)
 U_SRAM8(
    .a(addr8),
    .clk(clk),
    .cs(cs8),
    .oe(oe1),
    .we(we8),
    .d(data8)
    );  
sram
#(bn_width,bn_addr_width)
 U_SRAM9(
    .a(addr9),
    .clk(clk),
    .cs(cs9),
    .oe(oe9),
    .we(we9),
    .d(data9)
    );  


endmodule
