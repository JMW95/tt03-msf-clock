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

wire year_l_ovf;
wire month_h_ovf;
wire month_l_ovf;
wire day_h_ovf;
wire day_l_ovf;
wire hour_h_ovf;
wire hour_l_ovf;
wire minute_h_ovf;
wire minute_l_ovf;
wire second_h_ovf;
wire second_l_ovf;

wire month_h_at_max;
wire day_h_at_max;
wire hour_h_at_max;

// verilator lint_off PINCONNECTEMPTY

// 2-bits
digit #(.MAX(9)) year_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (year_h_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (year_l_ovf),
    .ovf_o        (),
    .load_i       (load_i),
    .load_value_i (year_h_load_i)
);

// 4-bits
digit #(.MAX(9)) year_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (year_l_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (month_h_ovf),
    .ovf_o        (year_l_ovf),
    .load_i       (load_i),
    .load_value_i (year_l_load_i)
);

// 2-bits
digit #(.MAX(1)) month_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (month_h_digit_o),
    .at_max_o     (month_h_at_max),
    .at_max_i     (1'b0),
    .inc_i        (month_l_ovf),
    .ovf_o        (month_h_ovf),
    .load_i       (load_i),
    .load_value_i (month_h_load_i)
);

// 4-bits
digit #(.MIN(1), .MAX(9), .MAX2(2)) month_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (month_l_digit_o),
    .at_max_o     (),
    .at_max_i     (month_h_at_max),
    .inc_i        (day_h_ovf),
    .ovf_o        (month_l_ovf),
    .load_i       (load_i),
    .load_value_i (month_l_load_i)
);

// 2-bits
digit #(.MAX(3)) day_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (day_h_digit_o),
    .at_max_o     (day_h_at_max),
    .at_max_i     (1'b0),
    .inc_i        (day_l_ovf),
    .ovf_o        (day_h_ovf),
    .load_i       (load_i),
    .load_value_i (day_h_load_i)
);

// 4-bits
digit #(.MIN(1), .MAX(9), .MAX2(1)) day_l (  // TODO: shorter months
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (day_l_digit_o),
    .at_max_o     (),
    .at_max_i     (day_h_at_max),
    .inc_i        (hour_h_ovf),
    .ovf_o        (day_l_ovf),
    .load_i       (load_i),
    .load_value_i (day_l_load_i)
);

// 2-bits
digit #(.MAX(2)) hour_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (hour_h_digit_o),
    .at_max_o     (hour_h_at_max),
    .at_max_i     (1'b0),
    .inc_i        (hour_l_ovf),
    .ovf_o        (hour_h_ovf),
    .load_i       (load_i),
    .load_value_i (hour_h_load_i)
);

// 4-bits
digit #(.MAX(9), .MAX2(3)) hour_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (hour_l_digit_o),
    .at_max_o     (),
    .at_max_i     (hour_h_at_max),
    .inc_i        (minute_h_ovf),
    .ovf_o        (hour_l_ovf),
    .load_i       (load_i),
    .load_value_i (hour_l_load_i)
);

// 3-bits
digit #(.MAX(5)) minute_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (minute_h_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (minute_l_ovf),
    .ovf_o        (minute_h_ovf),
    .load_i       (load_i),
    .load_value_i (minute_h_load_i)
);

// 4-bits
digit #(.MAX(9)) minute_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (minute_l_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (second_h_ovf),
    .ovf_o        (minute_l_ovf),
    .load_i       (load_i),
    .load_value_i (minute_l_load_i)
);

// 3-bits
digit #(.MAX(5)) second_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (second_h_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (second_l_ovf),
    .ovf_o        (second_h_ovf),
    .load_i       (load_i),
    .load_value_i (second_h_load_i)
);

// 4-bits
digit #(.MAX(9)) second_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (second_l_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (inc_i),
    .ovf_o        (second_l_ovf),
    .load_i       (load_i),
    .load_value_i (second_l_load_i)
);

// verilator lint_on PINCONNECTEMPTY

endmodule
