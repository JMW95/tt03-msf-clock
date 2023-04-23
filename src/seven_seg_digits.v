`default_nettype none

module seven_seg_digits #(
    parameter DIGITS = 6
) (
    // BCD digits
    input [DIGITS * 4 - 1:0] digits_i,

    // 7-segment digits
    output [DIGITS * 7 - 1:0] seven_seg_o
);

generate
    for (genvar i = 0; i < DIGITS; i++) begin
        bcd_to_seven_seg seg_i (
            .bcd_i       (digits_i[i * 4 +: 4]),
            .seven_seg_o (seven_seg_o[i * 7 +: 7])
        );
    end
endgenerate

endmodule
