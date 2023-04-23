#include <verilated.h>
#include <verilated_vcd_c.h>
#include "system.h"


System::System(std::shared_ptr<DataSource> data_source, bool inverted)
: m_receiver{data_source}
{
    m_signals.inverted = inverted;
    m_signals.shift_date = 0;
}


System::~System()
{
    if (m_tfp) {
        m_tfp->close();
        m_tfp = nullptr;
    }
}


void System::trace()
{
    Verilated::traceEverOn(true);
    m_tfp = std::make_unique<VerilatedVcdC>();
    m_asic.trace(m_tfp.get());
    Verilated::mkdir("logs");
    m_tfp->open("logs/dump.vcd");
}


void System::update()
{
    Signals next = m_signals;
    m_asic.update(m_signals, next);
    m_display.update(m_signals, next);
    m_clk_and_rst.update(m_signals, next);
    m_receiver.update(m_signals, next);
    m_signals = next;

    if (m_tfp) {
        m_tfp->dump(m_clk_and_rst.time_ns());
    }

    m_display.print();
}


uint64_t System::time_ns() const
{
    return m_clk_and_rst.time_ns();
}
