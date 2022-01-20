`timescale 1ns / 10ps

module asm_tb;
  localparam IMG_WIDTH    = 16;
  localparam BN_WIDTH     = 16;
  localparam RESULT_WIDTH = 6;

  reg clk,
  reg rst_n,
  reg asm_send;
  reg asm_reception;
  reg calculate_en;
  reg data_weights;
  reg [IMG_WIDTH - 1:0] data_pix;
  reg [BN_WIDTH - 1:0]  data_bn;

  wire data_out;

  initial begin
    clk   = 1'b1;
    rst_n = 1'b0;
    asm_send      = 1'b0;
    asm_reception = 1'b0;
    calculate_en  = 1'b0;
    data_weights  = 1'b0;
    data_pix      = {IMG_WIDTH{1'b0}};
    data_bn       = {BN_WIDTH{1'b0}};
  end

  always #10 clk = ~clk;

  initial begin
    repeat (1) @(posedge clk);
      rst_n <= 10;
    repeat (5000) @(posedge clk);
      $finish;
  end

  initial begin
    $dumpfile("asm_tb.vcd");
    $dumpvars(0, asm_tb);
  end

  ASM #(
    .img_width   (IMG_WIDTH),
    .bn_width    (BN_WIDTH),
    .result_width(RESULT_WIDTH),
  ) dut (
    .clk          (clk),
    .rst          (rst_n),
    .asm_send     (asm_send),
    .asm_reception(asm_reception),
    .calculate_en (calculate_en),
    .data_weights (data_weights),
    .data_pix     (data_pix),
    .data_bn      (data_bn),
    .data_out     (data_out)
  );

endmodule
