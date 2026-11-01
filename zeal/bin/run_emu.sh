#!/bin/bash

# Zeal 8-bit Eagle's Nest - Run in Emulator Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Environment setup
export PATH=/home/ed/work/tools/sdcc-4.4.0/bin:/home/ed/work/zeal-native-linux-x64:$PATH
export ZOS_PATH=/home/ed/work/sdk/Zeal-8-bit-OS
export ZVB_SDK_PATH=/home/ed/work/sdk/Zeal-VideoBoard-SDK
export ZGDK_PATH=/home/ed/work/sdk/zeal-game-dev-kit
export ZEAL_NATIVE=/home/ed/work/zeal-native-linux-x64

# Check if binary exists
if [ ! -f "$SCRIPT_DIR/eaglenest.bin" ]; then
    echo "Error: eaglenest.bin not found in $SCRIPT_DIR"
    echo "Please compile the project first: cd $PROJECT_DIR && ./build.sh"
    exit 1
fi

# Run emulator
cd "$SCRIPT_DIR"

echo "Starting Zeal 8-bit Emulator with Into the Eagle's Nest..."
echo "Binary: $SCRIPT_DIR/eaglenest.bin"
echo ""

zeal-native --rom $ZEAL_NATIVE/zos/os_with_romdisk.img \
    -u ./eaglenest.bin \
    -H ./gen/

exit $?
