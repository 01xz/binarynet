`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/15 21:11:06
// Design Name: 
// Module Name: layer1_asm_top
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


module layer1_asm_top(
//INPUT
data_weight1,
data_weight2,
data_weight3,
data_weight4,
data_weight5,
data_weight6,
data_weight7,
data_weight8,
data_pix,
data_bn,
clk,
rst,
asm_send,
asm_reception,
calculate_en,
//OUTPUT
data_out
    );
 parameter img_width = 16;
 parameter bn_width = 16;
 parameter asm_number = 8; //状态机的数量   
    
input data_weight1,data_weight2,data_weight3,data_weight4,data_weight5,data_weight6,data_weight7,data_weight8;
input [img_width-1:0] data_pix;
input [bn_width-1:0] data_bn;
input clk,rst;
input [asm_number-1:0] asm_send;
input [asm_number-1:0] asm_reception;
input calculate_en;
output [15:0] data_out;
wire [asm_number-1:0] result;
reg [15:0] result1;
reg [15:0] result2;
reg [1:0] count;
reg [asm_number-1:0] send;

//wire data_out1,data_out2,data_out3,data_out4,data_out5,data_out6,data_out7,data_out8;
//第一个数被存到最低位
ASM U_ASM1(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight1),
     .data_bn(data_bn),
     .asm_send(asm_send[0]),
     .asm_reception(asm_reception[0]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[0])
    );

ASM U_ASM2(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight2),
     .data_bn(data_bn),
     .asm_send(asm_send[1]),
     .asm_reception(asm_reception[1]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[1])
    );

ASM U_ASM3(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight3),
     .data_bn(data_bn),
     .asm_send(asm_send[2]),
     .asm_reception(asm_reception[2]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[2])
    );

ASM U_ASM4(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight4),
     .data_bn(data_bn),
     .asm_send(asm_send[3]),
     .asm_reception(asm_reception[3]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[3])
    );

ASM U_ASM5(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight5),
     .data_bn(data_bn),
     .asm_send(asm_send[4]),
     .asm_reception(asm_reception[4]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[4])
    );
    
ASM U_ASM6(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight6),
     .data_bn(data_bn),
     .asm_send(asm_send[5]),
     .asm_reception(asm_reception[5]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[5])
    );
    
 ASM U_ASM7(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight7),
     .data_bn(data_bn),
     .asm_send(asm_send[6]),
     .asm_reception(asm_reception[6]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[6])
    );
    
 ASM U_ASM8(
     //INPUT
     .data_pix(data_pix),
     .data_weights(data_weight8),
     .data_bn(data_bn),
     .asm_send(asm_send[7]),
     .asm_reception(asm_reception[7]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en),
     //OUTPUT
     .data_out(result[7])
    );
 always@(posedge clk or negedge rst)
 begin
     if(!rst)
         begin
             count<=0;
             result1<=0;
             result2<=0;
             send<=0;
         end
     else
         begin
            if(calculate_en)begin
             if(send == 8'b11111111)
                 begin
                     if(count == 0) begin result1[7:0]<=result; count<=1;  end
                     if(count == 1) begin result1[15:8]<=result;count<=2;  end
                     if(count == 2) begin result2[7:0]<=result; count<=3;  end
                     if(count == 3) begin result2[15:8]<=result;count<=0;  end
                 end
            end
            else begin  count<=0; end
         end
     send<=asm_send;
 end
 assign data_out = ((count == 0) || (count == 1)) ? result2 : (((count == 2) || (count == 3)) ? result1 : 0);
endmodule
