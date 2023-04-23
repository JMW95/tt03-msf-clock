#include <algorithm>
#include <cstddef>
#include <cstdio>
#include "display.h"


Display::Display()
{
    // Clear the screen
    std::puts("\033[2J");
}


void Display::update(Signals const& signals, Signals& next)
{
    // Shift data in on rising edges of sclk
    if (signals.shift_reg_sclk && !m_prev_sclk) {
        m_shift_reg = (m_shift_reg << 1) | signals.shift_reg_data;
    }

    m_prev_sclk = signals.shift_reg_sclk;

    m_showing_date = signals.shift_date;

    if (signals.shift_reg_latch && m_latched_shift_reg != m_shift_reg) {
        m_dirty = true;
        m_latched_shift_reg = m_shift_reg;

        for (size_t i = 0; i < 6; i++) {
            m_digits[5 - i] = (m_shift_reg >> (i * 7)) & 0b1111111;
        }
    }
}


void Display::print()
{
    if (!m_dirty) {
        return;
    }

    const size_t NUM_DIGITS = 6;

    const size_t DIGIT_WIDTH = 7;
    const size_t DIGIT_HEIGHT = 11;

    const size_t WIDTH = DIGIT_WIDTH * NUM_DIGITS + 2;
    const size_t HEIGHT = DIGIT_HEIGHT;
    std::array<uint8_t, WIDTH * HEIGHT> pixels{};

    size_t base_x = 0;
    size_t base_y = 0;

    auto set = [&](size_t x, size_t y) {
        pixels[(base_x + x) + (base_y + y) * WIDTH] = 1;
    };

    // Draw the ':'s in
    if (!m_showing_date) {
        set(14, 3);
        set(14, 7);
        set(29, 3);
        set(29, 7);
    }

    for (size_t digit = 0; digit < NUM_DIGITS; digit++) {
        uint8_t code = m_digits[digit];

        if (code & 1) {
            set(1, 1);
            set(2, 1);
            set(3, 1);
            set(4, 1);
            set(5, 1);
        }
        if (code & 2) {
            set(5, 1);
            set(5, 2);
            set(5, 3);
            set(5, 4);
            set(5, 5);
        }
        if (code & 4) {
            set(5, 5);
            set(5, 6);
            set(5, 7);
            set(5, 8);
            set(5, 9);
        }
        if (code & 8) {
            set(1, 9);
            set(2, 9);
            set(3, 9);
            set(4, 9);
            set(5, 9);
        }
        if (code & 16) {
            set(1, 5);
            set(1, 6);
            set(1, 7);
            set(1, 8);
            set(1, 9);
        }
        if (code & 32) {
            set(1, 1);
            set(1, 2);
            set(1, 3);
            set(1, 4);
            set(1, 5);
        }
        if (code & 64) {
            set(1, 5);
            set(2, 5);
            set(3, 5);
            set(4, 5);
            set(5, 5);
        }

        base_x += DIGIT_WIDTH + (digit % 2); // Add an extra column after every other digit for the ':'
    }

    std::puts("\033[2H");

    for (size_t y = 0; y < HEIGHT; y++) {
        for (size_t x = 0; x < WIDTH; x++) {
            char c = pixels[x + y * WIDTH] ? '#' : ' ';
            std::putchar(c);
        }
        std::putchar('\n');
    }

    std::putchar('\n');

    m_dirty = false;
}
