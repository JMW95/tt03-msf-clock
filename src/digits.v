`default_nettype none

module digits (
    input        clk_i,
    input        rst_i,

    input        inc_i,

    output [3:0] year_h_digit_o,
    output [3:0] year_l_digit_o,
    output [0:0] month_h_digit_o,
    output [3:0] month_l_digit_o,
    output [1:0] day_h_digit_o,
    output [3:0] day_l_digit_o,
    output [1:0] hour_h_digit_o,
    output [3:0] hour_l_digit_o,
    output [2:0] minute_h_digit_o,
    output [3:0] minute_l_digit_o,
    output [2:0] second_h_digit_o,
    output [3:0] second_l_digit_o,

    input        load_i,
    input [3:0]  year_h_load_i,
    input [3:0]  year_l_load_i,
    input [0:0]  month_h_load_i,
    input [3:0]  month_l_load_i,
    input [1:0]  day_h_load_i,
    input [3:0]  day_l_load_i,
    input [1:0]  hour_h_load_i,
    input [3:0]  hour_l_load_i,
    input [2:0]  minute_h_load_i,
    input [3:0]  minute_l_load_i,
    input [2:0]  second_h_load_i,
    input [3:0]  second_l_load_i
);


wire [6:0] year;
wire [3:0] month;
wire [4:0] day;
wire [4:0] hour;
wire [5:0] minute;
wire [5:0] second;

wire month_ovf;
wire day_ovf;
wire hour_ovf;
wire minute_ovf;
wire second_ovf;

wire [4:0] day_max;

days_in_month days_in_month (
    .month_i         (month),
    .days_in_month_o (day_max)
);

// verilator lint_off PINCONNECTEMPTY

counter #(.WIDTH(7)) year_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (7'd0),
    .max_i        (7'd99),

    .value_o      (year),

    .inc_i        (month_ovf),
    .ovf_o        (),

    .load_i       (load_i),
    .load_value_i (load_year_i)
);

// verilator lint_on PINCONNECTEMPTY

counter #(.WIDTH(4)) month_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (4'd1),
    .max_i        (4'd12),

    .value_o      (month),

    .inc_i        (day_ovf),
    .ovf_o        (month_ovf),

    .load_i       (load_i),
    .load_value_i (load_month_i)
);

counter #(.WIDTH(5)) day_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (5'd1),
    .max_i        (day_max),

    .value_o      (day),

    .inc_i        (hour_ovf),
    .ovf_o        (day_ovf),

    .load_i       (load_i),
    .load_value_i (load_day_i)
);

counter #(.WIDTH(5)) hour_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (5'd0),
    .max_i        (5'd23),

    .value_o      (hour),

    .inc_i        (minute_ovf),
    .ovf_o        (hour_ovf),

    .load_i       (load_i),
    .load_value_i (load_hour_i)
);

counter #(.WIDTH(6)) minute_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (6'd0),
    .max_i        (6'd59),

    .value_o      (minute),

    .inc_i        (second_ovf),
    .ovf_o        (minute_ovf),

    .load_i       (load_i),
    .load_value_i (load_minute_i)
);

counter #(.WIDTH(6)) second_counter (
    .clk_i        (clk_i),
    .rst_i        (rst_i),

    .min_i        (6'd0),
    .max_i        (6'd59),

    .value_o      (second),

    .inc_i        (inc_i),
    .ovf_o        (second_ovf),

    .load_i       (load_i),
    .load_value_i (load_second_i)
);

endmodule
