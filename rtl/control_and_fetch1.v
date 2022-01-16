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
         din,//从sram中读取的数据
         pre_sram_full1,//前一级sram载入完成信号
         pre_sram_full2,
         next_sram_empty1,
         next_sram_empty2,//后一级的sram计算完成为空的时候，因为后面有2片sram分时复用，所以有两个
         //OUTPUT
         dout,//将读取到的数据输出到多个状态机之中
         pre_addr,//输出到前一级的读地址信号
         pre_sram_en1,//前一级片选,为零时有效
         pre_sram_en2,
         pre_rd1,//前一级读使能，为零时有效
         pre_rd2,
         next_sram_en1,//后一级片选，这一级后面一共有4片sram，两片为一组
         next_sram_en2,
         next_wr1,//后一级写使能
         next_wr2,
         next_addr,//输出到后一级地址
         weights_addr,//权重地址
         weights_sram_en,//权重片选
         weights_sram_rd,//权重读使能
         img_request1,//计算完一幅图之后向ISP模块发送图像请求
         img_request2,
         calculate_en,//向状态机发送可以开始计算的信号
         asm_send,//这个信号控制状态机向sram发送计算好的数据
         next_sram_full1,//计算完成之后告诉下一级的sram已经载满，可以开始计算
         next_sram_full2,
         bn_addr,//bn存储器的地址
         bn_rd,//读使能
         bn_en,//片选
         asm_choose//控制数据输入到哪一篇状态机
    );
    
//*******************
//DEFINE PARAMETER
//*******************
//Parameter(s)
parameter img_width=16;//图像的位宽
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
output  [9:0] pre_addr;//10位地址线
output  reg  pre_sram_en1;//前一级片选
output  reg  pre_sram_en2;//前一级片选
output  reg  pre_rd1;//前一级读使能
output  reg  pre_rd2;
output  reg  next_sram_en1;//后一级片选
output  reg  next_sram_en2;
output  reg   next_wr1;//后一级写使能
output  reg   next_wr2;
output  reg [13:0]      next_addr;//输出到后一级地址，14位地址线
output  reg [8:0]       weights_addr;//9位地址线
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
reg [4:0] state;//5位的状态机信号
reg [4:0] nextstate;
reg [9:0] count0;//这个计数器用于模拟每个3x3滑窗的中心位置，划过整个特征图
reg [1:0] count1;//这个计数器用于数到3，因为第一层的输入有三个通道
reg [3:0] count2;//这个计数器用于数到9，以为每个滑窗有9个数
reg [3:0] count3;//这个计数器用于数到16，因为一共有八个计算核，128/8=16，计算十六次将每一个通道的第一个数算出
reg [3:0] count4;//用于计数到8，从bn sram中取八个数
reg signed [10:0] pre_addr_buffer;//输出到前一级的读地址信号，多了一位符号位
reg signed [10:0] pre_addr_buffer1;//用于打一拍，对应的数据和地址差一个周期
reg [7:0] asm_send1;
reg [7:0] asm_send2;//用于打两拍的寄存器
reg [7:0] asm_send3;
reg [13:0] next_addr_buffer;
reg lock;//锁信号，算完一张图之后把计数器锁住，不让其继续计数
reg one_image_finish1;//一幅图片计算结束后的标志信号
reg one_image_finish2;
reg en_delay1 ,en_delay2,en_delay3,en_delay4;//用于上升沿检测
reg start_read_bn;
reg [8:0] weights_addr_buffer;//打拍用
reg [6:0] bn_addr_buffer; 
//WIRES

//第一段状态机
 always@(posedge clk or negedge rst)
 begin//xxxx
   if(!rst)
           state<=IDLE;
   else 
           state<=nextstate;
 end//xxxx   

//第二段状态机
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

//第三段状态机
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
  else if(state==READ_AND_SEND1)//读数据，计算，并向后面两片sram中的第一片发送数据，源源不断的向计算单元发送数据，不仅仅是读特征图，同时也是读权重，让特征图与权重匹配
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
                 
                 if(count2==0) begin  pre_addr_buffer<=count0-33; start_read_bn<=1;     end  //输入尺寸是32x32，pre_addr_buffer是有符号数，count0是无符号数，确认一下这样做可不可以，注意这里打了一拍
                 if(count2==1) begin  pre_addr_buffer<=count0-32;      end
                 if(count2==2) begin  pre_addr_buffer<=count0-31;      end
                 if(count2==3) begin  pre_addr_buffer<=count0-1;       end
                 if(count2==4) begin  pre_addr_buffer<=count0;         end
                 if(count2==5) begin  pre_addr_buffer<=count0+1;       end
                 if(count2==6) begin  pre_addr_buffer<=count0+31;      end
                 if(count2==7) begin  pre_addr_buffer<=count0+32;      end
                 if(count2==8) begin  pre_addr_buffer<=count0+33;      end
             end//asd 
                 
                 asm_send2<=asm_send1;//发送信号打两拍
                 asm_send3<=asm_send2;
                 
                 if(asm_send3== 8'b11111111)//相当于打了三拍
                     begin
                         next_addr<=next_addr_buffer;
                         next_addr_buffer<=next_addr_buffer+1;
                         next_sram_en1<=0;
                         next_wr1<=0;
                         if(lock==1)
                          one_image_finish1<=1;
                     end
                 else   //用完之后马上将sram关闭以免写进去错误的数据
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

                 pre_addr_buffer1<=pre_addr_buffer;//打一拍
                 
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
                 
                 if(count2==0) begin  pre_addr_buffer<=count0-33; start_read_bn<=1;      end  //输入尺寸是32x32，pre_addr_buffer是有符号数，count0是无符号数，确认一下这样做可不可以，注意这里打了一拍
                 if(count2==1) begin  pre_addr_buffer<=count0-32;      end
                 if(count2==2) begin  pre_addr_buffer<=count0-31;      end
                 if(count2==3) begin  pre_addr_buffer<=count0-1;       end
                 if(count2==4) begin  pre_addr_buffer<=count0;         end
                 if(count2==5) begin  pre_addr_buffer<=count0+1;       end
                 if(count2==6) begin  pre_addr_buffer<=count0+31;      end
                 if(count2==7) begin  pre_addr_buffer<=count0+32;      end
                 if(count2==8) begin  pre_addr_buffer<=count0+33;      end
                 
             end//asd 
                 
                 asm_send2<=asm_send1;//发送信号打两拍
                 asm_send3<=asm_send2;
                 
                 if(asm_send3== 8'b11111111)//相当于打了三拍
                     begin
                         next_addr<=next_addr_buffer;
                         next_addr_buffer<=next_addr_buffer+1;
                         next_sram_en2<=0;
                         next_wr2<=0;
                         if(lock==1)
                          one_image_finish2<=1;
                     end
                 else   //用完之后马上将sram关闭以免写进去错误的数据
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
                 
                 pre_addr_buffer1<=pre_addr_buffer;//打一拍
                 
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

//与前后两级流水线的握手模块
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
            
        en_delay2<=pre_sram_full1;    //上升沿检测后端是否会出现问题，是否会产生亚稳态？
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

assign dout = ((pre_addr_buffer1<0)|| (pre_addr_buffer1>1023)) ? 0 : din;//超出边界的部分输出零，为padding的部分,否则为从sram中取出的数
assign pre_addr = pre_addr_buffer[9:0];    //低九位这么写是否正确，去掉符号位
assign asm_send = asm_send3;
    
    
    
    
    
endmodule
