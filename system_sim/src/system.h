#pragma once

#include <memory>

#include "asic.h"
#include "clk_and_rst.h"
#include "display.h"
#include "receiver.h"
#include "signals.h"


class System
{
public:
    System(std::shared_ptr<DataSource> data_source, bool inverted);
    ~System();

    void trace();
    void update();
    uint64_t time_ns() const;

private:
    Signals m_signals;

    Asic m_asic;
    Display m_display;
    ClkAndRst m_clk_and_rst;
    Receiver m_receiver;

    std::unique_ptr<VerilatedVcdC> m_tfp;
};
