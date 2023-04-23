`default_nettype none

module time_date_shift #(
    parameter WIDTH = 6 * 7
) (
    input shift_i,
    input [WIDTH-1:0] data_i,
    output reg [WIDTH-1:0] data_o
);

always @(*) begin
    if (shift_i) begin
        data_o = {data_i[WIDTH/2 - 1:0], data_i[WIDTH-1:WIDTH/2]};
    end else begin
        data_o = data_i;
    end
end

endmodule
