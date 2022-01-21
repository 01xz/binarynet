`timescale 1ns / 10ps

module control_and_fetch1_tb;
  localparam IMG_WIDTH  = 16;
  localparam ADDR_WIDTH = 10;

  reg clk;
  reg rst_n;
  reg pre_sram_full1;
  reg pre_sram_full2;
  reg next_sram_empty1;
  reg next_sram_empty2;

  wire [IMG_WIDTH - 1:0] din;
  wire [IMG_WIDTH - 1:0] sdout1;
  wire [IMG_WIDTH - 1:0] sdout2;

  wire        img_request1;
  wire        img_request2;
  wire        calculate_en;
  wire [9:0]  pre_addr;
  wire        pre_sram_en1;
  wire        pre_sram_en2;
  wire        pre_rd1;
  wire        pre_rd2;
  wire        next_sram_en1;
  wire        next_sram_en2;
  wire        next_wr1;
  wire        next_wr2;
  wire [13:0] next_addr;
  wire [8:0]  weights_addr;
  wire [7:0]  weights_sram_en;
  wire [7:0]  weights_sram_rd;
  wire [7:0]  asm_send;
  wire        next_sram_full1;
  wire        next_sram_full2;
  wire [6:0]  bn_addr;
  wire        bn_rd;
  wire        bn_en;
  wire [7:0]  asm_choose;
  wire [IMG_WIDTH - 1:0] dout;

  initial begin
    clk              = 1'b1;
    rst_n            = 1'b0;
    pre_sram_full1   = 1'b1;
    pre_sram_full2   = 1'b1;
    next_sram_empty1 = 1'b1;
    next_sram_empty2 = 1'b1;
  end

  always #10 clk = ~clk;

  initial begin
    repeat (1) @(posedge clk);
      rst_n <= 1'b1;
    repeat (1000000) @(posedge clk);
      $finish;
  end

  initial begin
    $dumpfile("control_and_fetch1_tb.vcd");
    $dumpvars(0, control_and_fetch1_tb);
  end

  CONTROL_AND_FETCH1 #(
    .img_width (IMG_WIDTH)
  ) dut (
    // INPUT PIN
    .clk             (clk),
    .rst             (rst_n),
    .din             (din),
    .pre_sram_full1  (pre_sram_full1),
    .pre_sram_full2  (pre_sram_full2),
    .next_sram_empty1(next_sram_empty1),
    .next_sram_empty2(next_sram_empty2),
    // OUTPUT PIN
    .dout            (dout),
    .pre_addr        (pre_addr),
    .pre_sram_en1    (pre_sram_en1),
    .pre_sram_en2    (pre_sram_en2),
    .pre_rd1         (pre_rd1),
    .pre_rd2         (pre_rd2),
    .next_sram_en1   (next_sram_en1),
    .next_sram_en2   (next_sram_en2),
    .next_wr1        (next_wr1),
    .next_wr2        (next_wr2),
    .next_addr       (next_addr),
    .weights_addr    (weights_addr),
    .weights_sram_en (weights_sram_en),
    .weights_sram_rd (weights_sram_rd),
    .img_request1    (img_request1),
    .img_request2    (img_request2),
    .calculate_en    (calculate_en),
    .asm_send        (asm_send),
    .next_sram_full1 (next_sram_full1),
    .next_sram_full2 (next_sram_full2),
    .bn_addr         (bn_addr),
    .bn_rd           (bn_rd),
    .bn_en           (bn_en),
    .asm_choose      (asm_choose)
  );
  
  sram_sim #(
    .DW(IMG_WIDTH),
    .AW(ADDR_WIDTH)
  ) u_sram_sim1 (
    .clk (clk),
    .cs  (pre_sram_en1),
    .oe  (pre_rd1),
    .we  (1'b1),
    .addr(pre_addr),
    .data(sdout1)
  );

  sram_sim #(
    .DW(IMG_WIDTH),
    .AW(ADDR_WIDTH)
  ) u_sram_sim2 (
    .clk (clk),
    .cs  (pre_sram_en2),
    .oe  (pre_rd2),
    .we  (1'b1),
    .addr(pre_addr),
    .data(sdout2)
  );

  assign din = (pre_rd1 == 0) ? sdout1 : ((pre_rd2 == 0) ? sdout2 : 0);

endmodule
