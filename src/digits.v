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

wire [6:0] year_load;
wire [6:0] month_load;
wire [6:0] day_load;

wire [6:0] hour_load;
wire [6:0] minute_load;
wire [6:0] second_load;

wire [9:0] unused = {month_load[6:4], day_load[6:5], hour_load[6:5], minute_load[6], second_load[6], year_o[8]};

bcd2bin year_bcd (
    .bcd({year_h_load_i, year_l_load_i}),
    .bin(year_load)
);

bcd2bin month_bcd (
    .bcd({3'b0, month_h_load_i, month_l_load_i}),
    .bin(month_load)
);

bcd2bin day_bcd (
    .bcd({2'b0, day_h_load_i, day_l_load_i}),
    .bin(day_load)
);

bcd2bin hour_bcd (
    .bcd({2'b0, hour_h_load_i, hour_l_load_i}),
    .bin(hour_load)
);

bcd2bin minute_bcd (
    .bcd({1'b0, minute_h_load_i, minute_l_load_i}),
    .bin(minute_load)
);

bcd2bin second_bcd (
    .bcd({1'b0, second_h_load_i, second_l_load_i}),
    .bin(second_load)
);


wire [6:0] year;
wire [3:0] month;
wire [4:0] day;
wire [4:0] hour;
wire [5:0] minute;
wire [5:0] second;

wire [8:0] year_o;
assign {year_h_digit_o, year_l_digit_o} = year_o[7:0];
bin2bcd #(.W(7)) year_bcd_o (
    .bin(year),
    .bcd(year_o)
);

bin2bcd #(.W(4)) month_bcd_o (
    .bin(month),
    .bcd({month_h_digit_o, month_l_digit_o})
);

bin2bcd #(.W(5)) day_bcd_o (
    .bin(day),
    .bcd({day_h_digit_o, day_l_digit_o})
);

bin2bcd #(.W(5)) hour_bcd_o (
    .bin(hour),
    .bcd({hour_h_digit_o, hour_l_digit_o})
);

bin2bcd minute_bcd_o (
    .bin(minute),
    .bcd({minute_h_digit_o, minute_l_digit_o})
);

bin2bcd second_bcd_o (
    .bin(second),
    .bcd({second_h_digit_o, second_l_digit_o})
);

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
    .load_value_i (year_load)
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
    .load_value_i (month_load[3:0])
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
    .load_value_i (day_load[4:0])
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
    .load_value_i (hour_load[4:0])
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
    .load_value_i (minute_load[5:0])
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
    .load_value_i (second_load[5:0])
);

endmodule
