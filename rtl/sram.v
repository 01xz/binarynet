`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/08 13:54:46
// Design Name: 
// Module Name: sram
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


module sram
#(parameter DW = 8,AW = 4)
(
    input [AW-1:0]a,//address
    input clk,
    input cs,// chip select
    input oe,// output enable
    input we,// write enable
    inout [DW-1:0]d// data
    );
 
// 
parameter DP = 1 << AW;// depth 
reg [DW-1:0]mem[0:DP-1];
reg [DW-1:0]reg_d;
//
always@(posedge clk)
begin
    if( !cs & !we)//write declaration
        begin
            mem[a] <= d;
        end
    else if(!cs & we & !oe)
        begin
            reg_d <= mem[a];
        end
    else
        begin
            mem[a] <= mem[a];
            reg_d <= reg_d;
        end
end
//
assign d = (!cs & we & ! oe) ? reg_d : {DW{1'bz}};
endmodule

