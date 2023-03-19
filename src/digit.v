module digit #(
    parameter MAX = 9,
    parameter WIDTH = $clog2(MAX + 1)
)(
    input                clk_i,
    input                rst_i,

    output [WIDTH - 1:0] digit_o,

    input                inc_i,
    output               ovf_o,

    input                load_i,
    input  [WIDTH - 1:0] load_value_i
);

//-- Registers ---------------------------------------------------------------

reg [WIDTH - 1:0] digit_reg, digit_next;

//-- Internal signals --------------------------------------------------------

reg ovf;

//-- Logic -------------------------------------------------------------------

assign digit_o = digit_reg;
assign ovf_o   = inc_i && ovf;

always @(*) begin
    if (digit_reg == MAX) begin
        digit_next = 0;
        ovf = 1;
    end else begin
        digit_next = digit_reg + 1;
        ovf = 0;
    end
end

always @(posedge clk_i) begin
    if (rst_i) begin
        digit_reg <= 0;
    end else if (load_i) begin
        digit_reg <= load_value_i;
    end else if (inc_i) begin
        digit_reg <= digit_next;
    end
end

endmodule
