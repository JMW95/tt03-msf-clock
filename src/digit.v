module digit #(
    parameter MAX = 9,
    parameter MAX2 = MAX,
    parameter WIDTH = $clog2(MAX + 1)
)(
    input                clk_i,
    input                rst_i,

    output [WIDTH - 1:0] digit_o,

    output               at_max_o,
    input                at_max_i,

    input                inc_i,
    output               ovf_o,

    input                load_i,
    input  [WIDTH - 1:0] load_value_i
);

//-- Registers ---------------------------------------------------------------

reg [WIDTH - 1:0] digit_reg, digit_next;

//-- Internal signals --------------------------------------------------------

wire at_max_1;
wire at_max_2;
reg  ovf;

//-- Logic -------------------------------------------------------------------

assign digit_o = digit_reg;
assign ovf_o   = inc_i && ovf;

assign at_max_1 = digit_reg == MAX;
assign at_max_2 = at_max_i && digit_reg == MAX2;
assign at_max_o = at_max_1;

always @(*) begin
    if (at_max_1 || at_max_2) begin
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
