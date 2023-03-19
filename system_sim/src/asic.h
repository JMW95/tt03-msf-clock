#pragma once

#include <memory>


class Vjmw95_top;
class VerilatedVcdC;


class Asic
{
public:
    Asic();
    ~Asic();

    void trace(VerilatedVcdC* tfp);
    void eval();

    void set_clk(bool value);
    void set_rst(bool value);
    void set_data(bool value);

    bool shift_reg_sclk() const;
    bool shift_reg_data() const;
    bool shift_reg_latch() const;

private:
    std::unique_ptr<Vjmw95_top> m_top;
};
