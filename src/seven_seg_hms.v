`default_nettype none

module seven_seg_hms(
    // BCD digits
    input [1:0] hour_h_digit_i,
    input [3:0] hour_l_digit_i,
    input [2:0] min_h_digit_i,
    input [3:0] min_l_digit_i,
    input [2:0] sec_h_digit_i,
    input [3:0] sec_l_digit_i,

    // Six 7-segment digits
    output [7 * 6 - 1:0] seven_seg_hms_o
);

bcd_to_seven_seg bcd_to_seven_seg_hour_h (
    .bcd_i       ({2'b0, hour_h_digit_i}),
    .seven_seg_o (seven_seg_hms_o[5 * 7 +: 7])
);

bcd_to_seven_seg bcd_to_seven_seg_hour_l (
    .bcd_i       (hour_l_digit_i),
    .seven_seg_o (seven_seg_hms_o[4 * 7 +: 7])
);

bcd_to_seven_seg bcd_to_seven_seg_min_h (
    .bcd_i       ({1'b0, min_h_digit_i}),
    .seven_seg_o (seven_seg_hms_o[3 * 7 +: 7])
);

bcd_to_seven_seg bcd_to_seven_seg_min_l (
    .bcd_i       (min_l_digit_i),
    .seven_seg_o (seven_seg_hms_o[2 * 7 +: 7])
);

bcd_to_seven_seg bcd_to_seven_seg_sec_h (
    .bcd_i       ({1'b0, sec_h_digit_i}),
    .seven_seg_o (seven_seg_hms_o[1 * 7 +: 7])
);

bcd_to_seven_seg bcd_to_seven_seg_sec_l (
    .bcd_i       (sec_l_digit_i),
    .seven_seg_o (seven_seg_hms_o[0 * 7 +: 7])
);

endmodule
