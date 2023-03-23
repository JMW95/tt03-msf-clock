#pragma once

#include <memory>
#include "signals.h"


class Vjmw95_top;
class VerilatedVcdC;


class Asic
{
public:
    Asic();
    ~Asic();
    void trace(VerilatedVcdC* tfp);
    void update(Signals const& signals, Signals& next);

private:
    std::unique_ptr<Vjmw95_top> m_top;
};
