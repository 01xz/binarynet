`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/25 09:54:21
// Design Name: 
// Module Name: control_and_fetch3
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


module CONTROL_AND_FETCH3(
         //INPUT
         clk,
         rst,
         din,//��sram�ж�ȡ������
         pre_sram_full1,//ǰһ��sram��������ź�
         pre_sram_full2,
         next_sram_empty1,
         next_sram_empty2,//��һ����sram�������Ϊ�յ�ʱ����Ϊ������2Ƭsram��ʱ���ã�����������
         //OUTPUT
         dout1,dout2,dout3,dout4,//����ȡ����������������״̬��֮��
         pre_addr,//�����ǰһ���Ķ���ַ�ź�
         pre_sram_en1,//ǰһ��Ƭѡ,Ϊ��ʱ��Ч
         pre_sram_en2,
         pre_rd1,//ǰһ����ʹ�ܣ�Ϊ��ʱ��Ч
         pre_rd2,
         next_sram_en1,//��һ��Ƭѡ����һ������һ����4Ƭsram����ƬΪһ��
         next_sram_en2,
         next_wr1,//��һ��дʹ��
         next_wr2,
         next_addr,//�������һ����ַ
         weights_addr1,//Ȩ�ص�ַ
         weights_sram_en1,//Ȩ��Ƭѡ
         weights_sram_rd1,//Ȩ�ض�ʹ��
         weights_addr2,
         weights_sram_en2,
         weights_sram_rd2,
         weights_addr3,
         weights_sram_en3,
         weights_sram_rd3,
         pre_sram_empty1,//������һ��ͼ֮����ISPģ�鷢��ͼ������
         pre_sram_empty2,
         calculate_en,//��״̬�����Ϳ��Կ�ʼ������ź�
         asm_change,//����źſ���״̬������״̬
         next_sram_full1,//�������֮�������һ����sram�Ѿ����������Կ�ʼ����
         next_sram_full2,
         bn_addr,//bn�洢���ĵ�ַ
         bn_rd,//��ʹ��
         bn_en,//Ƭѡ
         asm_choose//�����������뵽��һƬ״̬��
    );
    
//*******************
//DEFINE PARAMETER
//*******************
//Parameter(s)
parameter img_width=64;//ǰһ������ͼ��λ��
parameter IDLE = 3'b001,READY1 = 3'b010 , READ_AND_SEND1 = 3'b100;

//*******************
//DEFINE INPUT
//*******************
input clk,rst;
input [img_width-1:0] din;
input pre_sram_full1,pre_sram_full2,next_sram_empty1,next_sram_empty2;

//*******************
//DEFINE OUTPUT
//*******************
output  [1:0]  dout1,dout2,dout3,dout4;//Ϊ����ȳ�����
output  reg  pre_sram_empty1,pre_sram_empty2;
output reg [3:0] calculate_en;
output  [8:0] pre_addr;//13λ��ַ��
output  reg  pre_sram_en1;//ǰһ��Ƭѡ
output  reg  pre_sram_en2;//ǰһ��Ƭѡ
output  reg  pre_rd1;//ǰһ����ʹ��
output  reg  pre_rd2;
output  reg  next_sram_en1;//��һ��Ƭѡ
output  reg  next_sram_en2;
output  reg   next_wr1;//��һ��дʹ��
output  reg   next_wr2;
output  reg [10:0]      next_addr;//�������һ����ַ��9λ��ַ��
output  reg [11:0]       weights_addr1;//11λ��ַ�� 2048, ����memory compilerֻ������128������sram������Ȩ����Ҫ��Ƭƴ�ӣ�2048+256��*64
output  reg        weights_sram_en1;
output  reg        weights_sram_rd1;
output  reg [11:0]       weights_addr2;//8λ��ַ�� 256
output  reg        weights_sram_en2;
output  reg        weights_sram_rd2;
output  reg [9:0]       weights_addr3;//8λ��ַ�� 256
output  reg        weights_sram_en3;
output  reg        weights_sram_rd3;
output  [31:0] asm_change;
output reg next_sram_full1;
output reg next_sram_full2;
output reg [7:0] bn_addr;
output reg bn_rd;
output reg bn_en;
output reg [31:0] asm_choose;


//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
reg [2:0] state;//3λ��״̬���ź�
reg [2:0] nextstate;
reg [7:0] count0; //ģ���һ��ͨ���������ĵĵ�ַ  
reg [5:0] count1;
reg  count2;
reg [3:0] count3;
reg [2:0] count4;
reg [5:0] count5;
reg signed [10:0] pre_addr_buffer;//�����ǰһ���Ķ���ַ�źţ�����һλ����λ
reg signed [10:0] pre_addr_buffer1;//���ڴ�һ�ģ���Ӧ�����ݺ͵�ַ��һ������
reg signed [10:0] pre_addr_buffer2;//�����ȳ������⣬��ַ�źű���һ�����һ��
reg [31:0] asm_send1;
reg [31:0] asm_send2;//���ڴ����ĵļĴ���
reg [31:0] asm_send3;
reg [31:0] asm_send4;
reg [10:0] next_addr_buffer;
reg lock;//���źţ�����һ��ͼ֮��Ѽ�������ס���������������
reg one_image_finish1;//һ��ͼƬ���������ı�־�ź�
reg one_image_finish2;
reg en_delay1,en_delay2,en_delay3,en_delay4;//���������ؼ��
reg start_read_bn;

reg [11:0] weights_addr_buffer;
reg [11:0]weights_addr_buffer2;
reg [9:0]weights_addr_buffer3;//������

reg [7:0] bn_addr_buffer; 
reg [7:0] boundary_judgment1,boundary_judgment2;
reg [31:0] asm_choose_buffer,asm_choose_buffer1;
reg [5:0] count1_buffer1,count1_buffer2,count1_buffer3;
reg [3:0] calculate_en_buffer;
reg [63:0] din_buffer1,din_buffer2,din_buffer3,din_buffer4;
reg flag;
//WIRES

//��һ��״̬��
 always@(posedge clk or negedge rst)
 begin//xxxx
   if(!rst)
           state<=IDLE;
   else 
           state<=nextstate;
 end//xxxx   

//�ڶ���״̬��
always@(*)
begin//xxxx
   case(state)
   IDLE:begin
         if(pre_sram_full1)
           nextstate=READY1;
         else 
           nextstate=IDLE;
        end
   READY1:begin
        nextstate = READ_AND_SEND1;
   end
   READ_AND_SEND1:begin
          if((one_image_finish1==1)||(one_image_finish2 == 1))
             nextstate = READY1;
          else
             nextstate = READ_AND_SEND1;
        end
   default:begin
       nextstate=IDLE;
   end
   endcase
end//xxxx

//������״̬��
always@(posedge clk or negedge rst)
begin//xxxx
  if(!rst)
     begin//ssss
        calculate_en<=0;
        calculate_en_buffer<=0;
        pre_sram_en1<=1;
        pre_sram_en2<=1;  
        pre_rd1<=1;
        pre_rd2<=1;
        next_sram_en1<=1;
        next_sram_en2<=1; 
        next_wr1<=1;
        next_wr2<=1;
        next_addr<=0;
        weights_addr1<=0;
        weights_sram_en1<=1;
        weights_sram_rd1<=1;
        weights_addr2<=0;
        weights_sram_en2<=1;
        weights_sram_rd2<=1;
        weights_addr3<=0;
        weights_sram_en3<=1;
        weights_sram_rd3<=1;
        count0<=0;
        count1<=0;
        count2<=0;
        count3<=0;
        count4<=0;
        count5<=0;
        pre_addr_buffer<=0;
        pre_addr_buffer1<=0;
        pre_addr_buffer2<=0;
        asm_send1<=0;
        asm_send2<=0;
        asm_send3<=0;
        asm_send4<=0;
        next_addr_buffer<=0;
        lock<=0;
        one_image_finish1<=0;
        one_image_finish2<=0;
        en_delay1<=0;
        en_delay2<=0;
        en_delay3<=0;
        en_delay4<=0;
        bn_addr<=0;
        bn_en<=1;
        bn_rd<=1;
        asm_choose<=0;
        asm_choose_buffer<=0;
        asm_choose_buffer1<=0;
        weights_addr_buffer<=0;
        weights_addr_buffer2<=0;
        weights_addr_buffer3<=0;
        bn_addr_buffer<=0;
        start_read_bn<=0;
        boundary_judgment1<=0;
        boundary_judgment2<=15;
        din_buffer1<=0;din_buffer2<=0;din_buffer3<=0;din_buffer4<=0;
        count1_buffer1<=0;count1_buffer2<=0;count1_buffer3<=0;
        flag<=1;
     end//ssss
  else if(state==READY1)
      begin
             calculate_en<=0;
             calculate_en_buffer<=0;
             pre_sram_en2<=1;pre_sram_en1<=1;
             pre_rd2<=1;pre_rd1<=1;
             pre_addr_buffer<=0;
             next_sram_en2<=1;next_sram_en1<=0;
             next_wr2<=1;next_wr1<=0;
             next_addr<=0;  
             weights_addr1<=0;weights_addr2<=0;weights_addr3<=0;
             weights_sram_en1<=1;weights_sram_en2<=1;weights_sram_en2<=1;
             weights_sram_rd1<=1;weights_sram_rd2<=1;weights_sram_rd2<=1;
             lock<=0;
             one_image_finish2<=0;one_image_finish1<=0;
             asm_send1<=0;
             asm_send2<=0;
             asm_send3<=0;
             asm_send4<=0;
             next_addr_buffer<=0;
             pre_addr_buffer1<=0;
             pre_addr_buffer2<=0;
             bn_addr<=0;
             bn_en<=1;
             bn_rd<=1;
             weights_addr_buffer<=0;
             weights_addr_buffer2<=0;
             weights_addr_buffer3<=0;
             bn_addr_buffer<=0;
             boundary_judgment1<=0;
             boundary_judgment2<=15;
             flag<=~flag;
             start_read_bn<=0;
             din_buffer1<=0;din_buffer2<=0;din_buffer3<=0;din_buffer4<=0;
             asm_choose_buffer<=32'h00000001;
             asm_choose_buffer1<=0;
      end
  else if(state==READ_AND_SEND1)//�����ݣ����㣬���������Ƭsram�еĵ�һƬ�������ݣ�ԴԴ���ϵ�����㵥Ԫ�������ݣ��������Ƕ�����ͼ��ͬʱҲ�Ƕ�Ȩ�أ�������ͼ��Ȩ��ƥ��
      begin//aaaa
          if(((pre_sram_full1==1'b1) && (next_sram_empty1==1'b1) && (flag == 0)) || ((pre_sram_full2==1'b1) && (next_sram_empty2==1'b1) && (flag == 1)))
             begin//789a
                 calculate_en_buffer<=4'b1111;
                 calculate_en<=calculate_en_buffer;
                 if(flag==0)
                     begin
                        pre_rd1<=1'b0;
                        pre_sram_en1<=1'b0;
                     end
                  else
                      begin
                          pre_rd2<=0;
                          pre_sram_en2<=0;
                      end
                 if(!lock)
                     begin//fffff
                        if(count1 == 63)
                            begin
                                count1 <= 0;
                                if(count2 == 1)
                                    begin
                                        count2<=0;
                                        if(count3 == 8)
                                            begin
                                               count3<=0;
                                               asm_send1<=32'hffffffff;
                                               if(count4 == 7)
                                                   begin
                                                       count4<=0;
                                                       if(count0 == 255)
                                                           begin
                                                              count0<=0;
                                                              lock<=1;
                                                           end
                                                       else
                                                           begin
                                                               count0<=count0+1;
                                                           end
                                                   end
                                                else
                                                    begin
                                                        count4<=count4+1;
                                                    end
                                            end
                                         else
                                            begin
                                                count3<=count3+1;
                                            end
                                    end
                                 else
                                    begin
                                        count2<=count2+1;
                                    end  
                            end
                        else
                            begin
                                count1<=count1+1;asm_send1<=0;
                            end
                            
                      if((count1 == 63) && (count2 == 1) && (count3 == 8) && (count4 == 7) && (count0 == boundary_judgment1))   
                       boundary_judgment1<=boundary_judgment1+16; 
                      if((count1 == 63) && (count2 == 1) && (count3 == 8) && (count4 == 7) && (count0 == boundary_judgment2)) 
                       boundary_judgment2<=boundary_judgment2+16; 
                       if(count1 == 0)begin//4554
                         if(count2==0)begin//xxtt
                          if(count3 == 0)begin
                                 start_read_bn<=1;
                                 if(count0 == boundary_judgment1) pre_addr_buffer<=-1; else pre_addr_buffer<=count0-17;   
                           end
                          if(count3==1) begin  pre_addr_buffer<=count0-16;      end
                          if(count3 == 2)begin
                              if(count0 == boundary_judgment2)  pre_addr_buffer<=-1;  else pre_addr_buffer<=count0-15;
                          end
                          if(count3 == 3)begin
                              if(count0 == boundary_judgment1) pre_addr_buffer<=-1; else pre_addr_buffer<=count0-1;
                          end
                          if(count3==4) begin  pre_addr_buffer<=count0;         end
                          if(count3 == 5)begin
                              if(count0 == boundary_judgment2) pre_addr_buffer<=-1; else  pre_addr_buffer<=count0+1;
                          end
                          if(count3 == 6)begin
                              if(count0==boundary_judgment1) pre_addr_buffer<=-1;  else pre_addr_buffer<=count0+15; 
                          end
                          if(count3 == 7) begin  pre_addr_buffer<=count0+16;      end
                          if(count3 == 8)begin
                              if(count0 == boundary_judgment2) pre_addr_buffer<=-1;  else pre_addr_buffer<=count0+17; 
                          end
                         end//xxtt
                        else begin  if((pre_addr_buffer < 0)||(pre_addr_buffer>255))
                                                 pre_addr_buffer<=-1;
                                     else 
                                                 pre_addr_buffer<=pre_addr_buffer+256;
                              end
                      
                      end//4554
                     end//fffff
               else begin asm_send1<=0; end
                     
               if(!lock)begin
                  if(start_read_bn)
                     begin
                         if(count5==32)
                             begin
                                 count5<=0;
                                 start_read_bn<=0;
                                 bn_rd<=1;
                                 bn_en<=1; //��ʹ�ܹرյ�ͬʱ�����ݴ��ڵ�����
                             end
                          else
                              begin
                                  count5<=count5+1;
                                  bn_en<=0;
                                  
                                  if(bn_addr_buffer == 255)
                                  bn_addr_buffer<=0;
                                  else
                                  bn_addr_buffer<=bn_addr_buffer+1;
                                  bn_addr<=bn_addr_buffer;
                              end
                      asm_choose_buffer <=   asm_choose_buffer<<1;  
                      asm_choose_buffer1<=asm_choose_buffer;
                      asm_choose<=asm_choose_buffer1;                              
                     end
                      else asm_choose<=0; 
                    end     
                    
              asm_send2<=asm_send1;
              asm_send3<=asm_send2;//�����źŴ����ģ�����ASM�ļ���״̬
              asm_send4<=asm_send3;
              
              if(asm_send4[0] == 1) //�����Ľ�����õ����ݴ���,
                begin
                         next_addr<=next_addr_buffer;
                         next_addr_buffer<=next_addr_buffer+1;
                         if(flag==0)
                             begin
                                next_sram_en1<=0;
                                next_wr1<=0;
                              end
                         else
                             begin
                                 next_sram_en2<=0;
                                 next_wr2<=0;
                             end
                        if(lock==1)
                          begin
                            if(flag == 0)
                                one_image_finish1<=1;
                            else
                                one_image_finish2<=1;
                          end
                end
              else
                begin
                         next_sram_en1<=1;
                         next_wr1<=1;
                         next_sram_en2<=1;
                         next_wr2<=1;
                end
                
             count1_buffer1<=count1;//��count1=0��ʱ���𷢳���ַ����������ڣ����ݴ���din_buffer֮�У���ʼ��������
             count1_buffer2<=count1_buffer1;
             count1_buffer3<=count1_buffer2;
             
             din_buffer1 <= din; //���ֻ��Ҫ�ĸ�buffer
             din_buffer2 <= din;
             din_buffer3 <= din;
             din_buffer4 <= din;

             
             pre_addr_buffer1<=pre_addr_buffer;
             pre_addr_buffer2<=pre_addr_buffer1;//��ַ������
             
             if(!lock)  //Ȩ�ص�sram����4096+4096+1024ƴ��һ���
                begin//asdqwe
                    if((count1 == 63) && (count2 == 1) && (count3 == 8) && (count4 == 7) )
                        begin
                           weights_addr_buffer<=0;
                           weights_addr_buffer2<=0;
                           weights_addr_buffer3<=0;
                        end
                   else
                       begin
                       if((weights_addr_buffer == 4096)&&(weights_addr_buffer2 == 4096))
                          begin
                              weights_addr_buffer3<=weights_addr_buffer3+1;
                              weights_sram_en1<=1;
                              weights_sram_rd1<=1;
                              weights_sram_en2<=1;
                              weights_sram_rd2<=1;
                              weights_sram_en3<=0;
                              weights_sram_rd3<=0;
                          end
                       else if(weights_addr_buffer == 4096)
                         begin
                             weights_addr_buffer2<=weights_addr_buffer2+1;
                             weights_sram_en1<=1;
                              weights_sram_rd1<=1;
                              weights_sram_en2<=0;
                              weights_sram_rd2<=0;
                              weights_sram_en3<=1;
                              weights_sram_rd3<=1;
                         end
                       else
                           begin
                              weights_addr_buffer<=weights_addr_buffer+1;
                              weights_sram_en1<=0;
                              weights_sram_rd1<=0;
                              weights_sram_en2<=1;
                              weights_sram_rd2<=1;
                              weights_sram_en3<=1;
                              weights_sram_rd3<=1;
                           end
                           weights_sram_en1<=0;
                           weights_sram_rd1<=0;
                       end
                       weights_addr1<=weights_addr_buffer;
                       weights_addr2<=weights_addr_buffer2;
                       weights_addr3<=weights_addr_buffer3;
                end//asdwqe
             end//789a
      end//aaaa

end//xxxx

//��ǰ��������ˮ�ߵ�����ģ��
always@(posedge clk or negedge rst)
begin//xxxx
if(!rst)
    begin
        pre_sram_empty1<=1;pre_sram_empty2<=1;
        next_sram_full1<=0;
        next_sram_full2<=0;
        en_delay1<=0;
        en_delay2<=0;
        en_delay3<=0;
        en_delay4<=0;
    end
else
    begin
        if(one_image_finish1)
            begin
                next_sram_full1<=1;
                pre_sram_empty1<=1;
            end
            
        en_delay1<=next_sram_empty1;
        if((en_delay1==0) && (next_sram_empty1))
            next_sram_full1<=0;
            
        en_delay2<=pre_sram_full1;    //�����ؼ�����Ƿ��������⣬�Ƿ���������̬��
        if((en_delay1==0) && (pre_sram_full1))
            pre_sram_empty1<=0;
            
        if(one_image_finish2)
            begin
                next_sram_full2<=1;
                pre_sram_empty2<=1;
            end
            
        en_delay3<=next_sram_empty2;
        if((en_delay3==0) && (next_sram_empty2))
            next_sram_full2<=0;
            
        en_delay4<=pre_sram_full2;    
        if((en_delay4==0) && (pre_sram_full2))
            pre_sram_empty2<=0;
    end
end//xxxx

//assign dout = ((pre_addr_buffer1<0)|| (pre_addr_buffer1>1023)) ? 0 : din;//�����߽�Ĳ�������㣬Ϊpadding�Ĳ���,����Ϊ��sram��ȡ������
assign pre_addr = pre_addr_buffer[8:0];    
assign asm_change =asm_send3;

assign dout1 = ((pre_addr_buffer2<0)|| (pre_addr_buffer2>255)) ? 2'b10 :{1'b0,din_buffer1[count1_buffer3]};    
assign dout2 = ((pre_addr_buffer2<0)|| (pre_addr_buffer2>255)) ? 2'b10 :{1'b0,din_buffer2[count1_buffer3]}; 
assign dout3 = ((pre_addr_buffer2<0)|| (pre_addr_buffer2>255)) ? 2'b10 :{1'b0,din_buffer3[count1_buffer3]}; 
assign dout4 = ((pre_addr_buffer2<0)|| (pre_addr_buffer2>255)) ? 2'b10 :{1'b0,din_buffer4[count1_buffer3]}; 
    
endmodule


