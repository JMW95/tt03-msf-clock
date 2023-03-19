module tb (
    input        clk_i,
    input        rst_i,

    input        inc_i,
    output       ovf_o,

    output [1:0] digit_hour_msd_o,
    output [3:0] digit_hour_lsd_o,
    output [2:0] digit_min_msd_o,
    output [3:0] digit_min_lsd_o,
    output [2:0] digit_sec_msd_o,
    output [3:0] digit_sec_lsd_o,

    input        load_i,
    input  [1:0] load_hour_msd_i,
    input  [3:0] load_hour_lsd_i,
    input  [2:0] load_min_msd_i,
    input  [3:0] load_min_lsd_i,
    input  [2:0] load_sec_msd_i,
    input  [3:0] load_sec_lsd_i
);

initial begin
    $dumpfile ("tb.vcd");
    $dumpvars (0, tb);
    #1;
end

wire hour_lsd_ovf;
wire min_msd_ovf;
wire min_lsd_ovf;
wire sec_msd_ovf;
wire sec_lsd_ovf;

wire hour_msd_at_max;

digit #(.MAX(2)) hour_msd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_hour_msd_o),
    .at_max_o     (hour_msd_at_max),
    .at_max_i     (1'b0),
    .inc_i        (hour_lsd_ovf),
    .ovf_o        (ovf_o),
    .load_i       (load_i),
    .load_value_i (load_hour_msd_i)
);

digit #(.MAX(9), .MAX2(3)) hour_lsd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_hour_lsd_o),
    .at_max_o     (),
    .at_max_i     (hour_msd_at_max),
    .inc_i        (min_msd_ovf),
    .ovf_o        (hour_lsd_ovf),
    .load_i       (load_i),
    .load_value_i (load_hour_lsd_i)
);

digit #(.MAX(5)) min_msd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_min_msd_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (min_lsd_ovf),
    .ovf_o        (min_msd_ovf),
    .load_i       (load_i),
    .load_value_i (load_min_msd_i)
);

digit #(.MAX(9)) min_lsd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_min_lsd_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (sec_msd_ovf),
    .ovf_o        (min_lsd_ovf),
    .load_i       (load_i),
    .load_value_i (load_min_lsd_i)
);

digit #(.MAX(5)) sec_msd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_sec_msd_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (sec_lsd_ovf),
    .ovf_o        (sec_msd_ovf),
    .load_i       (load_i),
    .load_value_i (load_sec_msd_i)
);

digit #(.MAX(9)) sec_lsd (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .digit_o      (digit_sec_lsd_o),
    .at_max_o     (),
    .at_max_i     (1'b0),
    .inc_i        (inc_i),
    .ovf_o        (sec_lsd_ovf),
    .load_i       (load_i),
    .load_value_i (load_sec_lsd_i)
);

endmodule
