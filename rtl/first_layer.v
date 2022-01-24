`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/08 20:17:43
// Design Name: 
// Module Name: first_layer
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


module first_layer(
//INPUT
pre_data_offm,//��Դ��ģ������źţ�off module,��ǰһ�����źſ���ǰһ��sram��д
pre_wr1_offm,pre_wr2_offm,
pre_en1_offm,pre_en2_offm,
pre_addr_offm,

next_rd1_offm,next_rd2_offm,//�ɺ�һ�����źſ���sram�Ķ�
next_en1_offm,next_en2_offm,
next_addr_offm,


pre_sram_full1,//ǰ���͹����������ź�
pre_sram_full2,
next_sram_empty1,
next_sram_empty2,

clk,
rst,

weight_offm,
weight_en_offm,
weight_wr_offm,
weight_addr_offm,
bn_addr_offm,
bn_offm,
bn_en_offm,
bn_wr_offm,
//OUTPUT
next_sram_full1,//��ǰ���������͵������ź�
next_sram_full2,
img_request1,
img_request2,
next_data_offm
    );
parameter img_width = 16;
parameter bn_width = 16;
parameter pre_addr_width = 10;
parameter next_addr_width = 13;
parameter weight_addr_width = 9;
parameter bn_addr_width = 7;
parameter asm_number = 8;

input [img_width-1:0] pre_data_offm;
input pre_wr1_offm,pre_wr2_offm;
input pre_en1_offm,pre_en2_offm;
input [pre_addr_width-1:0] pre_addr_offm;

input next_rd1_offm,next_rd2_offm;
input next_en1_offm,next_en2_offm;
input [next_addr_width-1:0] next_addr_offm;
output [15:0]next_data_offm;//next sram�е�����2��8����ģ�������16λ

input pre_sram_full1;//ǰ���͹����������ź�
input pre_sram_full2;
input next_sram_empty1;
input next_sram_empty2;

input clk,rst;

input[7:0] weight_offm;//Ȩ����һλ��
input weight_en_offm;
input weight_wr_offm;
input [weight_addr_width-1:0] weight_addr_offm;

input [bn_addr_width-1:0] bn_addr_offm;
input [15:0] bn_offm;//bnϵ����16λ��
input bn_en_offm;
input bn_wr_offm;

output next_sram_full1;
output next_sram_full2;
output img_request1;
output img_request2;





wire pre_en1_ctr,pre_en2_ctr;
wire pre_rd1_ctr,pre_rd2_ctr;
wire [9:0] pre_addr_ctr;
wire [img_width-1:0] din;
wire [img_width-1:0] dout;
wire next_en1_ctr,next_en2_ctr,next_wr1_ctr,next_wr2_ctr;
wire [12:0] next_addr_ctr;
wire [8:0] weight_addr_ctr;
wire weight_en_ctr,weight_rd_ctr;
wire calculate_en;
wire [6:0] bn_addr_ctr;
wire bn_rd_ctr,bn_en_ctr;
wire [7:0] asm_send;
wire [7:0] asm_choose;
wire [15:0] data_out;
wire [7:0] weight;
wire [15:0] bn;
weight_sram1(
//INPUT
.cs1_rd(weight_en_ctr),
.cs1_wr(weight_en_offm),
.oe1_rd(weight_rd_ctr),
.oe1_wr(1'b1),
.we1_rd(1'b1),
.we1_wr(weight_wr_offm),
.cs2_rd(bn_en_ctr),
.cs2_wr(bn_en_offm),
.oe2_rd(bn_rd_ctr),
.oe2_wr(1'b1),
.we2_rd(1'b1),
.we2_wr(bn_wr_offm),
.data1_rd(weight),
.data1_wr(weight_offm),
.data2_rd(bn),
.data2_wr(bn_offm),
.addr1_rd(weight_addr_ctr),
.addr1_wr(weight_addr_offm),
.addr2_rd(bn_addr_ctr),
.addr2_wr(bn_addr_offm),
.clk(clk)
    );
    wire [15:0] pre_data1_rd,pre_data2_rd;
pre_sram(
//INPUT
.cs1_rd(pre_en1_ctr),
.cs1_wr(pre_en1_offm),
.cs2_rd(pre_en2_ctr),
.cs2_wr(pre_en2_offm),
.oe1_rd(pre_rd1_ctr),
.oe1_wr(1'b1),
.oe2_rd(pre_rd2_ctr),
.oe2_wr(1'b1),
.we1_rd(1'b1),
.we1_wr(pre_wr1_offm),
.we2_rd(1'b1),
.we2_wr(pre_wr2_offm),
.data1_rd(pre_data1_rd),
.data_wr(pre_data_offm),
.data2_rd(pre_data2_rd),
.addr_rd(pre_addr_ctr),
.addr_wr(pre_addr_offm),
.clk(clk)
//OUTPUT
    );
wire [15:0] next_data1_rd,next_data2_rd;
assign next_data_offm = (next_rd1_offm == 0) ? next_data1_rd :((next_rd2_offm == 0) ? next_data2_rd : 0);
next_sram(
//INPUT
.cs1_rd(next_en1_offm),
.cs1_wr(next_en1_ctr),
.cs2_rd(next_en2_offm),
.cs2_wr(next_en2_ctr),
.oe1_rd(next_rd1_offm),
.oe1_wr(1'b1),
.oe2_rd(next_rd2_offm),
.oe2_wr(1'b1),
.we1_rd(1'b1),
.we1_wr(next_wr1_ctr),
.we2_rd(1'b1),
.we2_wr(next_wr2_ctr),
.data1_rd(next_data1_rd),
.data_wr(data_out),//����ʱ����һ���ӿڿ��ܻ��������
.data2_rd(next_data2_rd),
.addr_rd(next_addr_offm),
.addr_wr(next_addr_ctr),
.clk(clk)
//OUTPUT
    );

    /**��ctr��׺��sram�����źŴ���������CONTROL_AND_FETCH1ģ��**/

assign din = (pre_rd1_ctr == 0) ? pre_data1_rd:((pre_rd1_ctr == 0) ?  pre_data2_rd : 0);
CONTROL_AND_FETCH1 U_CONTROL_AND_FETCH(
         //INPUT
         .clk(clk),
         .rst(rst),
         .din(din),
         .pre_sram_full1(pre_sram_full1),
         .pre_sram_full2(pre_sram_full2),
         .next_sram_empty1(next_sram_empty1),
         .next_sram_empty2(next_sram_empty2),
         //OUTPUT
         .dout(dout),
         .pre_addr(pre_addr_ctr), //���͸�ǰһ��sram�ĵ�ַ
         .pre_sram_en1(pre_en1_ctr),//���͸�ǰһ��sram��Ƭѡ�ź�
         .pre_sram_en2(pre_en2_ctr),
         .pre_rd1(pre_rd1_ctr),//���͸�ǰһ��sram�Ķ�ʹ���ź�
         .pre_rd2(pre_rd2_ctr),
         .next_sram_en1(next_en1_ctr),//���͸���һ��sram��Ƭѡ�ź�
         .next_sram_en2(next_en2_ctr),
         .next_wr1(next_wr1_ctr),//���͸���һ��sram��дʹ��
         .next_wr2(next_wr2_ctr),
         .next_addr(next_addr_ctr),//���͸���һ��sram�ĵ�ַ�ź�
         .weights_addr(weight_addr_ctr),//���͸�Ȩ��sram�ĵ�ַ�ź�
         .weights_sram_en(weight_en_ctr),//���͸�Ȩ��sram��Ƭѡ�ź�
         .weights_sram_rd(weight_rd_ctr),//���͸�Ȩ��sram�Ķ�ʹ���ź�
         .img_request1(img_request1),
         .img_request2(img_request2),
         .calculate_en(calculate_en),
         .asm_send(asm_send),
         .next_sram_full1(next_sram_full1),
         .next_sram_full2(next_sram_full2),
         .bn_addr(bn_addr_ctr),//���͸�bn sram�ĵ�ַ
         .bn_rd(bn_rd_ctr),//���͸�bn sram�Ķ�ʹ��sram
         .bn_en(bn_en_ctr),//���͸�bn sram��Ƭѡ�ź�
         .asm_choose(asm_choose)
    );

layer1_asm_top LAYER1_ASM_TOP(
//INPUT
.data_weight1(weight[0]),
.data_weight2(weight[1]),
.data_weight3(weight[2]),
.data_weight4(weight[3]),
.data_weight5(weight[4]),
.data_weight6(weight[5]),
.data_weight7(weight[6]),
.data_weight8(weight[7]),
.data_pix(dout),
.data_bn(bn),
.clk(clk),
.rst(rst),
.asm_send(asm_send),
.asm_reception(asm_choose),
.calculate_en(calculate_en),
//OUTPUT
.data_out(data_out)
    );
endmodule
