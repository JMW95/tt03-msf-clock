`default_nettype none

module bit_sampler #(
    parameter CLK_FREQ = 12500
) (
    input clk_i,
    input rst_i,

    input data_i,

    output bit_o,
    output valid_o
);

localparam COUNT_HALF = CLK_FREQ / 20; // Half-bit period
localparam COUNT_FULL = CLK_FREQ / 10; // Full-bit period
localparam WIDTH = $clog2(COUNT_FULL);

reg [WIDTH-1:0] count_reg;
reg       last_data_reg;

reg valid_reg;
reg bit_reg;

assign bit_o = bit_reg;
assign valid_o = valid_reg;

always @(posedge clk_i) begin
    valid_reg <= 0;

    // Decrement counter and sample at 0
    count_reg <= count_reg - 1;
    if (count_reg == 0) begin
        count_reg <= WIDTH'(COUNT_FULL);
        bit_reg <= data_i;
        valid_reg <= 1;
    end

    // Reset counter to half-bit on each input edge
    if (data_i != last_data_reg) begin
        count_reg <= WIDTH'(COUNT_HALF);
    end
    last_data_reg <= data_i;

    // Reset
    if (rst_i) begin
        count_reg <= WIDTH'(COUNT_HALF);
        bit_reg <= 0;
        valid_reg <= 0;
    end
end

endmodule
