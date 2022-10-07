#!/bin/bash
# Run emulator
cd `dirname "$0"`
env BXSHARE=./bios ./bochs -f  bochsrc -q

