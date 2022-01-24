`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/23 18:50:34
// Design Name: 
// Module Name: ASM2
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


module ASM2(
//INPUT
data_pix,
data_weight,
data_bn,
asm_change,
asm_reception,
clk,
rst,
calculate_en,

//OUTPUT 
data_out
    );

parameter bn_width = 16;
parameter IDLE = 5'b001,CALCULATE = 5'b010;//需要有四种计算状态
parameter CALCULATE1 = 4'b0001,CALCULATE2 = 4'b0010,CALCULATE3 = 4'b0100,CALCULATE4 = 4'b1000;
parameter result_width = 11;


input  data_pix;
input data_weight;
input [bn_width-1:0] data_bn;
input asm_change;
input asm_reception;
input clk,rst;
input calculate_en;

output data_out;

reg [2:0] state1;//5位的状态机信号
reg [2:0] nextstate1;
reg [3:0] state2;
reg [3:0] nextstate2;
reg pingpong_flag;//交替运算的标志
reg signed [bn_width-1:0] bn_coefficient;
reg signed [result_width:0] result1,result2,result3,result4,result5;

//WIRES
wire signed [1:0] result; 
 always@(posedge clk or negedge rst)
 begin//xxxx
   if(!rst)
           state1<=IDLE;
   else 
           state1<=nextstate1;
 end//xxxx  
 
  always@(posedge clk or negedge rst)
 begin//xxxx
   if(!rst)
           state2<=CALCULATE1;
   else 
           state2<=nextstate2;
 end//xxxx  
always@(*)
begin
case(state1)
IDLE:begin
         if(calculate_en)
             nextstate1 = CALCULATE;
         else
             nextstate1 = IDLE; 
     end
CALCULATE:
     begin
        if(!calculate_en)
            nextstate1 = IDLE;
        else
            nextstate1 = CALCULATE;
     end
default:
     begin
         nextstate1 = IDLE ;
     end
endcase
end

always@(*)
begin
case(state2)
CALCULATE1:begin
         if(asm_change == 1)
             nextstate2 = CALCULATE2;
         else
             nextstate2 = CALCULATE1 ; 
     end
CALCULATE2:
     begin
        if(asm_change == 1)
            nextstate2 = CALCULATE3;
        else
            nextstate2 = CALCULATE2;
     end
CALCULATE3:
     begin
        if(asm_change == 64'hffffffffffffffff)
            nextstate2 = CALCULATE4;
        else
            nextstate2 = CALCULATE3;
     end
CALCULATE4:
     begin
        if(asm_change == 1)
            nextstate2 = CALCULATE1;
        else
            nextstate2 = CALCULATE4;
     end
default:
     begin
         nextstate2 = CALCULATE1 ;
     end
endcase
end

always @(posedge clk or negedge rst)
begin
    if(!rst)
        begin
             pingpong_flag<=0;//交替运算的标志
             bn_coefficient<=0;
             result1<=0;
             result2<=0;   
             result3<=0;
             result4<=0;
             result5<=0;
        end
    else
        begin
             if(state1 == IDLE)
                 begin
                  pingpong_flag<=0;
                  bn_coefficient<=0;
                  result1<=0;
                  result2<=0;
                 end
             else if(state1 == CALCULATE)
                 begin
                    if(state2 == CALCULATE1)
                        begin
                            result1<=result1+result;
                            result2<=0;
                            if(asm_reception)  bn_coefficient<=data_bn; //在第一个计算状态把所有的bn接受完毕
                        end
                    else if(state2 == CALCULATE2)
                       begin
                           result2<=result2+result;
                           result3<=0;
                       end
                    else if(state2 == CALCULATE3)
                        begin
                            result3<=result3+result;
                            result4<=0;
                            result5<=0;
                        end
                    else if(state2 == CALCULATE4)
                         begin
                            if((result1>=result2)&&(result1>=result3)) begin result5<=result1;result1<=0;end
                            if((result2>=result1)&&(result2>=result3)) begin result5<=result2;result1<=0;end
                            if((result3>=result2)&&(result3>=result1)) begin result5<=result3;result1<=0;end//最大池化
                            result4 <= result4+result;
                         end
                 end
        end
end
assign result = (data_weight^data_pix) ? 1:-1;
assign data_out = (result4>=result5) ? ((result4 > bn_coefficient)?1:0) : ((result5 > bn_coefficient)?1:0);
endmodule
