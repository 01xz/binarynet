`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/25 14:37:13
// Design Name: 
// Module Name: ASM3
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


module ASM3(
     //INPUT
     data_pix,//���������ֵ
     data_weight,//�����Ȩ��ֵ
     data_bn,//����bnϵ��
     asm_send,//���Ƽ���õ�ֵ���뵽��һ����sram��ȥ
     asm_reception,//���ƽ���bn��ֵ
     clk,
     rst,
     calculate_en,//״̬���ļ���ʹ��
     //OUTPUT
     data_out//�������һ��������ͼ��ֵ
    );
 //*******************
//DEFINE PARAMETER
//*******************
//Parameter(s)

parameter img_width = 16;
parameter bn_width = 16;
parameter IDLE = 2'b01,CALCULATE = 2'b10;
parameter result_width = 11;

//*******************
//DEFINE INPUT
//*******************
input [1:0] data_pix;
input data_weight;
input [bn_width-1:0] data_bn;
input asm_send;
input asm_reception;
input clk,rst;
input calculate_en;
//*******************
//DEFINE OUTPUT
//*******************
output data_out;

//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
reg [1:0] state;//5λ��״̬���ź�
reg [1:0] nextstate;
reg pingpong_flag;//��������ı�־
reg signed [bn_width-1:0] bn_coefficient;
reg signed [result_width:0] result1,result2;

//WIRES
wire signed [1:0] result; 

 always@(posedge clk or negedge rst)
 begin//xxxx
   if(!rst)
           state<=IDLE;
   else 
           state<=nextstate;
 end//xxxx   

always@(*)
begin
case(state)
IDLE:begin
         if(calculate_en)
             nextstate = CALCULATE;
         else
             nextstate = IDLE; 
     end
CALCULATE:
     begin
        if(!calculate_en)
            nextstate = IDLE;
        else
            nextstate = CALCULATE;
     end
default:
     begin
         nextstate = IDLE ;
     end
endcase
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
        begin
                  pingpong_flag<=0;
                  bn_coefficient<=0;
                  result1<=0;
                  result2<=0;
        end
    else
        begin
            if(state == IDLE)
               begin
                  pingpong_flag<=0;
                  bn_coefficient<=0;
                  result1<=0;
                  result2<=0;
               end
            else if(state == CALCULATE)
                begin
                    if(!pingpong_flag)
                        begin
                            result1<=result1+result;
                            if(asm_send) begin pingpong_flag <= 1;result2<=0;   end
                        end
                     else 
                         begin
                             result2 <= result2 + result;
                             if(asm_send) begin pingpong_flag<=0; result1<=0;   end
                         end
                    if(asm_reception)  bn_coefficient <= data_bn;
                end
        end
end

assign result = (data_pix==2'b10)?0:((data_weight^data_pix[0]==1)?  -1 :1);
assign data_out = (pingpong_flag==0) ? ((result2 > bn_coefficient) ? 1:0) : ((result1 > bn_coefficient) ? 1:0);

endmodule


