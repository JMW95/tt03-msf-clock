`default_nettype none

module digits (
    input        clk_i,
    input        rst_i,

    input        inc_i,

    input        load_i,
    input [1:0]  hour_h_load_i,
    input [3:0]  hour_l_load_i,
    input [2:0]  minute_h_load_i,
    input [3:0]  minute_l_load_i,
    input [2:0]  second_h_load_i,
    input [3:0]  second_l_load_i
);

wire hour_lsd_ovf;
wire min_msd_ovf;
wire min_lsd_ovf;
wire sec_msd_ovf;
wire sec_lsd_ovf;

// 2-bits
digit #(.MAX(2)) hour_msd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(hour_lsd_ovf),
    .ovf_o(),
    .load_i(load_i),
    .load_value_i(hour_h_load_i)
);

// 4-bits
digit #(.MAX(9)) hour_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(min_msd_ovf),
    .ovf_o(hour_lsd_ovf),
    .load_i(load_i),
    .load_value_i(hour_l_load_i)
);

// 3-bits
digit #(.MAX(5)) min_msd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(min_lsd_ovf),
    .ovf_o(min_msd_ovf),
    .load_i(load_i),
    .load_value_i(minute_h_load_i)
);

// 4-bits
digit #(.MAX(9)) min_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(sec_msd_ovf),
    .ovf_o(min_lsd_ovf),
    .load_i(load_i),
    .load_value_i(minute_l_load_i)
);

// 3-bits
digit #(.MAX(5)) sec_msd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(sec_lsd_ovf),
    .ovf_o(sec_msd_ovf),
    .load_i(load_i),
    .load_value_i(second_h_load_i)
);

// 4-bits
digit #(.MAX(9)) sec_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(inc_i),
    .ovf_o(sec_lsd_ovf),
    .load_i(load_i),
    .load_value_i(second_l_load_i)
);

endmodule
