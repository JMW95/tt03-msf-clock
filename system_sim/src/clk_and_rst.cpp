#include "clk_and_rst.h"


void ClkAndRst::update(Signals const& signals, Signals& next)
{
    m_count++;
    next.clk = m_count & 1;
    next.rst = m_count < 10;
}


uint64_t ClkAndRst::time_ns() const
{
    // 1 kHz clock => half clock period = 500_000 ns
    return m_count * 500000;
}
