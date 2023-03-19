#include <cstdio>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <chrono>
#include <thread>

#include "asic.h"
#include "display.h"


using namespace std::chrono_literals;


int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Asic asic{};
    Display display{};

    std::unique_ptr<VerilatedVcdC> tfp{};
    const char *flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && std::strcmp(flag, "+trace") == 0) {
        Verilated::traceEverOn(true);
        tfp = std::make_unique<VerilatedVcdC>();
        asic.trace(tfp.get());
        Verilated::mkdir("logs");
        tfp->open("logs/dump.vcd");
    }

    // TODO: This code is a total mess! Please re-write me

    auto real_t = std::chrono::steady_clock::now();

    asic.set_rst(true);

    uint64_t t = 0;
    for (size_t i = 0; i < 10000; i++) {
        real_t += 1ms;
        std::this_thread::sleep_until(real_t);

        asic.set_clk(false);
        asic.eval(); // Clock falling edge

        if (tfp) {
            tfp->dump(t++);
        }

        asic.set_clk(true);
        asic.eval(); // Clock rising edge

        display.update(asic.shift_reg_sclk(), asic.shift_reg_data(), asic.shift_reg_latch());
        display.print();

        asic.set_data((i % 1000) > 100);
        if (i == 10) {
            asic.set_rst(false);
        }

        if (tfp) {
            tfp->dump(t++);
        }
    }

    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }

    return 0;
}
