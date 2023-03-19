`default_nettype none
`timescale 1ns/1ps

// testbench is controlled by test.py
module tb (
    input clk_i,
    input rst_i,

    // Decoded input
    input       bits_valid_i,
    input       bits_is_second_00_i,
    input [1:0] bits_data_i,

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

initial begin
    $dumpfile ("tb.vcd");
    $dumpvars (0, tb);
    #1;
end

// instantiate the DUT
time_date_decoder time_date_decoder(
    .clk_i(clk_i),
    .rst_i(rst_i),

    // Decoded input
    .bits_valid_i(bits_valid_i),
    .bits_is_second_00_i(bits_is_second_00_i),
    .bits_data_i(bits_data_i),

    // Date output
    .year_h_o(year_h_o),
    .year_l_o(year_l_o),
    .month_h_o(month_h_o),
    .month_l_o(month_l_o),
    .day_h_o(day_h_o),
    .day_l_o(day_l_o),
    .dow_o(dow_o),

    // Time output
    .hour_h_o(hour_h_o),
    .hour_l_o(hour_l_o),
    .minute_h_o(minute_h_o),
    .minute_l_o(minute_l_o),

    .valid_o(valid_o)
);

endmodule
