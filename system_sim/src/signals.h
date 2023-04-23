#pragma once


struct Signals
{
    bool clk;
    bool rst;
    bool data;
    bool inverted;
    bool shift_date;

    bool shift_reg_sclk;
    bool shift_reg_data;
    bool shift_reg_latch;
};
