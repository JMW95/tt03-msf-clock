#include "asic.h"
#include "Vjmw95_top.h"


Asic::Asic()
{
    m_top = std::make_unique<Vjmw95_top>();
}


Asic::~Asic()
{
}


void Asic::trace(VerilatedVcdC* tfp)
{
    m_top->trace(tfp, 99);
}


void Asic::eval()
{
    m_top->eval();
}


void Asic::set_clk(bool value)
{
    m_top->io_in = (m_top->io_in & ~(1 << 0)) | (value << 0);
}


void Asic::set_rst(bool value)
{
    m_top->io_in = (m_top->io_in & ~(1 << 1)) | (value << 1);
}


void Asic::set_data(bool value)
{
    m_top->io_in = (m_top->io_in & ~(1 << 2)) | (value << 2);
}


bool Asic::shift_reg_sclk() const
{
    return (m_top->io_out >> 0) & 1;
}


bool Asic::shift_reg_data() const
{
    return (m_top->io_out >> 1) & 1;
}


bool Asic::shift_reg_latch() const
{
    return (m_top->io_out >> 2) & 1;
}
