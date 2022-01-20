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
pre_data_offm,//来源于模块外的信号，off module,由前一级的信号控制前一级sram的写
pre_wr1_offm,pre_wr2_offm,
pre_en1_offm,pre_en2_offm,
pre_addr_offm,

next_rd1_offm,next_rd2_offm,//由后一级的信号控制sram的读
next_en1_offm,next_en2_offm,
next_addr_offm,


pre_sram_full1,//前后发送过来的握手信号
pre_sram_full2,
next_sram_empty1,
next_sram_empty2,

clk,
rst,

weight_offm,
bn_offm,
weight_en1_offm,weight_en2_offm,weight_en3_offm,
weight_en4_offm,weight_en5_offm,weight_en6_offm,
weight_en7_offm,weight_en8_offm,weight_en9_offm,

weight_wr1_offm,weight_wr2_offm,weight_wr3_offm,
weight_wr4_offm,weight_wr5_offm,weight_wr6_offm,
weight_wr7_offm,weight_wr8_offm,weight_wr9_offm,
weight_addr_offm,
bn_addr_offm,
//OUTPUT
next_sram_full1,//给前后两级发送的握手信号
next_sram_full2,
img_request1,
img_request2,
next_data_offm
    );
parameter img_width = 16;
parameter bn_width = 16;
parameter pre_addr_width = 10;
parameter next_addr_width = 14;
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
output [7:0]next_data_offm;//next sram中的数是8个8个存的，所以是8位

input pre_sram_full1;//前后发送过来的握手信号
input pre_sram_full2;
input next_sram_empty1;
input next_sram_empty2;

input clk,rst;

input weight_offm;//权重是一位的
input [15:0] bn_offm;//bn系数是16位的
input weight_en1_offm,weight_en2_offm,weight_en3_offm,
weight_en4_offm,weight_en5_offm,weight_en6_offm,
weight_en7_offm,weight_en8_offm,weight_en9_offm;
input weight_wr1_offm,weight_wr2_offm,weight_wr3_offm,
weight_wr4_offm,weight_wr5_offm,weight_wr6_offm,
weight_wr7_offm,weight_wr8_offm,weight_wr9_offm;
input [weight_addr_width-1:0] weight_addr_offm;
input [bn_addr_width-1:0] bn_addr_offm;

output next_sram_full1;
output next_sram_full2;
output img_request1;
output img_request2;




wire weight_sram_cs1,weight_sram_cs2,weight_sram_cs3,weight_sram_cs4,weight_sram_cs5,weight_sram_cs6,weight_sram_cs7,weight_sram_cs8,weight_sram_cs9;
wire data1,data2,data3,data4,data5,data6,data7,data8;
wire [15:0] data9;
wire [6:0] bn_sram_addr;
wire [8:0] weight_sram_addr;


wire [img_width-1:0] pre_sram_data1; 
wire [img_width-1:0] pre_sram_data2; 
wire [pre_addr_width-1:0] pre_sram_addr;
wire pre_sram_cs1,pre_sram_cs2;

wire next_sram_cs1,next_sram_cs2;
wire [7:0] next_sram_data1,next_sram_data2;
wire [13:0] next_sram_addr;

wire pre_en1_ctr,pre_en2_ctr;
wire pre_rd1_ctr,pre_rd2_ctr;
wire [9:0] pre_addr_ctr;
wire [img_width-1:0] din;
wire [img_width-1:0] dout;
wire next_en1_ctr,next_en2_ctr,next_wr1_ctr,next_wr2_ctr;
wire [13:0] next_addr_ctr;
wire [8:0] weight_addr_ctr;
wire weight_en_ctr,weight_rd_ctr;
wire calculate_en;
wire [6:0] bn_addr_ctr;
wire bn_rd_ctr,bn_en_ctr;
wire [7:0] asm_send;
wire [7:0] asm_choose;
wire [7:0] data_out;

