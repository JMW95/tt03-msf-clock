`default_nettype none

module pulse_delay #(
    parameter DELAY = 1
) (
    input clk_i,
    input rst_i,

    input data_i,
    output data_o
);

reg [DELAY:0] state_reg;
assign data_o = state_reg[DELAY];

always @(posedge clk_i) begin
    state_reg <= {state_reg[DELAY-1:0], data_i};

    // Reset
    if (rst_i) begin
        state_reg <= 0;
    end
end

endmodule
