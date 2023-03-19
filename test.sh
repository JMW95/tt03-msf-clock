#!/bin/sh

# Usage:
#
#     # Run all tests:
#     ./test.sh
#
#     # Run gate level simulation
#     GATES=yes ./test.sh
#
#     # Clean all tests
#     ./test.sh clean
#
#     # Run testbench <test_foo>
#     ./test.sh <test_foo>

set -eux

. ./env

# Install apt deps
if ! which iverilog; then
    sudo apt install iverilog verilator
fi

# Install python deps
if ! which cocotb-config; then
    pip install -qr requirements.txt
fi

if [ "${GATES:-}" = "yes" ]; then
    cp runs/wokwi/results/final/verilog/gl/jmw95_top.v test/test_top/gate_level_netlist.v
fi

# Run tests
cd test
make $@
