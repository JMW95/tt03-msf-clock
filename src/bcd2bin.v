module bcd2bin
  ( output reg [6:0] bin,  // binary
    input      [7:0] bcd); // bcd {tens,ones}

  wire [3:0] high = bcd[7:4];
  wire [3:0] low = bcd[3:0];

  always @(*) begin
    // high * 8 + high * 2 + low
    bin = (7'(high) << 3) + (7'(high) << 1) + 7'(low);
  end

endmodule
