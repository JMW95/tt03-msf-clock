#pragma once

#include <cstdint>
#include "signals.h"


class ClkAndRst
{
public:
    void update(Signals const& signals, Signals& next);
    uint64_t time_ns() const;

private:
    uint64_t m_count = 0;
};
