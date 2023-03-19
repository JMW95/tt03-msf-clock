`default_nettype none

module jmw95_top (
    input  [7:0] io_in,
    output [7:0] io_out
);

wire clk   = io_in[0];
wire reset = io_in[1];

reg  toggle_reg;

assign io_out = { toggle_reg, 7'b0 };

always @(posedge clk) begin
    if (reset) begin
        toggle_reg <= 1'b0;
    end else begin
        toggle_reg <= ~toggle_reg;
    end
end

endmodule
