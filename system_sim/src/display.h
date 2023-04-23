#pragma once

#include <array>
#include <cstdint>
#include "signals.h"


class Display
{
public:
    Display();
    void update(Signals const& signals, Signals& next);
    void print();

private:
    // Six 7-segment digits
    std::array<uint8_t, 6> m_digits{};

    bool m_prev_sclk = 0;
    uint64_t m_shift_reg = 0;
    uint64_t m_latched_shift_reg = 0;
    bool m_dirty = true;
    bool m_showing_date = false;
};
