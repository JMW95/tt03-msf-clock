from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge, Timer

DATA_FILE = Path(__file__).resolve().parent.parent.parent / "notebooks" / "test_data.csv"


@cocotb.test()
async def test_tmp(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)

    with open(DATA_FILE, "r") as f:
        data_samples = [int(line.strip()) for line in f]

    prev_valid = 0
    count_valid_bits = 0
    for sample in data_samples:
        dut.data_i.value = sample

        await ClockCycles(dut.clk_i, 1)

        bit = dut.bit_o.value
        valid = dut.valid_o.value

        # Bit should sample the most recent data
        if valid:
            assert bit == sample
            count_valid_bits += 1

        # Valid is only asserted for 1 cycle
        assert not valid or (valid and not prev_valid)
        prev_valid = valid

    # Expect a downsample of 100 on the output
    assert count_valid_bits == (len(data_samples)-99) // 100
