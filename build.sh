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

# Check openlane exists
if [ ! -d "$OPENLANE_ROOT" ]; then
    echo "Cloning OpenLane repo..."
    git clone --depth=1 --branch $OPENLANE_TAG https://github.com/The-OpenROAD-Project/OpenLane.git $OPENLANE_ROOT
fi

# Check GDS2glTF exists
GDS2GLTF=$(pwd)/GDS2glTF
if [ ! -d "$GDS2GLTF" ]; then
    echo "Cloning GDS2glTF repo..."
    git clone https://github.com/mbalestrini/GDS2glTF $GDS2GLTF
fi

#-- Install dependencies -----------------------------------------------------

# Install python deps
pip install wheel
pip install -qr $TT/requirements.txt
pip install numpy gdspy triangle pygltflib

# Build openlane
(cd OpenLane && make)

#-- Build --------------------------------------------------------------------

# Fetch the Verilog from Wokwi API
$TT/tt_tool.py --create-user-config

# Run OpenLane to build the GDS
$TT/tt_tool.py --harden

# Yosys warnings
$TT/tt_tool.py --print-warnings

# Print some routing stats
$TT/tt_tool.py --print-stats

# Print some cell stats
$TT/tt_tool.py --print-cell-category

# Create png
$TT/tt_tool.py --create-png

# Create 3d view
$GDS2GLTF/gds2gltf.py ./runs/wokwi/results/final/gds/jmw95_top.gds > ./runs/gds2gltf.log

# Collect visualation outputs
mkdir -p runs/vis
mv gds_render.png runs/vis
mv gds_render.svg runs/vis
mv ./runs/wokwi/results/final/gds/jmw95_top.gds.gltf runs/vis
