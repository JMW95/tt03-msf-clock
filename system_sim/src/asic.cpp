#include "asic.h"
#include "Vjmw95_top.h"


Asic::Asic()
{
    m_top = std::make_unique<Vjmw95_top>();
}


Asic::~Asic()
{
}


void Asic::trace(VerilatedVcdC* tfp)
{
    m_top->trace(tfp, 99);
}


void Asic::update(Signals const& signals, Signals& next)
{
    m_top->io_in =
        (signals.clk << 0) |
        (signals.rst << 1) |
        (signals.data << 2) |
        (signals.inverted << 3) |
        (signals.shift_date << 4);

    m_top->eval();

    next.shift_reg_sclk = (m_top->io_out >> 0) & 1;
    next.shift_reg_data = (m_top->io_out >> 1) & 1;
    next.shift_reg_latch = (m_top->io_out >> 2) & 1;
}
