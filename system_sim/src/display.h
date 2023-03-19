#pragma once

#include <array>
#include <cstdint>


class Display
{
public:
    Display();
    void update(bool sclk, bool data, bool latch);
    void print();

private:
    // Six 7-segment digits
    std::array<uint8_t, 6> m_digits;

    bool m_prev_sclk = 0;
    uint64_t m_shift_reg = 0;
};
