`default_nettype none
`timescale 1ns/1ps

// testbench is controlled by test.py
module tb (
    input clk_i,
    input rst_i,
    output [7:0] ouputs_o
);

initial begin
    $dumpfile ("tb.vcd");
    $dumpvars (0, tb);
    #1;
end

wire [7:0] inputs = {6'b0, rst, clk};

// instantiate the DUT
seven_segment_seconds seven_segment_seconds(
    `ifdef GL_TEST
        .vccd1( 1'b1),
        .vssd1( 1'b0),
    `endif
    .io_in  (inputs),
    .io_out (outputs_o)
);

endmodule
