module sram_sim #(
  parameter DW = 8,
  parameter AW = 4
) (
  input clk,
  input cs,
  input oe,
  input we,
  input [AW - 1:0] addr,
  inout [DW - 1:0] data
);

  localparam DP = 1 << AW;

  reg [DW - 1:0] mem[0:DP - 1];
  reg [DW - 1:0] reg_d;

  initial $readmemh("mem.txt", mem);

  always @(posedge clk) begin
    if (!cs & !we) begin
      mem[addr] <= data;
    end
  end
  
  always @(posedge clk) begin
    if (!cs & we & !oe) begin
      reg_d <= mem[addr];
    end
  end

  assign data = (!cs & we & !oe) ? reg_d : {DW{1'bz}};

endmodule
