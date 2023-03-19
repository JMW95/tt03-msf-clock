`default_nettype none
`timescale 1ns/1ps

// testbench is controlled by test.py
module tb (
    input        clk_i,
    input        rst_i,
    input        start_i,
    input [47:0] data_i,
    output       sclk_o,
    output       data_o,
    output       latch_o
);

`ifdef __ICARUS__
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end
`endif

shift_reg #(.WIDTH(48)) shift_reg (
    .clk_i   (clk_i),
    .rst_i   (rst_i),
    .start_i (start_i),
    .data_i  (data_i),
    .sclk_o  (sclk_o),
    .data_o  (data_o),
    .latch_o (latch_o)
);

endmodule
