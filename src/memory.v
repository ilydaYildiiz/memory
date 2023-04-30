module dual_port_sync_ram (
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 16,
  parameter DEPTH = 16
)(
  input clk,
  input [ADDR_WIDTH-1:0] addr1,
  input [ADDR_WIDTH-1:0] addr2,
  inout [DATA_WIDTH-1:0] data1,
  inout [DATA_WIDTH-1:0] data2,
  input cs1,
  input cs2,
  input we1,
  input we2,
  input oe1,
  input oe2
);

  reg [DATA_WIDTH-1:0] tmp_data1;
  reg [DATA_WIDTH-1:0] tmp_data2;
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  always @(posedge clk) begin
    if (cs1 & we1)
      mem[addr1] <= data1;
    if (cs2 & we2)
      mem[addr2] <= data2;
  end

  always @(negedge clk) begin
    if (cs1 & !we1)
        tmp_data1 <= mem[addr1];
    if (cs2 & !we2)
        tmp_data2 <= mem[addr2];
  end

  assign data1 = cs1 & oe1 & !we1 ? tmp_data1 : 'hz;
  assign data2 = cs2 & oe2 & !we2 ? tmp_data2 : 'hz;

endmodule