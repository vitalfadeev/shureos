FASM=$(CURDIR)/_/fasm
INCLUDE=$(CURDIR)/_/inc

.EXPORT_ALL_VARIABLES:
all:
	cd boot ; make -s
	./start-emulator.sh