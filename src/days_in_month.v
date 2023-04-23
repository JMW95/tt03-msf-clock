`default_nettype none

module days_in_month (
    // Month 01 - 12
    input      [3:0] month_i,

    // Days in month -- 28, 30 or 31
    output reg [4:0] days_in_month_o
);

always @(*) begin
    case (month_i)
        4'd01:   days_in_month_o = 5'd31;  // Jan
        4'd02:   days_in_month_o = 5'd28;  // Feb
        4'd03:   days_in_month_o = 5'd31;  // Mar
        4'd04:   days_in_month_o = 5'd30;  // Apr
        4'd05:   days_in_month_o = 5'd31;  // May
        4'd06:   days_in_month_o = 5'd30;  // Jun
        4'd07:   days_in_month_o = 5'd31;  // Jul
        4'd08:   days_in_month_o = 5'd31;  // Aug
        4'd09:   days_in_month_o = 5'd30;  // Sep
        4'd10:   days_in_month_o = 5'd31;  // Oct
        4'd11:   days_in_month_o = 5'd30;  // Nov
        4'd12:   days_in_month_o = 5'd31;  // Dec
        default: days_in_month_o = 5'd31;
    endcase
end

endmodule
