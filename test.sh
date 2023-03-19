#!/bin/sh

set -eux

. ./env

if ! which iverilog; then
    sudo apt install iverilog verilator
fi

# Install python deps
if ! which cocotb-config; then
    pip install -qr requirements.txt
fi

# Run tests
cd test
make
