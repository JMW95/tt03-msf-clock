`default_nettype none

module second_counter (
    input clk_i,
    input rst_i,

    output second_inc_o
);

`define SECOND_FULL 10'd1000 // 1 second

reg [9:0] count_reg;

assign second_inc_o = count_reg == 0;

always @(posedge clk_i) begin
    // Decrement counter
    count_reg <= count_reg - 1;
    if (count_reg == 0) begin
        count_reg <= (`SECOND_FULL - 1);
    end

    // Reset
    if (rst_i) begin
        count_reg <= (`SECOND_FULL - 1);
    end
end

endmodule