assign weight_sram_cs1 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr1_offm == 0) ? weight_en1_offm : 1);
assign weight_sram_cs2 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr2_offm == 0) ? weight_en2_offm : 1);  
assign weight_sram_cs3 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr3_offm == 0) ? weight_en3_offm : 1);
assign weight_sram_cs4 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr4_offm == 0) ? weight_en4_offm : 1);
assign weight_sram_cs5 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr5_offm == 0) ? weight_en5_offm : 1);
assign weight_sram_cs6 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr6_offm == 0) ? weight_en6_offm : 1);
assign weight_sram_cs7 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr7_offm == 0) ? weight_en7_offm : 1);
assign weight_sram_cs8 = (weight_rd_ctr == 0) ?  weight_en_ctr : ((weight_wr8_offm == 0) ? weight_en8_offm : 1);
assign weight_sram_cs9 = (weight_rd_ctr == 0) ?  bn_en_ctr : ((weight_wr9_offm == 0) ? weight_en9_offm : 1); 
assign data1 = (weight_rd_ctr == 0) ? data1  :  ((weight_wr1_offm == 0) ? weight_offm : 0);
assign data2 = (weight_rd_ctr == 0) ? data2  :  ((weight_wr2_offm == 0) ? weight_offm : 0);
assign data3 = (weight_rd_ctr == 0) ? data3  :  ((weight_wr3_offm == 0) ? weight_offm : 0);
assign data4 = (weight_rd_ctr == 0) ? data4  :  ((weight_wr4_offm == 0) ? weight_offm : 0);
assign data5 = (weight_rd_ctr == 0) ? data5  :  ((weight_wr5_offm == 0) ? weight_offm : 0);
assign data6 = (weight_rd_ctr == 0) ? data6  :  ((weight_wr6_offm == 0) ? weight_offm : 0);
assign data7 = (weight_rd_ctr == 0) ? data7  :  ((weight_wr7_offm == 0) ? weight_offm : 0);
assign data8 = (weight_rd_ctr == 0) ? data8  :  ((weight_wr8_offm == 0) ? weight_offm : 0);
assign data9 = (bn_rd_ctr == 0) ? data9  :  ((weight_wr9_offm == 0) ? bn_offm : 0);
assign weight_sram_addr =  (weight_rd_ctr == 0) ? weight_addr_ctr : (((weight_wr1_offm == 0)||(weight_wr2_offm == 0)||
(weight_wr3_offm == 0)||(weight_wr4_offm == 0)||(weight_wr5_offm == 0)||(weight_wr6_offm == 0)||(weight_wr7_offm == 0)||
(weight_wr8_offm == 0)) ? weight_addr_offm:0 );
assign bn_sram_addr = (bn_rd_ctr == 0) ? bn_addr_ctr : (((weight_wr9_offm == 0)) ? bn_addr_offm:0 );

weight_sram1 U_WEIGHT_SRAM(
//INPUT
.cs1(weight_sram_cs1),
.cs2(weight_sram_cs2),
.cs3(weight_sram_cs3),
.cs4(weight_sram_cs4),
.cs5(weight_sram_cs5),
.cs6(weight_sram_cs6),
.cs7(weight_sram_cs7),
.cs8(weight_sram_cs8),
.cs9(weight_sram_cs9),
.oe1(weight_rd_ctr),
.oe9(bn_rd_ctr),
.we1(weight_wr1_offm),
.we2(weight_wr2_offm),
.we3(weight_wr3_offm),
.we4(weight_wr4_offm),
.we5(weight_wr5_offm),
.we6(weight_wr6_offm),
.we7(weight_wr7_offm),
.we8(weight_wr8_offm),
.we9(weight_wr9_offm),
.data1(data1),
.data2(data2),
.data3(data3),
.data4(data4),
.data5(data5),
.data6(data6),
.data7(data7),
.data8(data8),
.data9(data9),
.addr1(weight_sram_addr),
.addr2(weight_sram_addr),
.addr3(weight_sram_addr),
.addr4(weight_sram_addr),
.addr5(weight_sram_addr),
.addr6(weight_sram_addr),
.addr7(weight_sram_addr),
.addr8(weight_sram_addr),
.addr9(bn_sram_addr),
.clk(clk)
    );    


assign pre_sram_data1 = (pre_rd1_ctr==0) ?  pre_sram_data1 : ((pre_wr1_offm == 0) ? pre_data_offm :0 );
assign pre_sram_data2 = (pre_rd2_ctr==0) ?  pre_sram_data2 : ((pre_wr1_offm == 0) ? pre_data_offm :0 );


