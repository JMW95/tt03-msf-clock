`default_nettype none
`timescale 1ns/1ps

// testbench is controlled by test.py
module tb (
    input clk_i,
    input rst_i,

    input data_i,

    output bit_o,
    output valid_o
);

`ifdef __ICARUS__
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end
`endif

// instantiate the DUT
bit_sampler bit_sampler(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .data_i(data_i),

    .bit_o(bit_o),
    .valid_o(valid_o)
);

endmodule
