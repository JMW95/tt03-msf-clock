#!/bin/sh

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

# Run with `gate` as first argument to run a gate-level simulation instead
TYPE=${1:-normal}

export GATES="no"
if [ "x$TYPE" = "xgate" ]; then
    export GATES="yes"
    cp runs/wokwi/results/final/verilog/gl/jmw95_top.v test/test_top/gate_level_netlist.v
fi

# Run tests
cd test
make
