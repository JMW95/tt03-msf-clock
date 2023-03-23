#include "receiver.h"


Receiver::Receiver(std::shared_ptr<DataSource> data_source) : m_data_source{data_source}
{
}


void Receiver::update(Signals const& signals, Signals& next)
{
    if (signals.clk && !m_prev_clk) {
        next.data = m_data_source->next_sample();
    }

    m_prev_clk = signals.clk;
}
