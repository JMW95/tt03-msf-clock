`default_nettype none
`timescale 1ns/1ps

// testbench is controlled by test.py
module tb (
    input        clk_i,
    input        rst_i,
    input        sample_valid_i,
    input        sample_data_i,
    output       bits_valid_o,
    output       bits_is_second_00_o,
    output [1:0] bits_data_o
);

`ifdef __ICARUS__
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end
`endif

decoder decoder (
    .clk_i               (clk_i),
    .rst_i               (rst_i),
    .sample_valid_i      (sample_valid_i),
    .sample_data_i       (sample_data_i),
    .bits_valid_o        (bits_valid_o),
    .bits_is_second_00_o (bits_is_second_00_o),
    .bits_data_o         (bits_data_o)
);

endmodule
