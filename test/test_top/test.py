from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


DATA_FILE = Path(__file__).resolve().parent.parent.parent / "notebooks" / "test_data.csv"


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.data_i.value = 0

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


@cocotb.test()
async def test_top(dut):
    await setup(dut)

    with open(DATA_FILE, "r") as f:
        data_samples = [int(line.strip()) for line in f]

    for sample in data_samples:
        dut.data_i.value = sample

        await ClockCycles(dut.clk_i, 1)
