`default_nettype none

module digits (
    input        clk_i,
    input        rst_i,

    input        inc_i,

    output [1:0] hour_h_digit_o,
    output [3:0] hour_l_digit_o,
    output [2:0] min_h_digit_o,
    output [3:0] min_l_digit_o,
    output [2:0] sec_h_digit_o,
    output [3:0] sec_l_digit_o,

    input        load_i,
    input [1:0]  hour_h_load_i,
    input [3:0]  hour_l_load_i,
    input [2:0]  minute_h_load_i,
    input [3:0]  minute_l_load_i,
    input [2:0]  second_h_load_i,
    input [3:0]  second_l_load_i
);


wire hour_l_ovf;
wire min_h_ovf;
wire min_l_ovf;
wire sec_h_ovf;
wire sec_l_ovf;

wire hour_h_at_max;

// 2-bits
digit #(.MAX(2)) hour_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (hour_h_digit_o),
    .at_max_o     (hour_h_at_max),
    .at_max_i     (1'b0),
    .inc_i        (hour_l_ovf),
    .ovf_o        (),
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
    .inc_i        (min_h_ovf),
    .ovf_o        (hour_l_ovf),
    .load_i       (load_i),
    .load_value_i (hour_l_load_i)
);

// 3-bits
digit #(.MAX(5)) min_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (min_h_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (min_l_ovf),
    .ovf_o        (min_h_ovf),
    .load_i       (load_i),
    .load_value_i (minute_h_load_i)
);

// 4-bits
digit #(.MAX(9)) min_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (min_l_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (sec_h_ovf),
    .ovf_o        (min_l_ovf),
    .load_i       (load_i),
    .load_value_i (minute_l_load_i)
);

// 3-bits
digit #(.MAX(5)) sec_h (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (sec_h_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (sec_l_ovf),
    .ovf_o        (sec_h_ovf),
    .load_i       (load_i),
    .load_value_i (second_h_load_i)
);

// 4-bits
digit #(.MAX(9)) sec_l (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (sec_l_digit_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (inc_i),
    .ovf_o        (sec_l_ovf),
    .load_i       (load_i),
    .load_value_i (second_l_load_i)
);

endmodule
