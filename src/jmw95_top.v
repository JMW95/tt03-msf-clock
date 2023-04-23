`default_nettype none

module jmw95_top (
    input  [7:0] io_in,
    output [7:0] io_out
);

// Inputs
wire clk  = io_in[0];
wire rst  = io_in[1];
wire data = io_in[2];
wire inverted = io_in[3];

// bit_sampler <-> decoder
wire sample_valid;
wire sample_data;

// decoder <-> time_date_decoder
wire       bits_valid;
wire       bits_is_second_00;
wire [1:0] bits_data;

// second_counter <-> digits
wire second_inc;

// time_date_decoder <-> digits
wire [1:0]  hour_h;
wire [3:0]  hour_l;
wire [2:0]  minute_h;
wire [3:0]  minute_l;
wire        time_load;

// digits <-> seven_seg_hms
wire [1:0] hour_h_digit;
wire [3:0] hour_l_digit;
wire [2:0] min_h_digit;
wire [3:0] min_l_digit;
wire [2:0] sec_h_digit;
wire [3:0] sec_l_digit;

// seven_seg_hms <-> shift_reg
wire [7 * 6 - 1:0] seven_seg;

// Outputs
wire shift_reg_sclk;
wire shift_reg_data;
wire shift_reg_latch;
assign io_out = {5'b0, shift_reg_latch, shift_reg_data, shift_reg_sclk};

bit_sampler bit_sampler (
    .clk_i   (clk),
    .rst_i   (rst),
    .data_i  (data ^ inverted),
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

second_counter second_counter (
    .clk_i (clk),
    .rst_i (rst),
    .second_inc_o (second_inc)
);

digits digits (
    .clk_i           (clk),
    .rst_i           (rst),
    .inc_i           (second_inc),
    .hour_h_digit_o  (hour_h_digit),
    .hour_l_digit_o  (hour_l_digit),
    .min_h_digit_o   (min_h_digit),
    .min_l_digit_o   (min_l_digit),
    .sec_h_digit_o   (sec_h_digit),
    .sec_l_digit_o   (sec_l_digit),
    .load_i          (time_load),
    .hour_h_load_i   (hour_h),
    .hour_l_load_i   (hour_l),
    .minute_h_load_i (minute_h),
    .minute_l_load_i (minute_l),
    .second_h_load_i (3'h0),
    .second_l_load_i (4'h0)
);

seven_seg_hms seven_seg_hms (
    .hour_h_digit_i  (hour_h_digit),
    .hour_l_digit_i  (hour_l_digit),
    .min_h_digit_i   (min_h_digit),
    .min_l_digit_i   (min_l_digit),
    .sec_h_digit_i   (sec_h_digit),
    .sec_l_digit_i   (sec_l_digit),
    .seven_seg_hms_o (seven_seg)
);

shift_reg #(.WIDTH(7 * 6)) shift_reg (
    .clk_i   (clk),
    .rst_i   (rst),

    .start_i (bits_valid),  // TODO: We should wait for the digits to update first!
    .data_i  (seven_seg),

    .sclk_o  (shift_reg_sclk),
    .data_o  (shift_reg_data),
    .latch_o (shift_reg_latch)
);

endmodule
