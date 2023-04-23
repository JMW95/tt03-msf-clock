`default_nettype none

module time_date_shift #(
    parameter WIDTH = 6 * 7
) (
    input shift_i,
    input [WIDTH-1:0] data_i,
    output [WIDTH-1:0] data_o
);

assign data_o = shift_i ? {data_i[WIDTH/2 - 1:0], data_i[WIDTH-1:WIDTH/2]} : data_i;

endmodule
