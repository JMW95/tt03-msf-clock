#!/bin/sh

set -eux

. ./env

#-- Checkout ancillary repos -------------------------------------------------

# Check support tools exist
TT=$(pwd)/tt-support-tools
if [ ! -d "$TT" ]; then
    echo "Cloning TT support tools repo..."
    git clone https://github.com/tinytapeout/tt-support-tools $TT
fi

#-- Install dependencies -----------------------------------------------------

# Install python deps
pip install wheel
pip install -qr $TT/requirements.txt

#-- Build --------------------------------------------------------------------

# Check docs
$TT/tt_tool.py --check-docs

# Create the PDF
$TT/tt_tool.py --create-pdf

# Collect visualation outputs
mkdir -p runs/docs
mv datasheet.md runs/docs
mv datasheet.pdf runs/docs
