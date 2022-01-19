`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/10 22:07:13
// Design Name: 
// Module Name: control_and_fetch1
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


module CONTROL_AND_FETCH1(
         //INPUT
         clk,
         rst,
         din,//��sram�ж�ȡ������
         pre_sram_full1,//ǰһ��sram��������ź�
         pre_sram_full2,
         next_sram_empty1,
         next_sram_empty2,//��һ����sram�������Ϊ�յ�ʱ����Ϊ������2Ƭsram��ʱ���ã�����������
         //OUTPUT
         dout,//����ȡ����������������״̬��֮��
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
         weights_addr,//Ȩ�ص�ַ
         weights_sram_en,//Ȩ��Ƭѡ
         weights_sram_rd,//Ȩ�ض�ʹ��
         img_request1,//������һ��ͼ֮����ISPģ�鷢��ͼ������
         img_request2,
         calculate_en,//��״̬�����Ϳ��Կ�ʼ������ź�
         asm_send,//����źſ���״̬����sram���ͼ���õ�����
         next_sram_full1,//�������֮�������һ����sram�Ѿ����������Կ�ʼ����
         next_sram_full2,
         bn_addr,//bn�洢���ĵ�ַ
         bn_rd,//��ʹ��
         bn_en,//Ƭѡ
         asm_choose//�����������뵽��һƪ״̬��
    );
    
//*******************
//DEFINE PARAMETER
//*******************
//Parameter(s)
parameter img_width=16;//ͼ���λ��
parameter IDLE = 5'b00001,READY1 = 5'b00010 , READ_AND_SEND1 = 5'b00100, READY2 =5'b01000 ,READ_AND_SEND2 = 5'b10000;

//*******************
//DEFINE INPUT
//*******************
input clk,rst;
input [img_width-1:0] din;
input pre_sram_full1,pre_sram_full2,next_sram_empty1,next_sram_empty2;


//*******************
//DEFINE OUTPUT
//*******************
output  [img_width-1:0] dout;
output  reg  img_request1,img_request2,calculate_en;
output  [9:0] pre_addr;//10λ��ַ��
output  reg  pre_sram_en1;//ǰһ��Ƭѡ
output  reg  pre_sram_en2;//ǰһ��Ƭѡ
output  reg  pre_rd1;//ǰһ����ʹ��
output  reg  pre_rd2;
output  reg  next_sram_en1;//��һ��Ƭѡ
output  reg  next_sram_en2;
output  reg   next_wr1;//��һ��дʹ��
output  reg   next_wr2;
output  reg [13:0]      next_addr;//�������һ����ַ��14λ��ַ��
output  reg [8:0]       weights_addr;//9λ��ַ��
output  reg [7:0]       weights_sram_en;
output  reg [7:0]       weights_sram_rd;
output  [7:0] asm_send;
output reg next_sram_full1;
output reg next_sram_full2;
output reg [6:0] bn_addr;
output reg bn_rd;
output reg bn_en;
output reg [7:0] asm_choose;


//*********************
//INNER SIGNAL DECLARATION
//*********************
//REGS
reg [4:0] state;//5λ��״̬���ź�
reg [4:0] nextstate;
reg [9:0] count0;//�������������ģ��ÿ��3x3����������λ�ã�������������ͼ
reg [1:0] count1;//�����������������3����Ϊ��һ�������������ͨ��
reg [3:0] count2;//�����������������9����Ϊÿ��������9����
reg [3:0] count3;//�����������������16����Ϊһ���а˸�����ˣ�128/8=16������ʮ���ν�ÿһ��ͨ���ĵ�һ�������
reg [3:0] count4;//���ڼ�����8����bn sram��ȡ�˸���
reg signed [10:0] pre_addr_buffer;//�����ǰһ���Ķ���ַ�źţ�����һλ����λ
reg signed [10:0] pre_addr_buffer1;//���ڴ�һ�ģ���Ӧ�����ݺ͵�ַ��һ������
reg [7:0] asm_send1;
reg [7:0] asm_send2;//���ڴ����ĵļĴ���
reg [7:0] asm_send3;
reg [13:0] next_addr_buffer;
reg lock;//���źţ�����һ��ͼ֮��Ѽ�������ס���������������
reg one_image_finish1;//һ��ͼƬ���������ı�־�ź�
reg one_image_finish2;
reg en_delay1 ,en_delay2,en_delay3,en_delay4;//���������ؼ��
reg start_read_bn;
reg [8:0] weights_addr_buffer;//������
reg [6:0] bn_addr_buffer; 
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
          if(one_image_finish1)
             nextstate = READY2;
          else
             nextstate = READ_AND_SEND1;
        end
   READY2:begin
        nextstate = READ_AND_SEND2;
   end
   READ_AND_SEND2:begin
         if(one_image_finish2)
            nextstate = READY1;
         else
            nextstate = READ_AND_SEND2;
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
        pre_sram_en1<=1;
        pre_sram_en2<=1;  
        pre_rd1<=1;
        pre_rd2<=1;
        next_sram_en1<=1;
        next_sram_en2<=1; 
        next_wr1<=1;
        next_wr2<=1;
        next_addr<=0;
        weights_addr<=0;
        weights_sram_en<=1;
        weights_sram_rd<=1;
        count0<=0;
        count1<=0;
        count2<=0;
        count3<=0;
        pre_addr_buffer<=0;
        pre_addr_buffer1<=0;
        asm_send1<=0;
        asm_send2<=0;
        asm_send3<=0;
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
        weights_addr_buffer<=0;
        bn_addr_buffer<=0;
     end//ssss
  else if(state==READY1)
      begin
             calculate_en<=1'b0;
             pre_sram_en2<=1'b1;
             pre_rd2<=1'b1;
             pre_addr_buffer<=0;
             next_sram_en2<=1'b1;
             next_wr2<=1'b1;
             next_addr<=14'b0;  
             weights_addr<=9'b0;
             weights_sram_en<=8'b1;
             weights_sram_rd<=8'b1;
             lock<=0;
             one_image_finish2<=0;
             asm_send1<=0;
             asm_send2<=0;
             asm_send3<=0;
             next_addr_buffer<=0;
             pre_addr_buffer1<=0;
             bn_addr<=0;
             bn_en<=1;
             bn_rd<=1;
             weights_addr_buffer<=0;
             bn_addr_buffer<=0;
      end
  else if(state==READ_AND_SEND1)//�����ݣ����㣬���������Ƭsram�еĵ�һƬ�������ݣ�ԴԴ���ϵ�����㵥Ԫ�������ݣ��������Ƕ�����ͼ��ͬʱҲ�Ƕ�Ȩ�أ�������ͼ��Ȩ��ƥ��
      begin//aaaa
          if((pre_sram_full1==1'b1) && (next_sram_empty1==1'b1))
             begin//789a
                 calculate_en<=1'b1;
                 pre_rd1<=1'b0;
                 pre_sram_en1<=1'b0;
                 weights_sram_en<=8'b0;
                 weights_sram_rd<=8'b0;
          if(!lock)
             begin//asd
                 if(count1==2)
                     begin//aaas
                         count1<=0;
                         if(count2==8)
                             begin
                                 count2<=0;
                                 asm_send1<=8'b11111111;
                                 if(count3==15)
                                     begin
                                        count3<=0;
                                        if(count0==1023)
                                              begin
                                                  count0<=0;
                                                  lock<=1;
                                              end
                                         else
                                              count0<=count0+1;
                                     end
                                 else
                                        count3<=count3+1;
                             end
                         else 
                                 count2<=count2+1;
                     end//aaas
                 else  begin count1<=count1+1; asm_send1<=8'b00000000; end
                 
                 if(count2==0) begin  pre_addr_buffer<=count0-33; start_read_bn<=1;     end  //����ߴ���32x32��pre_addr_buffer���з�������count0���޷�������ȷ��һ���������ɲ����ԣ�ע���������һ��
                 if(count2==1) begin  pre_addr_buffer<=count0-32;      end
                 if(count2==2) begin  pre_addr_buffer<=count0-31;      end
                 if(count2==3) begin  pre_addr_buffer<=count0-1;       end
                 if(count2==4) begin  pre_addr_buffer<=count0;         end
                 if(count2==5) begin  pre_addr_buffer<=count0+1;       end
                 if(count2==6) begin  pre_addr_buffer<=count0+31;      end
                 if(count2==7) begin  pre_addr_buffer<=count0+32;      end
                 if(count2==8) begin  pre_addr_buffer<=count0+33;      end
             end//asd 
                 
                 asm_send2<=asm_send1;//�����źŴ�һ��
                 //asm_send3<=asm_send2;
                 
                 if(asm_send2 == 8'b11111111)//�൱�ڴ��˶���
                     begin
                         next_addr<=next_addr_buffer;
                         next_addr_buffer<=next_addr_buffer+1;
                         next_sram_en1<=0;
                         next_wr1<=0;
                         if(lock==1)
                          one_image_finish1<=1;
                     end
                 else   //����֮�����Ͻ�sram�ر�����д��ȥ���������
                     begin
                         next_sram_en1<=1;
                         next_wr1<=1;
                     end
                 
                 if(!lock) begin
                 if(start_read_bn)
                     begin
                         if(count4==8)
                             begin
                                 count4<=0;
                                 start_read_bn<=0;
                                 bn_rd<=1;
                                 bn_en<=1;
                                 asm_choose<=0;
                             end
                          else
                              begin
                                  count4<=count4+1;
                                  bn_en<=0;
                                  if(bn_addr==127)
                                   bn_addr<=0;
                                  else
                                  begin
                                  bn_addr_buffer<=bn_addr_buffer+1;
                                  bn_addr<=bn_addr_buffer;
                                  end
                              end
                          
                          if(count4==1) begin asm_choose<=8'b00000001; end
                          if(count4==2) begin asm_choose<=8'b00000010; end
                          if(count4==3) begin asm_choose<=8'b00000100; end
                          if(count4==4) begin asm_choose<=8'b00001000; end
                          if(count4==5) begin asm_choose<=8'b00010000; end
                          if(count4==6) begin asm_choose<=8'b00100000; end
                          if(count4==7) begin asm_choose<=8'b01000000; end
                          if(count4==8) begin asm_choose<=8'b10000000; end
                     end
                    end

                 pre_addr_buffer1<=pre_addr_buffer;//��һ��
                 
                 if(!lock)begin
                 if((count1==2) && (count2==8) && (count3==15))
                     weights_addr<=0;
                 else
                    begin
                     weights_addr_buffer<=weights_addr_buffer+1;     
                     weights_addr<=weights_addr_buffer;
                    end
                 end    
             end//789a
      end//aaaa
  else if(state==READY2)
      begin
             calculate_en<=1'b0;
             pre_sram_en1<=1'b1;
             pre_rd1<=1'b1;
             pre_addr_buffer<=0;
             next_sram_en1<=1'b1;
             next_wr1<=1'b1;
             next_addr<=14'b0;  
             weights_addr<=9'b0;
             weights_addr_buffer<=0;
             weights_sram_en<=8'b1;
             weights_sram_rd<=8'b1;
             lock<=0;
             one_image_finish1<=0;
             asm_send1<=0;
             asm_send2<=0;
             asm_send3<=0;
             next_addr_buffer<=0;
             pre_addr_buffer1<=0;
             bn_addr_buffer<=0;
      end
  else if(state==READ_AND_SEND2)
      begin//llll
      if((pre_sram_full2==1'b1) && (next_sram_empty2==1'b1))
             begin//789a
                 calculate_en<=1'b1;
                 pre_rd2<=1'b0;
                 pre_sram_en2<=1'b0;
                 weights_sram_en<=8'b0;
                 weights_sram_rd<=8'b0;
          if(!lock)
             begin//asd
                 if(count1==2)
                     begin//aaas
                         count1<=0;
                         if(count2==8)
                             begin
                                 count2<=0;
                                 asm_send1<=8'b11111111;
                                 if(count3==15)
                                     begin
                                        count3<=0;
                                        if(count0==1023)
                                              begin
                                                  count0<=0;
                                                  lock<=1;
                                              end
                                         else
                                              count0<=count0+1;
                                     end
                                 else
                                        count3<=count3+1;
                             end
                         else 
                                 count2<=count2+1;
                     end//aaas
                 else  begin count1<=count1+1; asm_send1<=8'b00000000; end
                 
                 if(count2==0) begin  pre_addr_buffer<=count0-33; start_read_bn<=1;      end  //����ߴ���32x32��pre_addr_buffer���з�������count0���޷�������ȷ��һ���������ɲ����ԣ�ע���������һ��
                 if(count2==1) begin  pre_addr_buffer<=count0-32;      end
                 if(count2==2) begin  pre_addr_buffer<=count0-31;      end
                 if(count2==3) begin  pre_addr_buffer<=count0-1;       end
                 if(count2==4) begin  pre_addr_buffer<=count0;         end
                 if(count2==5) begin  pre_addr_buffer<=count0+1;       end
                 if(count2==6) begin  pre_addr_buffer<=count0+31;      end
                 if(count2==7) begin  pre_addr_buffer<=count0+32;      end
                 if(count2==8) begin  pre_addr_buffer<=count0+33;      end
                 
             end//asd 
                 
                 asm_send2<=asm_send1;//�����źŴ�1��
                 //asm_send3<=asm_send2;
                 
                 if(asm_send2== 8'b11111111)//�൱�ڴ���2��
                     begin
                         next_addr<=next_addr_buffer;
                         next_addr_buffer<=next_addr_buffer+1;
                         next_sram_en2<=0;
                         next_wr2<=0;
                         if(lock==1)
                          one_image_finish2<=1;
                     end
                 else   //����֮�����Ͻ�sram�ر�����д��ȥ���������
                     begin
                         next_sram_en2<=1;
                         next_wr2<=1;
                     end
                 

                if(!lock)begin
                  if(start_read_bn)
                     begin
                         if(count4==8)
                             begin
                                 count4<=0;
                                 start_read_bn<=0;
                                 bn_rd<=1;
                                 bn_en<=1;
                                 asm_choose<=0;
                             end
                          else
                              begin
                                  count4<=count4+1;
                                  bn_en<=0;
                                  if(bn_addr==127)
                                   bn_addr<=0;
                                  else
                                  begin
                                  bn_addr_buffer<=bn_addr_buffer+1;
                                  bn_addr<=bn_addr_buffer;
                                  end
                              end
                          
                          if(count4==1) begin asm_choose<=8'b00000001; end
                          if(count4==2) begin asm_choose<=8'b00000010; end
                          if(count4==3) begin asm_choose<=8'b00000100; end
                          if(count4==4) begin asm_choose<=8'b00001000; end
                          if(count4==5) begin asm_choose<=8'b00010000; end
                          if(count4==6) begin asm_choose<=8'b00100000; end
                          if(count4==7) begin asm_choose<=8'b01000000; end
                          if(count4==8) begin asm_choose<=8'b10000000; end
                     end
                    end
                 
                 pre_addr_buffer1<=pre_addr_buffer;//��һ��
                 
                 if(!lock)begin
                 if((count1==2) && (count2==8) && (count3==15))
                     weights_addr<=0;
                 else
                     begin
                      weights_addr_buffer<=weights_addr_buffer+1;  
                      weights_addr<=weights_addr_buffer; 
                     end  
                 end    
             end//789a
      end//llll

end//xxxx

//��ǰ��������ˮ�ߵ�����ģ��
always@(posedge clk or negedge rst)
begin//xxxx
if(!rst)
    begin
        img_request1<=1;img_request2<=1;
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
                img_request1<=1;
            end
            
        en_delay1<=next_sram_empty1;
        if((en_delay1==0) && (next_sram_empty1))
            next_sram_full1<=0;
            
        en_delay2<=pre_sram_full1;    //�����ؼ�����Ƿ��������⣬�Ƿ���������̬��
        if((en_delay1==0) && (pre_sram_full1))
            img_request1<=0;
            
        if(one_image_finish2)
            begin
                next_sram_full2<=1;
                img_request2<=1;
            end
            
        en_delay3<=next_sram_empty2;
        if((en_delay3==0) && (next_sram_empty2))
            next_sram_full2<=0;
            
        en_delay4<=pre_sram_full2;    
        if((en_delay4==0) && (pre_sram_full2))
            img_request2<=0;
    end
end//xxxx

assign dout = ((pre_addr_buffer1<0)|| (pre_addr_buffer1>1023)) ? 0 : din;//�����߽�Ĳ�������㣬Ϊpadding�Ĳ���,����Ϊ��sram��ȡ������
assign pre_addr = pre_addr_buffer[9:0];    //�;�λ��ôд�Ƿ���ȷ��ȥ������λ
assign asm_send = asm_send2;
    
    
    
    
    
endmodule
