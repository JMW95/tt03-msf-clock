`default_nettype none

module decoder (
    input        clk_i,
    input        rst_i,

    // Sample stream from the bit sampler
    input        sample_valid_i,
    input        sample_data_i,

    // Decoded output
    output       bits_valid_o,
    output       bits_is_second_00_o, // Indicates second 00 within the minute
    output [1:0] bits_data_o          // The two data bits for this second: { B, A }
);

localparam
    STATE_IDLE = 0,
    STATE_BUSY = 1;

//-- Registers ---------------------------------------------------------------

reg       state_reg;
reg [4:0] data_reg;

//-- Internal signals --------------------------------------------------------

wire is_idle      = data_reg == 5'b11111;
wire is_second_00 = data_reg == 5'b00000;
wire is_valid     = (data_reg[4:3] == 2'b11 && data_reg[0] == 1'b0) || is_second_00;

//-- Logic -------------------------------------------------------------------

always @(posedge clk_i) begin
    if (rst_i) begin
        state_reg <= STATE_BUSY;
        data_reg  <= 5'b0;
    end else if (sample_valid_i) begin
        data_reg <= {sample_data_i, data_reg[4:1]};

        case (state_reg)
            STATE_IDLE: begin
                if (is_valid) begin
                    state_reg <= STATE_BUSY;
                end
            end

            STATE_BUSY: begin
                if (is_idle) begin
                    state_reg <= STATE_IDLE;
                end
            end
        endcase
    end
end

assign bits_valid_o        = (state_reg == STATE_IDLE) && sample_valid_i && is_valid;
assign bits_is_second_00_o = is_second_00;
assign bits_data_o         = data_reg[2:1];

endmodule
