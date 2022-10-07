# Personal computers (PC)

## The system booting process

```
+- BIOS
|
1 - BIOS calls HDD device and reads the first sector 
|
|  +-----------------------------------------------------+
+- | HDD                                                 |
   +-----------------------------------------------------+
   | 0 sector | 1 sector | 2 sector| 3 sector | ...      |
   +-----------------------------------------------------+
   |           \
   |            ---------------------
   |                                  \
   +-----------------------------------+
   | MBR  | Partition table  | 55AAh   |
   +-----------------------------------+
   |                         |         |
   |<--------- 512 B ------->|<- 2 B ->|
   |                         |         |
|
2 - Control is passed to the first sector with the address 0000:7C00h
|
|  +------------+
|  | RAM        |
|  +------------+
|  | ...        | 
+- | 0000:7C00h | 
   | ...        | 

```

## Boot devices
The boot device is the device from which the operating system is loaded. A modern PC's UEFI or BIOS firmware supports booting from various devices, typically a local solid state drive or hard disk drive via the GPT or Master Boot Record (MBR) on such a drive or disk, an optical disc drive (using El Torito), a USB mass storage device (FTL-based flash drive, SD card or multi-media card slot, USB hard disk drive, USB optical disc drive, etc.), or a network interface card (using PXE). Older, less common BIOS-bootable devices include floppy disk drives, Zip drives, and LS-120 drives.

Typically, the system firmware (UEFI or BIOS) will allow the user to configure a boot order. 

## Boot sequence
Upon starting, an IBM-compatible personal computer's x86 CPU, executes in real mode, the instruction located at reset vector (the physical memory address FFFF0h on 16-bit x86 processors[60] and FFFFFFF0h on 32-bit and 64-bit x86 processors[61][62]), usually pointing to the firmware (UEFI or BIOS) entry point inside the ROM. This memory location typically contains a jump instruction that transfers execution to the location of the firmware (UEFI or BIOS) start-up program. This program runs a power-on self-test (POST) to check and initialize required devices such as main memory (DRAM), the PCI bus and the PCI devices (including running embedded Option ROMs). One of the most involved steps is setting up DRAM over SPD, further complicated by the fact that at this point memory is very limited.

After initializing required hardware, the firmware (UEFI or BIOS) goes through a pre-configured list of non-volatile storage devices ("boot device sequence") until it finds one that is bootable. A bootable MBR device is defined as one that can be read from, and where the last two bytes of the first sector contain the little-endian word AA55h,[nb 5] found as byte sequence 55h, AAh on disk (also known as the MBR boot signature), or where it is otherwise established that the code inside the sector is executable on x86 PCs.

Once the BIOS has found a bootable device it loads the boot sector to linear address 7C00h (usually segment:offset 0000h:7C00h,[50][52]: 29  but some BIOSes erroneously use 07C0h:0000h[citation needed]) and transfers execution to the boot code. In the case of a hard disk, this is referred to as the Master Boot Record (MBR). The conventional MBR code checks the MBR's partition table for a partition set as bootable[nb 6] (the one with active flag set). If an active partition is found, the MBR code loads the boot sector code from that partition, known as Volume Boot Record (VBR), and executes it. The MBR boot code is often operating-system specific.

### MBR
MBR is stored at LBA 0, and the GPT header is in LBA 1.


# Cheets
```
AA55h       - MBR signature
0000h:7C00h - here loaded Boot sector
```
