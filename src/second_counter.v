`default_nettype none

module second_counter #(
    parameter CLK_FREQ = 12500
) (
    input clk_i,
    input rst_i,

    output second_inc_o
);

localparam WIDTH = $clog2(CLK_FREQ);

reg [WIDTH-1:0] count_reg;

assign second_inc_o = count_reg == 0;

always @(posedge clk_i) begin
    // Decrement counter
    count_reg <= count_reg - 1;
    if (count_reg == 0) begin
        count_reg <= (CLK_FREQ - 1);
    end

    // Reset
    if (rst_i) begin
        count_reg <= (CLK_FREQ - 1);
    end
end

endmodule
