#include <cstdio>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <chrono>
#include <thread>
#include <string>
#include <vector>
#include <fstream>

#include "asic.h"
#include "display.h"


using namespace std::chrono_literals;



class IDataSource
{
public:
    virtual ~IDataSource() {};
    virtual bool next_sample() = 0;
    virtual bool done() const = 0;
};


class DumbDataSource : public IDataSource
{
public:
    bool next_sample() override;
    bool done() const override;
    uint64_t m_idx = 0;
};


bool DumbDataSource::next_sample()
{
    m_idx++;
    return (m_idx % 1000) > 100;
}


bool DumbDataSource::done() const
{
    return false;
}


class FileDataSource : public IDataSource
{
public:
    FileDataSource(std::string path);
    bool next_sample() override;
    bool done() const override;
private:
    size_t m_idx = 0;
    std::vector<uint8_t> m_samples;
};


FileDataSource::FileDataSource(std::string path)
{
    std::ifstream f{path};

    if (!f) {
        std::fprintf(stderr, "ERROR: Failed to open file %s\n", path.c_str());
        std::exit(1);
    }

    std::string line;
    while (std::getline(f, line)) {
        try {
            m_samples.push_back(std::stoi(line));
        } catch(std::exception const&) {
            std::fprintf(stderr, "ERROR: Failed to parse line\n");
            exit(1);
        }
    }
}


bool FileDataSource::next_sample()
{
    if (m_idx < m_samples.size())
    {
        return m_samples[m_idx++];
    }

    return 0;
}


bool FileDataSource::done() const
{
    return m_idx >= m_samples.size();
}


int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Asic asic{};
    Display display{};
    FileDataSource data_source("../notebooks/test_data.csv");

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
    while (!data_source.done()) {
        real_t += 1ms;
        std::this_thread::sleep_until(real_t);

        asic.set_clk(false);
        asic.eval(); // Clock falling edge

        if (tfp) {
            tfp->dump(t);
        }
        t++;

        asic.set_clk(true);
        asic.eval(); // Clock rising edge

        display.update(asic.shift_reg_sclk(), asic.shift_reg_data(), asic.shift_reg_latch());
        display.print();

        asic.set_data(data_source.next_sample());
        if (t > 10) {
            asic.set_rst(false);
        }

        if (tfp) {
            tfp->dump(t);
        }
        t++;
    }

    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }

    return 0;
}
