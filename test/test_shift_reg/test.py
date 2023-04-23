import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


WIDTH = 48
MASK = (1 << WIDTH) - 1


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.start_i.value = 0
    dut.data_i.value = 1

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 10)


async def feed_data(dut, data):
    for d in data:
        dut.start_i.value = 1
        dut.data_i.value = d
        await ClockCycles(dut.clk_i, 1)
        dut.start_i.value = 0

        for _ in range(100):
            await ClockCycles(dut.clk_i, 200)


async def shift_reg_model(dut, count):
    """Model a shift register with synchronous output registers

    For example: SN74AHC595PWR or 74HC595
    """
    shift_reg = 0

    async def shift_reg_proc():
        nonlocal shift_reg
        while True:
            await RisingEdge(dut.sclk_o)
            shift_reg = ((shift_reg << 1) | dut.data_o.value) & MASK

    cocotb.start_soon(shift_reg_proc())

    values = []
    for _ in range(count):
        await RisingEdge(dut.latch_o)
        values.append(shift_reg)

    return values


@cocotb.test()
async def test_on_valid_data(dut):
    await setup(dut)

    COUNT = 10

    data = [random.randint(0, MASK) for _ in range(COUNT)]
    cocotb.start_soon(feed_data(dut, data))
    result = await shift_reg_model(dut, COUNT)

    assert result == data
