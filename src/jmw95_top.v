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

// decoder <-> time_date_decoder
wire       bits_valid;
wire       bits_is_second_00;
wire [1:0] bits_data;

// time_date_decoder <-> digits
wire [1:0]  hour_h;
wire [3:0]  hour_l;
wire [2:0]  minute_h;
wire [3:0]  minute_l;
wire        time_load;

// Outputs
assign io_out = {4'b0, minute_l};

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

time_date_decoder time_date_decoder (
    .clk_i               (clk),
    .rst_i               (rst),
    .bits_valid_i        (bits_valid),
    .bits_is_second_00_i (bits_is_second_00),
    .bits_data_i         (bits_data),
    .year_h_o            (),
    .year_l_o            (),
    .month_h_o           (),
    .month_l_o           (),
    .day_h_o             (),
    .day_l_o             (),
    .dow_o               (),
    .hour_h_o            (hour_h),
    .hour_l_o            (hour_l),
    .minute_h_o          (minute_h),
    .minute_l_o          (minute_l),
    .valid_o             (time_load)
);

digits digits (
    .clk_i           (clk),
    .rst_i           (rst),
    .inc_i           (bits_valid),
    .load_i          (time_load),
    .hour_h_load_i   (hour_h),
    .hour_l_load_i   (hour_l),
    .minute_h_load_i (minute_h),
    .minute_l_load_i (minute_l),
    .second_h_load_i (0),
    .second_l_load_i (0)
);

endmodule
