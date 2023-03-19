from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge, Timer


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.bits_valid_i.value = 0
    dut.bits_is_second_00_i.value = 0
    dut.bits_data_i.value = 0

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


@cocotb.test()
async def test_time_date_normal(dut):
    await setup(dut)

    a_samples = [
        # Second 00 (start of minute)
        1,

        # Seconds 01-16 (unused)
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

        # Seconds 17-24 (year, 23)
        0, 0, 1, 0, 0, 0, 1, 1,

        # Seconds 25-29 (month, 03)
        0, 0, 0, 1, 1,

        # Seconds 30-35 (day, 19)
        0, 1, 1, 0, 0, 1,

        # Seconds 36-38 (day-of-week, 0, sunday)
        0, 0, 0,

        # Seconds 39-44 (hour, 16)
        0, 1, 0, 1, 1, 0,

        # Seconds 45-51 (minute, 56)
        1, 0, 1, 0, 1, 1, 0,

        # Seconds 52-59 (minute marker)
        0, 1, 1, 1, 1, 1, 1, 0
    ]
    b_samples = [
        # Second 00 (start of minute)
        1,

        # Seconds 01-16 (DUT code)
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

        # Seconds 17-52 (unused)
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0,

        # Second 53 (DST change incoming)
        0,

        # Second 54 (parity for 17A-24A inclusive)
        0,

        # Second 55 (parity for 25A-35A inclusive)
        0,

        # Second 56 (parity for 36A-38A inclusive)
        1,

        # Second 57 (parity for 39A-51A inclusive)
        0,

        # Second 58 (DST active)
        0,

        # Second 59 (unused)
        0,
    ]
    assert len(a_samples) == len(b_samples) == 60

    for idx in range(70):
        a = a_samples[idx % len(a_samples)]
        b = b_samples[idx % len(b_samples)]

        dut.bits_data_i[0].value = a
        dut.bits_data_i[1].value = b
        dut.bits_is_second_00_i = idx % 60 == 0
        dut.bits_valid_i = 1

        await ClockCycles(dut.clk_i, 1)

        valid = dut.valid_o.value

        if idx == 61:
            assert valid

            assert dut.year_h_o.value == 2
            assert dut.year_l_o.value == 3
            assert dut.month_h_o.value == 0
            assert dut.month_l_o.value == 3
            assert dut.day_h_o.value == 1
            assert dut.day_l_o.value == 9
            assert dut.dow_o.value == 0

            assert dut.hour_h_o.value == 1
            assert dut.hour_l_o.value == 6
            assert dut.minute_h_o.value == 5
            assert dut.minute_l_o.value == 6
        else:
            assert not valid
