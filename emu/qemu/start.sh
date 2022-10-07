#!/bin/bash
# Run emulator

cd `dirname "$0"`

gnome-terminal -- \
  ./qemu-system-x86_64  \
    -cpu SandyBridge \
    -m 1024  \
    -no-reboot \
    -display gtk \
    -drive format=raw,file=../../boot/x-disk-image/out/c.raw
