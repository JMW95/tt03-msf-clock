import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_tmp(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0

    prev = dut.outputs_o.value
    await ClockCycles(dut.clk_i, 1)

    for i in range(10):
        await ClockCycles(dut.clk_i, 1)
        assert int(dut.outputs_o.value) == (not prev)
