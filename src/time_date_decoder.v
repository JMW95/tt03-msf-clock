`default_nettype none

module time_date_decoder (
    input clk_i,
    input rst_i,

    // Decoded input
    input       bits_valid_i,
    input       bits_is_second_00_i, // Indicates second 00 within the minute
    input [1:0] bits_data_i,         // The two data bits for this second: { B, A }

    // Date output
    output [3:0] year_h_o,
    output [3:0] year_l_o,
    output       month_h_o,
    output [3:0] month_l_o,
    output [1:0] day_h_o,
    output [3:0] day_l_o,
    output [2:0] dow_o,

    // Time output
    output [1:0] hour_h_o,
    output [3:0] hour_l_o,
    output [2:0] minute_h_o,
    output [3:0] minute_l_o,

    output valid_o
);

reg [59:17] a_shift_reg;
reg [59:54] b_shift_reg;

wire parity_54b = b_shift_reg[54] ^ (^a_shift_reg[24:17]);
wire parity_55b = b_shift_reg[55] ^ (^a_shift_reg[35:25]);
wire parity_56b = b_shift_reg[56] ^ (^a_shift_reg[38:36]);
wire parity_57b = b_shift_reg[57] ^ (^a_shift_reg[51:39]);
wire top_of_minute = a_shift_reg[59:52] == 8'b01111110;
wire parity_valid = parity_54b & parity_55b & parity_56b & parity_57b & top_of_minute;

function [3:0] swap4(input [3:0] a);
    swap4[0] = a[3];
    swap4[1] = a[2];
    swap4[2] = a[1];
    swap4[3] = a[0];
endfunction

function [2:0] swap3(input [2:0] a);
    swap3[0] = a[2];
    swap3[1] = a[1];
    swap3[2] = a[0];
endfunction

function [1:0] swap2(input [1:0] a);
    swap2[0] = a[1];
    swap2[1] = a[0];
endfunction

assign year_h_o = swap4(a_shift_reg[20:17]);
assign year_l_o = swap4(a_shift_reg[24:21]);
assign month_h_o = a_shift_reg[25];
assign month_l_o = swap4(a_shift_reg[29:26]);
assign day_h_o = swap2(a_shift_reg[31:30]);
assign day_l_o = swap4(a_shift_reg[35:32]);
assign dow_o = swap3(a_shift_reg[38:36]);
assign hour_h_o = swap2(a_shift_reg[40:39]);
assign hour_l_o = swap4(a_shift_reg[44:41]);
assign minute_h_o = swap3(a_shift_reg[47:45]);
assign minute_l_o = swap4(a_shift_reg[51:48]);
assign valid_o = parity_valid && bits_is_second_00_i && bits_valid_i;

always @(posedge clk_i) begin
    // Shift data in
    if (bits_valid_i) begin
        a_shift_reg <= { bits_data_i[0], a_shift_reg[59:18] };
        b_shift_reg <= { bits_data_i[1], b_shift_reg[59:55] };
    end

    // Reset
    if (rst_i) begin
        a_shift_reg <= 0;
        b_shift_reg <= 0;
    end
end

endmodule
