import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.inc_i.value = 0
    dut.load_i.value = 0
    dut.load_value_i.value = 0

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


@cocotb.test()
async def test_on_valid_data(dut):
    await setup(dut)

    tick_interval = 10

    for _ in range(100):
        dut.inc_i.value = 1
        await ClockCycles(dut.clk_i, 1)
        dut.inc_i.value = 0
        await ClockCycles(dut.clk_i, tick_interval - 1)
