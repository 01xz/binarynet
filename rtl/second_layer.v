`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/24 19:34:19
// Design Name: 
// Module Name: second_layer
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


module second_layer(
//INPUT
next_rd1_offm,
next_en1_offm,
next_rd2_offm,
next_en2_offm,
next_addr_offm,
pre_data_offm,

weight_offm,
bn_offm,
weight_en1_offm,
weight_wr1_offm,
weight_en2_offm,
weight_wr2_offm,
weight_addr1_offm,
weight_addr2_offm,
bn_en_offm,
bn_wr_offm,
bn_addr_offm,

pre_sram_full1,//ǰ���͹����������ź�
pre_sram_full2,
next_sram_empty1,
next_sram_empty2,
clk,rst,
//OUTPUT
next_data_offm,
pre_rd1_offm,
pre_en1_offm,
pre_rd2_offm,
pre_en2_offm,
pre_addr_offm,

next_sram_full1,//��ǰ���������͵������ź�
next_sram_full2,
pre_sram_empty1,
pre_sram_empty2
    );
parameter next_addr = 9;
parameter weight_addr1 = 11,weight_addr2 = 8; 
parameter pre_addr = 13;
input next_rd1_offm;
input next_en1_offm;
input next_rd2_offm;
input next_en2_offm;
input [next_addr-1:0] next_addr_offm;
input [15:0] pre_data_offm;

input [63:0] weight_offm;
input [15:0] bn_offm;
input weight_en1_offm;
input weight_wr1_offm;
input weight_en2_offm;
input weight_wr2_offm;
input [weight_addr1-1:0] weight_addr1_offm;
input [weight_addr2-1:0] weight_addr2_offm;
input bn_en_offm;
input bn_wr_offm;
input [6:0] bn_addr_offm;

input pre_sram_full1;//ǰ���͹����������ź�
input pre_sram_full2;
input next_sram_empty1;
input next_sram_empty2;

input clk,rst;

output [63:0] next_data_offm;
output pre_rd1_offm;
output pre_en1_offm;
output pre_rd2_offm;
output pre_en2_offm;
output[pre_addr-1:0] pre_addr_offm;

output next_sram_full1;//��ǰ���������͵������ź�
output next_sram_full2;
output pre_sram_empty1;
output pre_sram_empty2;

wire dout1_ctr,dout2_ctr,dout3_ctr,dout4_ctr,dout5_ctr,dout6_ctr,dout7_ctr,dout8_ctr;
wire next_en1_ctr,next_en2_ctr,next_wr1_ctr,next_wr2_ctr;
wire [next_addr-1:0] next_addr_ctr;
wire [weight_addr1-1:0] weight_addr1_ctr;
wire [weight_addr2-1:0] weight_addr2_ctr;
wire weight_en1_ctr,weight_en2_ctr,weight_rd1_ctr,weight_rd2_ctr;
wire [7:0] calculate_en;
wire [63:0] asm_change,asm_choose;
wire [6:0] bn_addr_ctr;
wire bn_en_ctr,bn_rd_ctr;
wire [63:0] weight1,weight2,weight;
wire [15:0] bn;
reg weight_rd_buffer1,weight_rd_buffer2;
always @(posedge clk or negedge rst)
begin
  if(!rst)
      begin
      weight_rd_buffer1<=0;
      weight_rd_buffer2<=0;
      end
  else
      begin
          weight_rd_buffer1<=weight_rd1_ctr;
          weight_rd_buffer2<=weight_rd2_ctr;
      end
end
CONTROL_AND_FETCH2 U_CONTROL_AND_FETCH2(
         //INPUT
         .clk(clk),
         .rst(rst),
         .din(pre_data_offm),//��sram�ж�ȡ������
         .pre_sram_full1(pre_sram_full1),//ǰһ��sram��������ź�
         .pre_sram_full2(pre_sram_full2),
         .next_sram_empty1(next_sram_empty1),
         .next_sram_empty2(next_sram_empty2),//��һ����sram�������Ϊ�յ�ʱ����Ϊ������2Ƭsram��ʱ���ã�����������
         //OUTPUT
         .dout1(dout1_ctr),.dout2(dout2_ctr),.dout3(dout3_ctr),.dout4(dout4_ctr),.dout5(dout5_ctr),.dout6(dout6_ctr),.dout7(dout7_ctr),.dout8(dout8_ctr),//����ȡ����������������״̬��֮��
         .pre_addr(pre_addr_offm),//�����ǰһ���Ķ���ַ�ź�
         .pre_sram_en1(pre_en1_offm),//ǰһ��Ƭѡ,Ϊ��ʱ��Ч
         .pre_sram_en2(pre_en2_offm),
         .pre_rd1(pre_rd1_offm),//ǰһ����ʹ�ܣ�Ϊ��ʱ��Ч
         .pre_rd2(pre_rd2_offm),
         .next_sram_en1(next_en1_ctr),//��һ��Ƭѡ����һ������һ����4Ƭsram����ƬΪһ��
         .next_sram_en2(next_en2_ctr),
         .next_wr1(next_wr1_ctr),//��һ��дʹ��
         .next_wr2(next_wr2_ctr),
         .next_addr(next_addr_ctr),//�������һ����ַ
         .weights_addr1(weight_addr1_ctr),//Ȩ�ص�ַ
         .weights_sram_en1(weight_en1_ctr),//Ȩ��Ƭѡ
         .weights_sram_rd1(weight_rd1_ctr),//Ȩ�ض�ʹ��
         .weights_addr2(weight_addr2_ctr),
         .weights_sram_en2(weight_en2_ctr),
         .weights_sram_rd2(weight_rd2_ctr),
         .pre_sram_empty1(pre_sram_empty1),//������һ��ͼ֮����ISPģ�鷢��ͼ������
         .pre_sram_empty2(pre_sram_empty2),
         .calculate_en(calculate_en),//��״̬�����Ϳ��Կ�ʼ������ź�
         .asm_change(asm_change),//����źſ���״̬������״̬
         .next_sram_full1(next_sram_full1),//�������֮�������һ����sram�Ѿ����������Կ�ʼ����
         .next_sram_full2(next_sram_full2),
         .bn_addr(bn_addr_ctr),//bn�洢���ĵ�ַ
         .bn_rd(bn_rd_ctr),//��ʹ��
         .bn_en(bn_en_ctr),//Ƭѡ
         .asm_choose(asm_choose)//�����������뵽��һƬ״̬��
    );
    wire [63:0] data1_rd_offm,data2_rd_offm;
    wire [63:0] data_out;
next_sram2 U_NEXT_SRAM2(
.cs1_rd(next_en1_offm),
.oe1_rd(next_rd1_offm),
.we1_rd(1'b1),
.cs1_wr(next_en1_ctr),
.oe1_wr(1'b1),
.we1_wr(next_wr1_ctr),
.data1_rd(data1_rd_offm),


.cs2_rd(next_en2_offm),
.oe2_rd(next_rd2_offm),
.we2_rd(1'b1),
.cs2_wr(next_en2_ctr),
.oe2_wr(1'b1),
.we2_wr(next_wr2_ctr),
.data2_rd(data2_rd_offm),

.addr_rd(next_addr_offm),
.addr_wr(next_addr_ctr),
.data_wr(data_out),

.clk(clk)
    );   
assign next_data_offm = (next_rd1_offm == 0) ? data1_rd_offm :((next_rd2_offm == 0) ? data2_rd_offm:0);
assign weight = (weight_rd_buffer1 == 0) ? weight1 : ((weight_rd_buffer2  == 0) ?weight2:0);
weight_sram2 U_WEIGHT_SRAM2(
.cs1_rd(weight_en1_ctr),
.oe1_rd(weight_rd1_ctr),
.we1_rd(1'b1),
.data1_rd(weight1),
.addr1_rd(weight_addr1_ctr),
.cs1_wr(weight_en1_offm),
.oe1_wr(1'b1),
.we1_wr(weight_wr1_offm),
.data1_wr(weight_offm),
.addr1_wr(weight_addr1_offm),

.cs2_rd(weight_en2_ctr),
.oe2_rd(weight_rd2_ctr),
.we2_rd(1'b1),
.data2_rd(weight2),
.addr2_rd(weight_addr2_ctr),
.cs2_wr(weight_en2_offm),
.oe2_wr(1'b1),
.we2_wr(weight_wr2_offm),
.data2_wr(weight_offm),
.addr2_wr(weight_addr2_offm),

.cs3_rd(bn_en_ctr),
.oe3_rd(bn_rd_ctr),
.we3_rd(1'b1),
.data3_rd(bn),
.addr3_rd(bn_addr_ctr),
.cs3_wr(bn_en_offm),
.oe3_wr(1'b1),
.we3_wr(bn_wr_offm),
.data3_wr(bn_offm),
.addr3_wr(bn_addr_offm),

.clk(clk)
    );

layer2_asm_top U_LAYER2_ASM_TOP(
//INPUT
.asm_choose(asm_choose),
.asm_change(asm_change),
.data_pix1(dout1_ctr),
.data_pix2(dout2_ctr),
.data_pix3(dout3_ctr),
.data_pix4(dout4_ctr),
.data_pix5(dout5_ctr),
.data_pix6(dout6_ctr),
.data_pix7(dout7_ctr),
.data_pix8(dout8_ctr),
.data_weight(weight),//data_weight��Ҫ���һ��
.data_bn(bn),//ͬʱ�����ȳ�������
.calculate_en(calculate_en),
.clk(clk),
.rst(rst),


//OUTPUT
.data_out(data_out)
    ); 
endmodule
