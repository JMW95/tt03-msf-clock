import datetime

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.inc_i.value = 0
    dut.load_i.value = 0

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


async def load(dut, dt):
    dut.year_h_load_i.value = (dt.year // 10) % 10
    dut.year_l_load_i.value = dt.year % 10
    dut.month_h_load_i.value = dt.month // 10
    dut.month_l_load_i.value = dt.month % 10
    dut.day_h_load_i.value = dt.day // 10
    dut.day_l_load_i.value = dt.day % 10
    dut.hour_h_load_i.value = dt.hour // 10
    dut.hour_l_load_i.value = dt.hour % 10
    dut.minute_h_load_i.value = dt.minute // 10
    dut.minute_l_load_i.value = dt.minute % 10
    dut.second_h_load_i.value = dt.second // 10
    dut.second_l_load_i.value = dt.second % 10

    dut.load_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.load_i.value = 0
    await ClockCycles(dut.clk_i, 1)


async def read(dut):
    year = dut.year_h_digit_o.value * 10 + dut.year_l_digit_o.value
    month = dut.month_h_digit_o.value * 10 + dut.month_l_digit_o.value
    day = dut.day_h_digit_o.value * 10 + dut.day_l_digit_o.value
    hour = dut.hour_h_digit_o.value * 10 + dut.hour_l_digit_o.value
    minute = dut.minute_h_digit_o.value * 10 + dut.minute_l_digit_o.value
    second = dut.second_h_digit_o.value * 10 + dut.second_l_digit_o.value
    return datetime.datetime(2000 + year, month, day, hour, minute, second)


async def run_counter(dut, start, count):
    await load(dut, start)

    tick_interval = 10

    values = []
    expected = []

    t = start
    for _ in range(count):
        expected.append(t)
        values.append(await read(dut))

        t = t + datetime.timedelta(seconds=1)

        dut.inc_i.value = 1
        await ClockCycles(dut.clk_i, 1)
        dut.inc_i.value = 0
        await ClockCycles(dut.clk_i, tick_interval - 1)

    for v, e in zip(values, expected):
        # print(v)
        assert v == e, f"Expected {e}, got {v}"

    assert len(values) == len(expected)


@cocotb.test()
async def test_no_rollover(dut):
    await setup(dut)
    await run_counter(dut, datetime.datetime(year=2000, month=1, day=1, hour=0, minute=0, second=0), 100)


@cocotb.test()
async def test_all_rollover(dut):
    await setup(dut)
    await run_counter(dut, datetime.datetime(year=2023, month=12, day=31, hour=23, minute=59, second=40), 100)
