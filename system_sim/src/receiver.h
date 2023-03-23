#pragma once

#include <memory>
#include "data_source.h"
#include "signals.h"


class Receiver
{
public:
    explicit Receiver(std::shared_ptr<DataSource> data_source);
    void update(Signals const& signals, Signals& next);

private:
    bool m_prev_clk = false;
    std::shared_ptr<DataSource> m_data_source;
};
