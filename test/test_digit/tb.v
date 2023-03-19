module tb (
    input        clk_i,
    input        rst_i,
    input        inc_i,
    output       ovf_o,
    input        load_i,
    input [19:0] load_value_i
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
    .ovf_o(ovf_o),
    .load_i(load_i),
    .load_value_i(load_value_i[18 +: 2])
);

// 4-bits
digit #(.MAX(9)) hour_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(min_msd_ovf),
    .ovf_o(hour_lsd_ovf),
    .load_i(load_i),
    .load_value_i(load_value_i[14 +: 4])
);

// 3-bits
digit #(.MAX(5)) min_msd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(min_lsd_ovf),
    .ovf_o(min_msd_ovf),
    .load_i(load_i),
    .load_value_i(load_value_i[11 +: 3])
);

// 4-bits
digit #(.MAX(9)) min_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(sec_msd_ovf),
    .ovf_o(min_lsd_ovf),
    .load_i(load_i),
    .load_value_i(load_value_i[7 +: 4])
);

// 3-bits
digit #(.MAX(5)) sec_msd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(sec_lsd_ovf),
    .ovf_o(sec_msd_ovf),
    .load_i(load_i),
    .load_value_i(load_value_i[4 +: 3])
);

// 4-bits
digit #(.MAX(9)) sec_lsd (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .inc_i(inc_i),
    .ovf_o(sec_lsd_ovf),
    .load_i(load_i),
    .load_value_i(load_value_i[0 +: 4])
);

endmodule
