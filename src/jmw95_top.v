`default_nettype none

module jmw95_top (
    input  [7:0] io_in,
    output [7:0] io_out
);

// Inputs
wire clk  = io_in[0];
wire rst  = io_in[1];
wire data = io_in[2];

// bit_sampler <-> decoder
wire sample_valid;
wire sample_data;

// decoder <-> ?
wire       bits_valid;
wire       bits_is_second_00;
wire [1:0] bits_data;

// Outputs
assign io_out = 8'b0;

bit_sampler bit_sampler (
    .clk_i   (clk),
    .rst_i   (rst),
    .data_i  (data),
    .bit_o   (sample_data),
    .valid_o (sample_valid)
);

decoder decoder (
    .clk_i               (clk),
    .rst_i               (rst),
    .sample_valid_i      (sample_valid),
    .sample_data_i       (sample_data),
    .bits_valid_o        (bits_valid),
    .bits_is_second_00_o (bits_is_second_00),
    .bits_data_o         (bits_data)
);

endmodule
