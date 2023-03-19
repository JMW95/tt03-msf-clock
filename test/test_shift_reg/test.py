import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.start_i.value = 0
    dut.data_i.value = 1

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 10)


async def start(dut, data):
    dut.start_i.value = 1
    dut.data_i.value = data
    await ClockCycles(dut.clk_i, 1)
    dut.start_i.value = 0


@cocotb.test()
async def test_on_valid_data(dut):
    await setup(dut)

    data = 0b10100101_00000000_11111111_00001111_11110000_01011010
    await start(dut, data)

    await ClockCycles(dut.clk_i, 100)

    # TODO: Assertions!
