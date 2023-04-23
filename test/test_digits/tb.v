module tb (
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

`ifdef __ICARUS__
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end
`endif

digits digits (
    .clk_i           (clk_i),
    .rst_i           (rst_i),

    .inc_i           (inc_i),

    .year_h_digit_o  (year_h_digit_o),
    .year_l_digit_o  (year_l_digit_o),
    .month_h_digit_o (month_h_digit_o),
    .month_l_digit_o (month_l_digit_o),
    .day_h_digit_o   (day_h_digit_o),
    .day_l_digit_o   (day_l_digit_o),
    .hour_h_digit_o  (hour_h_digit_o),
    .hour_l_digit_o  (hour_l_digit_o),
    .minute_h_digit_o   (minute_h_digit_o),
    .minute_l_digit_o   (minute_l_digit_o),
    .second_h_digit_o   (second_h_digit_o),
    .second_l_digit_o   (second_l_digit_o),

    .load_i          (load_i),
    .year_h_load_i   (year_h_load_i),
    .year_l_load_i   (year_l_load_i),
    .month_h_load_i  (month_h_load_i),
    .month_l_load_i  (month_l_load_i),
    .day_h_load_i    (day_h_load_i),
    .day_l_load_i    (day_l_load_i),
    .hour_h_load_i   (hour_h_load_i),
    .hour_l_load_i   (hour_l_load_i),
    .minute_h_load_i (minute_h_load_i),
    .minute_l_load_i (minute_l_load_i),
    .second_h_load_i (second_h_load_i),
    .second_l_load_i (second_l_load_i)
);

endmodule
