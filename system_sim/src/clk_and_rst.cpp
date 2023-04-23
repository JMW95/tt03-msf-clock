#include "clk_and_rst.h"


void ClkAndRst::update(Signals const& signals, Signals& next)
{
    m_count++;
    next.clk = m_count & 1;
    next.rst = m_count < 10;
}


uint64_t ClkAndRst::time_ns() const
{
    // 12.5 kHz clock => half clock period = 40_000 ns
    return m_count * 40000;
}
