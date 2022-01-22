`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/21 18:48:32
// Design Name: 
// Module Name: dual_sram
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


module DUAL_SRAM
#(parameter DW = 8,AW = 4)
(
    input clk,
    input [AW-1:0]a1,//address
    input cs1,// chip select
    input oe1,// output enable
    input we1,// write enable
    inout [DW-1:0]d1,// data
    // 
    input [AW-1:0]a2,//address
    input cs2,// chip select
    input oe2,// output enable
    input we2,// write enable
    inout [DW-1:0]d2// data
    );
 
// 
parameter DP = 1 << AW;// depth 
reg [DW-1:0]mem[0:DP-1];
reg [DW-1:0]reg_d1;
// port2
reg [DW-1:0]reg_d2;
//initialization
// synopsys_translate_off
integer i;
initial begin
    for(i=0; i < DP; i = i + 1) begin
        mem[i] = 8'h00;
    end
end
// synopsys_translate_on
 
// read declaration
// port1
always@(posedge clk)
begin
    if(!cs1 & we1 & ! oe1)
        begin
            reg_d1 <= mem[a1];
        end
    else
        begin
            reg_d1 <= reg_d1;
        end
end
// port2
always@(posedge clk)
begin
    if(!cs2 & we2 & !oe2)
        begin
            reg_d2 <= mem[a2];
        end
    else
        begin
            reg_d2 <= reg_d2;
        end
end
 
// wrirte declaration
always@(posedge clk)
begin
    if(!cs1 & !we1)//port1 higher priority
        begin
            mem[a1] <= d1;
        end
    else if(!cs2 & !we2)
        begin
            mem[a2] <= d2;
        end
    else
        begin
            mem[a1] <= mem[a1];
            mem[a2] <= mem[a2];
        end    
end
 
// ÈýÌ¬Âß¼­
assign d1 = (cs1 & !we1 & oe1) ? reg_d1 : {DW{1'bz}};
assign d2 = (cs2 & !we2 & oe2) ? reg_d2 : {DW{1'bz}};

endmodule

