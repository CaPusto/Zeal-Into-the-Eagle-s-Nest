#!/bin/bash

# Zeal 8-bit Eagle's Nest - Build Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

# Environment setup
export PATH=/home/ed/work/tools/sdcc-4.4.0/bin:/home/ed/work/tools/cmake-3.31.6-linux-x86_64/bin:$PATH
export ZOS_PATH=/home/ed/work/sdk/Zeal-8-bit-OS
export ZVB_SDK_PATH=/home/ed/work/sdk/Zeal-VideoBoard-SDK
export ZGDK_PATH=/home/ed/work/sdk/zeal-game-dev-kit
export COREUTILS_PATH=/home/ed/work/sdk/zeal-coreutils

echo "Building Into the Eagle's Nest for Zeal 8-bit..."
echo ""

cd "$PROJECT_DIR"

# Create build directory
if [ ! -d "build" ]; then
    mkdir build
fi

cd build

# Configure with CMake
echo "Configuring CMake..."
cmake .. || exit 1

# Build
echo "Building..."
make || exit 1

echo ""
echo "Build complete!"
echo "Binary: $PROJECT_DIR/bin/eaglenest.bin"
echo ""
echo "To run in emulator:"
echo "  $PROJECT_DIR/bin/run_emu.sh"

exit 0
