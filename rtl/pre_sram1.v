`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 12:28:43
// Design Name: 
// Module Name: pre_sram1
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


module pre_sram(
//INPUT
cs1,
cs2,
oe1,
oe2,
we1,
we2,
data1,
data2,
addr,
clk
//OUTPUT
    );
parameter  data_width = 16 ;
parameter  addr_width = 10; 
input cs1,cs2,oe1,oe2,we1,we2;
inout [15:0] data1,data2;
input clk;
input [addr_width-1:0] addr;
sram
#(data_width,addr_width)
 U_SRAM1(
    .a(addr),
    .clk(clk),
    .cs(cs1),
    .oe(oe1),
    .we(we1),
    .d(data1)
    );

sram
#(data_width,addr_width)
 U_SRAM2(
    .a(addr),
    .clk(clk),
    .cs(cs2),
    .oe(oe2),
    .we(we2),
    .d(data2)
    );    
endmodule
