`default_nettype none

module counter #(
    parameter WIDTH = 6
)(
    input                clk_i,
    input                rst_i,

    input  [WIDTH - 1:0] min_i,
    input  [WIDTH - 1:0] max_i,

    output [WIDTH - 1:0] value_o,

    input                inc_i,
    output               ovf_o,

    input                load_i,
    input  [WIDTH - 1:0] load_value_i
);

//-- Registers ---------------------------------------------------------------

reg [WIDTH - 1:0] value_reg, value_next;

//-- Internal signals --------------------------------------------------------

reg  ovf;

//-- Logic -------------------------------------------------------------------

assign value_o = value_reg;
assign ovf_o   = inc_i && ovf;

always @(*) begin
    if (value_reg == max_i) begin
        value_next = min_i;
        ovf = 1;
    end else begin
        value_next = value_reg + 1;
        ovf = 0;
    end
end

always @(posedge clk_i) begin
    if (rst_i) begin
        value_reg <= min_i;
    end else if (load_i) begin
        value_reg <= load_value_i;
    end else if (inc_i) begin
        value_reg <= value_next;
    end
end

endmodule
