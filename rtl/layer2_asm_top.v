`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/24 10:15:33
// Design Name: 
// Module Name: layer2_asm_top
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


module layer2_asm_top(
//INPUT
asm_choose,
asm_change,
data_pix1,
data_pix2,
data_pix3,
data_pix4,
data_pix5,
data_pix6,
data_pix7,
data_pix8,
data_weight,//data_weight需要多打一拍
data_bn,//同时存在扇出的问题
calculate_en,
clk,
rst,


//OUTPUT
data_out
    );
input [63:0] asm_choose;
input [63:0] asm_change;
input [1:0]  data_pix1,data_pix2,data_pix3,data_pix4,data_pix5,data_pix6,data_pix7,data_pix8;
input [63:0] data_weight;
input [15:0] data_bn;
input [7:0] calculate_en;
input clk,rst;
output [63:0] data_out;
reg [63:0] weight_buffer ;
reg [15:0] bn_buffer1,bn_buffer2,bn_buffer3,bn_buffer4,bn_buffer5,bn_buffer6,bn_buffer7,bn_buffer8;
always @(posedge clk or negedge rst)
begin
   if(!rst)
       begin
           weight_buffer<=0;
           bn_buffer1<=0;
           bn_buffer2<=0;
           bn_buffer3<=0;
           bn_buffer4<=0;
           bn_buffer5<=0;
           bn_buffer6<=0;
           bn_buffer7<=0;
           bn_buffer8<=0;
       end
    else
       begin
           weight_buffer<=data_weight;//为了打一拍
           bn_buffer1<= data_bn;//为了扇出问题
           bn_buffer2<= data_bn;
           bn_buffer3<= data_bn;
           bn_buffer4<= data_bn;
           bn_buffer5<= data_bn;
           bn_buffer6<= data_bn;
           bn_buffer7<= data_bn;
           bn_buffer8<= data_bn;
       end
end
ASM2 UASM0(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[0]),
.data_bn(bn_buffer1),
.asm_change(asm_change[0]),
.asm_reception(asm_choose[0]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[0])
    );
    ASM2 UASM1(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[1]),
.data_bn(bn_buffer1),
.asm_change(asm_change[1]),
.asm_reception(asm_choose[1]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[1])
    );
    ASM2 UASM2(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[2]),
.data_bn(bn_buffer1),
.asm_change(asm_change[2]),
.asm_reception(asm_choose[2]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[2])
    );
    ASM2 UASM3(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[3]),
.data_bn(bn_buffer1),
.asm_change(asm_change[3]),
.asm_reception(asm_choose[3]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[3])
    );
    ASM2 UASM4(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[4]),
.data_bn(bn_buffer1),
.asm_change(asm_change[4]),
.asm_reception(asm_choose[4]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[4])
    );
    ASM2 UASM5(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[5]),
.data_bn(bn_buffer1),
.asm_change(asm_change[5]),
.asm_reception(asm_choose[5]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[5])
    );
    ASM2 UASM6(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[6]),
.data_bn(bn_buffer1),
.asm_change(asm_change[6]),
.asm_reception(asm_choose[6]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[6])
    );
    ASM2 UASM7(
//INPUT
.data_pix(data_pix1),
.data_weight(weight_buffer[7]),
.data_bn(bn_buffer1),
.asm_change(asm_change[7]),
.asm_reception(asm_choose[7]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[0]),

//OUTPUT 
.data_out(data_out[7])
    );
    
    ASM2 UASM8(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[8]),
.data_bn(bn_buffer2),
.asm_change(asm_change[8]),
.asm_reception(asm_choose[8]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[8])
    );
        ASM2 UASM9(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[9]),
.data_bn(bn_buffer2),
.asm_change(asm_change[9]),
.asm_reception(asm_choose[9]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[9])
    );
        ASM2 UASM10(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[10]),
.data_bn(bn_buffer2),
.asm_change(asm_change[10]),
.asm_reception(asm_choose[10]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[10])
    );
        ASM2 UASM11(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[11]),
.data_bn(bn_buffer2),
.asm_change(asm_change[11]),
.asm_reception(asm_choose[11]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[11])
    );
        ASM2 UASM12(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[12]),
.data_bn(bn_buffer2),
.asm_change(asm_change[12]),
.asm_reception(asm_choose[12]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[12])
    );
        ASM2 UASM13(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[13]),
.data_bn(bn_buffer2),
.asm_change(asm_change[13]),
.asm_reception(asm_choose[13]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[13])
    );
        ASM2 UASM14(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[14]),
.data_bn(bn_buffer2),
.asm_change(asm_change[14]),
.asm_reception(asm_choose[14]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[14])
    );
        ASM2 UASM15(
//INPUT
.data_pix(data_pix2),
.data_weight(weight_buffer[15]),
.data_bn(bn_buffer2),
.asm_change(asm_change[15]),
.asm_reception(asm_choose[15]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[1]),

//OUTPUT 
.data_out(data_out[15])
    );
    
    ASM2 UASM16(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[16]),
.data_bn(bn_buffer3),
.asm_change(asm_change[16]),
.asm_reception(asm_choose[16]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[16])
    );
        ASM2 UASM17(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[17]),
.data_bn(bn_buffer3),
.asm_change(asm_change[17]),
.asm_reception(asm_choose[17]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[17])
    );
        ASM2 UASM18(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[18]),
.data_bn(bn_buffer3),
.asm_change(asm_change[18]),
.asm_reception(asm_choose[18]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[18])
    );
        ASM2 UASM19(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[19]),
.data_bn(bn_buffer3),
.asm_change(asm_change[19]),
.asm_reception(asm_choose[19]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[19])
    );
        ASM2 UASM20(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[20]),
.data_bn(bn_buffer3),
.asm_change(asm_change[20]),
.asm_reception(asm_choose[20]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[20])
    );
        ASM2 UASM21(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[21]),
.data_bn(bn_buffer3),
.asm_change(asm_change[21]),
.asm_reception(asm_choose[21]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[21])
    );
        ASM2 UASM22(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[22]),
.data_bn(bn_buffer3),
.asm_change(asm_change[22]),
.asm_reception(asm_choose[22]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[22])
    );
        ASM2 UASM23(
//INPUT
.data_pix(data_pix3),
.data_weight(weight_buffer[23]),
.data_bn(bn_buffer3),
.asm_change(asm_change[23]),
.asm_reception(asm_choose[23]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[2]),

//OUTPUT 
.data_out(data_out[23])
    );
     ASM2 UASM24(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[24]),
.data_bn(bn_buffer4),
.asm_change(asm_change[24]),
.asm_reception(asm_choose[24]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[24])
    );
         ASM2 UASM25(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[25]),
.data_bn(bn_buffer4),
.asm_change(asm_change[25]),
.asm_reception(asm_choose[25]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[25])
    );
         ASM2 UASM26(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[26]),
.data_bn(bn_buffer4),
.asm_change(asm_change[26]),
.asm_reception(asm_choose[26]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[26])
    );
         ASM2 UASM27(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[27]),
.data_bn(bn_buffer4),
.asm_change(asm_change[27]),
.asm_reception(asm_choose[27]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[27])
    );
         ASM2 UASM28(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[28]),
.data_bn(bn_buffer4),
.asm_change(asm_change[28]),
.asm_reception(asm_choose[28]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[28])
    );
         ASM2 UASM29(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[29]),
.data_bn(bn_buffer4),
.asm_change(asm_change[29]),
.asm_reception(asm_choose[29]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[29])
    );
         ASM2 UASM30(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[30]),
.data_bn(bn_buffer4),
.asm_change(asm_change[30]),
.asm_reception(asm_choose[30]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[30])
    );
         ASM2 UASM31(
//INPUT
.data_pix(data_pix4),
.data_weight(weight_buffer[31]),
.data_bn(bn_buffer4),
.asm_change(asm_change[31]),
.asm_reception(asm_choose[31]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[3]),

//OUTPUT 
.data_out(data_out[31])
    );
             ASM2 UASM32(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[32]),
.data_bn(bn_buffer5),
.asm_change(asm_change[32]),
.asm_reception(asm_choose[32]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[32])
    );
               ASM2 UASM33(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[33]),
.data_bn(bn_buffer5),
.asm_change(asm_change[33]),
.asm_reception(asm_choose[33]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[33])
    );
                 ASM2 UASM34(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[34]),
.data_bn(bn_buffer5),
.asm_change(asm_change[34]),
.asm_reception(asm_choose[34]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[34])
    );
                 ASM2 UASM35(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[35]),
.data_bn(bn_buffer5),
.asm_change(asm_change[35]),
.asm_reception(asm_choose[35]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[35])
    );
                 ASM2 UASM36(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[36]),
.data_bn(bn_buffer5),
.asm_change(asm_change[36]),
.asm_reception(asm_choose[36]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[36])
    );
                 ASM2 UASM37(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[37]),
.data_bn(bn_buffer5),
.asm_change(asm_change[37]),
.asm_reception(asm_choose[37]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[37])
    );
                 ASM2 UASM38(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[38]),
.data_bn(bn_buffer5),
.asm_change(asm_change[38]),
.asm_reception(asm_choose[38]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[38])
    );
                 ASM2 UASM39(
//INPUT
.data_pix(data_pix5),
.data_weight(weight_buffer[39]),
.data_bn(bn_buffer5),
.asm_change(asm_change[39]),
.asm_reception(asm_choose[39]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[4]),

//OUTPUT 
.data_out(data_out[39])
    );        
                     ASM2 UASM40(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[40]),
.data_bn(bn_buffer6),
.asm_change(asm_change[40]),
.asm_reception(asm_choose[40]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[40])
    );      
                         ASM2 UASM41(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[41]),
.data_bn(bn_buffer6),
.asm_change(asm_change[41]),
.asm_reception(asm_choose[41]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[41])
    );   
                         ASM2 UASM42(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[42]),
.data_bn(bn_buffer6),
.asm_change(asm_change[42]),
.asm_reception(asm_choose[42]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[42])
    );   
                         ASM2 UASM43(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[43]),
.data_bn(bn_buffer6),
.asm_change(asm_change[43]),
.asm_reception(asm_choose[43]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[43])
    );   
                         ASM2 UASM44(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[44]),
.data_bn(bn_buffer6),
.asm_change(asm_change[44]),
.asm_reception(asm_choose[44]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[44])
    );   
                         ASM2 UASM45(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[45]),
.data_bn(bn_buffer6),
.asm_change(asm_change[45]),
.asm_reception(asm_choose[45]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[45])
    );   
                         ASM2 UASM46(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[46]),
.data_bn(bn_buffer6),
.asm_change(asm_change[46]),
.asm_reception(asm_choose[46]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[46])
    );   
                         ASM2 UASM47(
//INPUT
.data_pix(data_pix6),
.data_weight(weight_buffer[47]),
.data_bn(bn_buffer6),
.asm_change(asm_change[47]),
.asm_reception(asm_choose[47]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[5]),

//OUTPUT 
.data_out(data_out[47])
    );   
                          ASM2 UASM48(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[48]),
.data_bn(bn_buffer7),
.asm_change(asm_change[48]),
.asm_reception(asm_choose[48]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[48])
    );    
                              ASM2 UASM49(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[49]),
.data_bn(bn_buffer7),
.asm_change(asm_change[49]),
.asm_reception(asm_choose[49]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[49])
    );  
                              ASM2 UASM50(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[50]),
.data_bn(bn_buffer7),
.asm_change(asm_change[50]),
.asm_reception(asm_choose[50]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[50])
    );  
                              ASM2 UASM51(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[51]),
.data_bn(bn_buffer7),
.asm_change(asm_change[51]),
.asm_reception(asm_choose[51]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[51])
    );  
                              ASM2 UASM52(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[52]),
.data_bn(bn_buffer7),
.asm_change(asm_change[52]),
.asm_reception(asm_choose[52]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[52])
    );  
                              ASM2 UASM53(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[53]),
.data_bn(bn_buffer7),
.asm_change(asm_change[53]),
.asm_reception(asm_choose[53]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[53])
    );  
                              ASM2 UASM54(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[54]),
.data_bn(bn_buffer7),
.asm_change(asm_change[54]),
.asm_reception(asm_choose[54]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[54])
    );   
                              ASM2 UASM55(
//INPUT
.data_pix(data_pix7),
.data_weight(weight_buffer[55]),
.data_bn(bn_buffer7),
.asm_change(asm_change[55]),
.asm_reception(asm_choose[55]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[6]),

//OUTPUT 
.data_out(data_out[55])
    );  
                                  ASM2 UASM56(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[56]),
.data_bn(bn_buffer8),
.asm_change(asm_change[56]),
.asm_reception(asm_choose[56]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[56])
    );  
                                      ASM2 UASM57(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[57]),
.data_bn(bn_buffer8),
.asm_change(asm_change[57]),
.asm_reception(asm_choose[57]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[57])
    );  
                                      ASM2 UASM58(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[58]),
.data_bn(bn_buffer8),
.asm_change(asm_change[58]),
.asm_reception(asm_choose[58]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[58])
    );  
                                      ASM2 UASM59(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[59]),
.data_bn(bn_buffer8),
.asm_change(asm_change[59]),
.asm_reception(asm_choose[59]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[59])
    );  
                                      ASM2 UASM60(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[60]),
.data_bn(bn_buffer8),
.asm_change(asm_change[60]),
.asm_reception(asm_choose[60]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[60])
    );  
                                      ASM2 UASM61(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[61]),
.data_bn(bn_buffer8),
.asm_change(asm_change[61]),
.asm_reception(asm_choose[61]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[61])
    );  
                                      ASM2 UASM62(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[62]),
.data_bn(bn_buffer8),
.asm_change(asm_change[62]),
.asm_reception(asm_choose[62]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[62])
    );  
                                      ASM2 UASM63(
//INPUT
.data_pix(data_pix8),
.data_weight(weight_buffer[63]),
.data_bn(bn_buffer8),
.asm_change(asm_change[63]),
.asm_reception(asm_choose[63]),
.clk(clk),
.rst(rst),
.calculate_en(calculate_en[7]),

//OUTPUT 
.data_out(data_out[63])
    );  
     
endmodule
