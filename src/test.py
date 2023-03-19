import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_tmp(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0

    prev = dut.segments.value
    await ClockCycles(dut.clk, 1)

    for i in range(10):
        await ClockCycles(dut.clk, 1)
        assert int(dut.segments.value) == not prev