assign pre_sram_cs1 = (pre_rd1_ctr==0) ? pre_en1_ctr : ((pre_wr1_offm==0) ? pre_en1_offm: 1);
assign pre_sram_cs2 = (pre_rd2_ctr==0) ? pre_en2_ctr : ((pre_wr2_offm==0) ? pre_en2_offm: 1);
assign pre_sram_addr = ((pre_rd1_ctr==0)||(pre_rd2_ctr==0) ) ? pre_addr_ctr : (((pre_wr1_offm==0)||(pre_wr2_offm==0)) ? pre_addr_offm: 0);
pre_sram U_PRE_SRAM(
//INPUT
.cs1(pre_sram_cs1),
.cs2(pre_sram_cs2),
.oe1(pre_rd1_ctr),
.oe2(pre_rd2_ctr),
.we1(pre_wr1_offm),
.we2(pre_wr2_offm),
.data1(pre_sram_data1),
.data2(pre_sram_data2),
.addr(pre_sram_addr),
.clk(clk)
//OUTPUT
    );

assign next_sram_cs1 = (next_wr1_ctr==0) ?  next_en1_ctr : ((next_rd1_offm == 0) ?  next_en1_offm : 1);
assign next_sram_cs2 = (next_wr2_ctr==0) ?  next_en2_ctr : ((next_rd1_offm == 0) ?  next_en1_offm : 1);
assign next_sram_data1 = (next_wr1_ctr==0) ?  data_out : ((next_rd1_offm == 0) ?  next_sram_data1 : 0);
assign next_sram_data2 = (next_wr2_ctr==0) ?  data_out : ((next_rd2_offm == 0) ?  next_sram_data2 : 0);
assign next_sram_addr = ((next_wr1_ctr==0)||(next_wr2_ctr == 0)) ? next_addr_ctr : (((next_rd1_offm==0)||(next_rd2_offm==0)) ? next_addr_offm: 0);
next_sram U_NEXT_SRAM(
//INPUT
.cs1(next_sram_cs1),
.cs2(next_sram_cs2),
.oe1(next_rd1_offm),
.oe2(next_rd2_offm),
.we1(next_wr1_ctr),
.we2(next_wr2_ctr),
.data1(next_sram_data1),
.data2(next_sram_data2),
.addr(next_sram_addr),
.clk(clk)
//OUTPUT
    );
    /**有ctr后缀的sram控制信号代表来自于CONTROL_AND_FETCH1模块**/

assign din = (pre_rd1_ctr == 0) ? pre_sram_data1:((pre_rd1_ctr == 0) ?  pre_sram_data2 : 0);
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
         .pre_addr(pre_addr_ctr), //发送给前一级sram的地址
         .pre_sram_en1(pre_en1_ctr),//发送给前一级sram的片选信号
         .pre_sram_en2(pre_en2_ctr),
         .pre_rd1(pre_rd1_ctr),//发送给前一级sram的读使能信号
         .pre_rd2(pre_rd2_ctr),
         .next_sram_en1(next_en1_ctr),//发送给下一级sram的片选信号
         .next_sram_en2(next_en2_ctr),
         .next_wr1(next_wr1_ctr),//发送给下一级sram的写使能
         .next_wr2(next_wr2_ctr),
         .next_addr(next_addr_ctr),//发送给下一级sram的地址信号
         .weights_addr(weight_addr_ctr),//发送给权重sram的地址信号
         .weights_sram_en(weight_en_ctr),//发送给权重sram的片选信号
         .weights_sram_rd(weight_rd_ctr),//发送给权重sram的读使能信号
         .img_request1(img_request1),
         .img_request2(img_request2),
         .calculate_en(calculate_en),
         .asm_send(asm_send),
         .next_sram_full1(next_sram_full1),
         .next_sram_full2(next_sram_full2),
         .bn_addr(bn_addr_ctr),//发送给bn sram的地址
         .bn_rd(bn_rd_ctr),//发送给bn sram的读使能sram
         .bn_en(bn_en_ctr),//发送给bn sram的片选信号
         .asm_choose(asm_choose)
    );

layer1_asm_top LAYER1_ASM_TOP(
//INPUT
.data_weight1(data1),
.data_weight2(data2),
.data_weight3(data3),
.data_weight4(data4),
.data_weight5(data5),
.data_weight6(data6),
.data_weight7(data7),
.data_weight8(data8),
.data_pix(dout),
.data_bn(data9),
.clk(clk),
.rst(rst),
.asm_send(asm_send),
.asm_reception(asm_choose),
.calculate_en(calculate_en),
//OUTPUT
.data_out(data_out)
    );
endmodule
