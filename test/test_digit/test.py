from dataclasses import dataclass

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@dataclass
class Time:
    hour: int
    min: int
    sec: int

    def normalise(self):
        if not (0 <= self.sec < 60):
            self.min += self.sec // 60
            self.sec = self.sec % 60
        if not (0 <= self.min < 60):
            self.hour += self.min // 60
            self.min = self.min % 60
        if not (0 <= self.hour < 24):
            self.hour = self.hour % 24

    def inc(self):
        t = Time(self.hour, self.min, self.sec + 1)
        t.normalise()
        return t


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.inc_i.value = 0
    dut.load_i.value = 0

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


async def run_counter(dut, start, count):
    dut.load_hour_h_i.value = start.hour // 10
    dut.load_hour_l_i.value = start.hour % 10
    dut.load_min_h_i.value  = start.min // 10
    dut.load_min_l_i.value  = start.min % 10
    dut.load_sec_h_i.value  = start.sec // 10
    dut.load_sec_l_i.value  = start.sec % 10

    dut.load_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.load_i.value = 0
    await ClockCycles(dut.clk_i, 1)

    tick_interval = 10

    values = []
    expected = []

    t = start
    for _ in range(count):
        expected.append(t)
        t = t.inc()

        h = dut.digit_hour_h_o.value * 10 + dut.digit_hour_l_o.value
        m = dut.digit_min_h_o.value * 10 + dut.digit_min_l_o.value
        s = dut.digit_sec_h_o.value * 10 + dut.digit_sec_l_o.value
        values.append(Time(h, m, s))

        dut.inc_i.value = 1
        await ClockCycles(dut.clk_i, 1)
        dut.inc_i.value = 0
        await ClockCycles(dut.clk_i, tick_interval - 1)

    for v, e in zip(values, expected):
        print(v)
        assert v == e, f"Expected {e}, got {v}"

    assert len(values) == len(expected)


@cocotb.test()
async def test_on_valid_data(dut):
    await setup(dut)

    await run_counter(dut, Time(0, 0, 0), 100)
    await run_counter(dut, Time(0, 59, 0), 100)
    await run_counter(dut, Time(23, 59, 0), 100)
