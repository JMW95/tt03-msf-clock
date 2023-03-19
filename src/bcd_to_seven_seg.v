`default_nettype none

module bcd_to_seven_seg (
    input      [3:0] bcd_i,
    output reg [6:0] seven_seg_o
);

always @(*) begin
    case (bcd_i)
        4'd0:    seven_seg_o = 7'b0111111;
        4'd1:    seven_seg_o = 7'b0000110;
        4'd2:    seven_seg_o = 7'b1011011;
        4'd3:    seven_seg_o = 7'b1001111;
        4'd4:    seven_seg_o = 7'b1100110;
        4'd5:    seven_seg_o = 7'b1101100;
        4'd6:    seven_seg_o = 7'b1111101;
        4'd7:    seven_seg_o = 7'b0000111;
        4'd8:    seven_seg_o = 7'b1111111;
        4'd9:    seven_seg_o = 7'b1101111;
        default: seven_seg_o = 7'b1001001;
    endcase
end

endmodule
