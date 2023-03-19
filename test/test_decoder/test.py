import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def setup(dut):
    clock = Clock(dut.clk_i, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.sample_valid_i.value = 0
    dut.sample_data_i.value = 1

    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, 10)
    dut.rst_i.value = 0
    await ClockCycles(dut.clk_i, 1)


async def feed_samples(dut, data):
    # Period in clock cycles at which valid samples appear
    valid_period = 10

    for d in data:
        dut.sample_valid_i.value = 1
        dut.sample_data_i.value = d
        await ClockCycles(dut.clk_i, 1)
        dut.sample_valid_i.value = 0
        dut.sample_data_i.value = 1
        await ClockCycles(dut.clk_i, valid_period - 1)


async def receive_data(dut, timeout):
    data = []

    timeout = 1000
    for _ in range(timeout):
        await ClockCycles(dut.clk_i, 1)

        if dut.bits_valid_o.value:
            data.append((dut.bits_is_second_00_o.value, dut.bits_data_o.value))

    return data


@cocotb.test()
async def test_on_valid_data(dut):
    await setup(dut)

    samples = [
        # Idle period to synchronise
        1, 1, 1, 1, 1, 1,

        # A, B = 00, 01, 10, 11
        0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        0, 1, 0, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1,

        # Second 00
        0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
    ]

    cocotb.start_soon(feed_samples(dut, samples))

    data = await receive_data(dut, 1000)
    print(data)

    assert data[0] == (0, 0)
    assert data[1] == (0, 1)
    assert data[2] == (0, 2)
    assert data[3] == (0, 3)
    assert data[4] == (1, 0)
    assert len(data) == 5
