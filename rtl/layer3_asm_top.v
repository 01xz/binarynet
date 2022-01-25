`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/25 15:03:55
// Design Name: 
// Module Name: layer3_asm_top
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


module layer3_asm_top(
asm_choose,
asm_change,
data_pix1,
data_pix2,
data_pix3,
data_pix4,
data_weight,//data_weight需要多打一拍
data_bn,//同时存在扇出的问题
calculate_en,
clk,
rst,


//OUTPUT
data_out
    );
input [31:0] asm_choose;
input [31:0] asm_change;
input [1:0]  data_pix1,data_pix2,data_pix3,data_pix4;
input [31:0] data_weight;
input [15:0] data_bn;
input [3:0] calculate_en;
input clk,rst;
output [31:0] data_out;
reg [31:0] weight_buffer ;
reg [15:0] bn_buffer1,bn_buffer2,bn_buffer3,bn_buffer4;
always @(posedge clk or negedge rst)
begin
   if(!rst)
       begin
           weight_buffer<=0;
           bn_buffer1<=0;
           bn_buffer2<=0;
           bn_buffer3<=0;
           bn_buffer4<=0;

       end
    else
       begin
           weight_buffer<=data_weight;//为了打一拍
           bn_buffer1<= data_bn;//为了扇出问题
           bn_buffer2<= data_bn;
           bn_buffer3<= data_bn;
           bn_buffer4<= data_bn;
       end
end

ASM3 U_ASM0(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[0]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[0]),
     .asm_reception(asm_choose[0]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[0])
    );
ASM3 U_ASM1(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[1]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[1]),
     .asm_reception(asm_choose[1]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[1])
    );
    ASM3 U_ASM2(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[2]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[2]),
     .asm_reception(asm_choose[2]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[2])
    );
    ASM3 U_ASM3(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[3]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[3]),
     .asm_reception(asm_choose[3]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[3])
    );
    ASM3 U_ASM4(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[4]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[4]),
     .asm_reception(asm_choose[4]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[4])
    );
    ASM3 U_ASM5(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[5]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[5]),
     .asm_reception(asm_choose[5]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[5])
    );
    ASM3 U_ASM6(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[6]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[6]),
     .asm_reception(asm_choose[6]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[6])
    );
    ASM3 U_ASM7(
     //INPUT
     .data_pix(data_pix1),
     .data_weight(weight_buffer[7]),
     .data_bn(bn_buffer1),
     .asm_send(asm_change[7]),
     .asm_reception(asm_choose[7]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[0]),
     //OUTPUT
     .data_out(data_out[7])
    );
       ASM3 U_ASM8(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[8]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[8]),
     .asm_reception(asm_choose[8]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[8])
    );
           ASM3 U_ASM9(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[9]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[9]),
     .asm_reception(asm_choose[9]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[9])
    );
           ASM3 U_ASM10(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[10]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[10]),
     .asm_reception(asm_choose[10]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[10])
    );
           ASM3 U_ASM11(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[11]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[11]),
     .asm_reception(asm_choose[11]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[11])
    );
           ASM3 U_ASM12(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[12]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[12]),
     .asm_reception(asm_choose[12]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[12])
    );
           ASM3 U_ASM13(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[13]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[13]),
     .asm_reception(asm_choose[13]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[13])
    );
           ASM3 U_ASM14(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[14]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[14]),
     .asm_reception(asm_choose[14]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[14])
    );
           ASM3 U_ASM15(
     //INPUT
     .data_pix(data_pix2),
     .data_weight(weight_buffer[15]),
     .data_bn(bn_buffer2),
     .asm_send(asm_change[15]),
     .asm_reception(asm_choose[15]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[1]),
     //OUTPUT
     .data_out(data_out[15])
    );
           ASM3 U_ASM16(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[16]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[16]),
     .asm_reception(asm_choose[16]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[16])
    );
               ASM3 U_ASM17(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[17]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[17]),
     .asm_reception(asm_choose[17]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[17])
    );
               ASM3 U_ASM18(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[18]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[18]),
     .asm_reception(asm_choose[18]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[18])
    );
               ASM3 U_ASM19(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[19]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[19]),
     .asm_reception(asm_choose[19]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[19])
    );
               ASM3 U_ASM20(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[20]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[20]),
     .asm_reception(asm_choose[20]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[20])
    );
               ASM3 U_ASM21(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[21]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[21]),
     .asm_reception(asm_choose[21]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[21])
    );
               ASM3 U_ASM22(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[22]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[22]),
     .asm_reception(asm_choose[22]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[22])
    );
               ASM3 U_ASM23(
     //INPUT
     .data_pix(data_pix3),
     .data_weight(weight_buffer[23]),
     .data_bn(bn_buffer3),
     .asm_send(asm_change[23]),
     .asm_reception(asm_choose[23]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[2]),
     //OUTPUT
     .data_out(data_out[23])
    );
              ASM3 U_ASM24(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[24]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[24]),
     .asm_reception(asm_choose[24]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[24])
    );
                  ASM3 U_ASM25(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[25]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[25]),
     .asm_reception(asm_choose[25]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[25])
    );
                  ASM3 U_ASM26(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[26]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[26]),
     .asm_reception(asm_choose[26]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[26])
    );
                  ASM3 U_ASM27(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[27]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[27]),
     .asm_reception(asm_choose[27]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[27])
    );
                  ASM3 U_ASM28(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[28]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[28]),
     .asm_reception(asm_choose[28]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[28])
    );
                  ASM3 U_ASM29(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[29]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[29]),
     .asm_reception(asm_choose[29]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[29])
    );
                  ASM3 U_ASM30(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[30]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[30]),
     .asm_reception(asm_choose[30]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[30])
    );
                  ASM3 U_ASM31(
     //INPUT
     .data_pix(data_pix4),
     .data_weight(weight_buffer[31]),
     .data_bn(bn_buffer4),
     .asm_send(asm_change[31]),
     .asm_reception(asm_choose[31]),
     .clk(clk),
     .rst(rst),
     .calculate_en(calculate_en[3]),
     //OUTPUT
     .data_out(data_out[31])
    );
endmodule
