`default_nettype none

module shift_reg #(
    parameter WIDTH = 48
) (
    input               clk_i,
    input               rst_i,

    input               start_i,
    input [WIDTH - 1:0] data_i,

    output              sclk_o,
    output              data_o,
    output              latch_o
);

localparam COUNT_WIDTH = $clog2(WIDTH);

reg                     data_reg;
reg                     sclk_reg;
reg                     idle_reg;
reg                     latch_reg;
reg [COUNT_WIDTH - 1:0] count_reg;

wire data_next;

assign sclk_o  = sclk_reg;
assign data_o  = data_reg;
assign latch_o = latch_reg;

assign data_next = data_i[count_reg];

always @(posedge clk_i) begin
    if (rst_i) begin
        data_reg  <= 1'b0;
        sclk_reg  <= 1'b1;
        idle_reg  <= 1'b1;
        latch_reg <= 1'b0;
    end else if (start_i) begin
        idle_reg  <= 1'b0;
        latch_reg <= 1'b0;
        count_reg <= COUNT_WIDTH'(WIDTH - 1);
    end else if (!idle_reg) begin
        if (sclk_reg == 1'b1) begin
            sclk_reg <= 1'b0;
            data_reg <= data_next;
        end else begin
            sclk_reg  <= 1'b1;
            count_reg <= count_reg - COUNT_WIDTH'(1);
            idle_reg  <= count_reg == 0;
        end
    end else begin
        latch_reg <= 1'b1;
    end
end

endmodule
