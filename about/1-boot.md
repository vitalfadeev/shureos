# 1. The Startup
## Intel
(Intel® 64 and IA-32 Architectures Software Developer’s Manual, Volume 3A: System Programming Guide, Part 1) / (9.1 Initialization overview)

### Multi-processor init

```

  RESET pin +----------+    +---------------------+    +-----------------------------+
>-----------|   CPU    |--->| Built-In-Self-Test  |--->| Select Boot Strap Processor |-->
   INIT pin |          |    | (BIST)              |    | (BSP)                       |
>-----------|          |    +---------------------+    +-----------------------------+
            +----------+                                   |
                                                       +------+   +------+   +------+
                                                       | CPU1 |   | CPU2 |   | CPU3 |
                                                       +------+   +------+   +------+
                                                                    wait       wait
                                                
   +--------------------------+
-->| Execute code from CS:EIP |--->
   | (FFFF_FFF0)              | dl - boot drive
   +--------------------------+ al - error code (0 - no error)
   EEPROM code


   +------------------------+    +--------------+   
-->| Sector 0x0             |--->| Execute code |-->
   | (from bootable device) |    | at 0x7C00    |   
   +------------------------+    +--------------+   
   sector0.asm


   +--------------+   +--------------+   +--------------+   
-->| 16 bit mode  |-->| setup stack  |-->| 64 bit mode  |-->
   | real mode    |   |              |   | long mode    |   
   +--------------+   +--------------+   +--------------+   
   sector0.asm


   +------------------------+    +--------------+
-->| Sector 0x1             |--->| Execute code |--->
   |                        |    |              |
   +------------------------+    +--------------+
   sector1.asm


```

Start executing code from CS:EIP (FFFF_FFF0) (16 Bytes below uppest address)
( FFFF_0000 + FFF0 = FFFF_FFF0 )
EPROM software-initialization code
in real-address mode

It is the first step that involves switching the power ON. It supplies electricity to the main components like BIOS and processor.

### Cache
IA-32 processors (beginning with the Intel486 processor) and Intel 64 processors contain internal instruction and data caches. These caches are enabled by clearing the CD and NW flags in control register CR0. (They are set during a hardware reset.) 

### Real-Address Mode IDT
#### Setup Interrupt Descriptor Table (IDT)
- IDT_0
- IDT_1
#### Setup Interrupt Descriptor Table Location (IDTR = 0)
#### NMI Interrupt Handling

## AMD64
(Intel® 64 and IA-32 Architectures Software Developer’s Manual, Volume 3A: System Programming Guide, Part 1) / (14 AMD64 Technology Processor Initialization and Long Mode Activation)
### Mode
After a RESET or INIT, the processor is operating in 16-bit real mode.

### RAM
1 Mbyte of memory available.

### Registers
CS-selector     = 0xF000
CS-base_address = 0xFFFF_0000
EIP             = 0xFFF0

### First instruction
First instruction fetched from memory is located at physical-address FFFF_FFF0h (FFFF_0000h + 0000_FFF0h).

### Cache
Following a RESET (but not an INIT), all instruction and data caches are disabled, and their contents are invalidated.
Software can enable these caches by clearing the cache-disable bit (CR0.CD) to zero (RESET sets this bit to 1).


# 2. BIOS: Power On Self Test
It is an initial test performed by the BIOS. Further, this test performs an initial check on the input/output devices, computer’s main memory, disk drives, etc. Moreover, if any error occurs, the system produces a beep sound.

# 3. Loading of OS
In this step, the operating system is loaded into the main memory. The operating system starts working and executes all the initial files and instructions.
## 3.1. First-stage (Hardware initialization stage) boot loader
Such as BIOS, UEFI, coreboot, Libreboot and Das U-Boot. 
On the IBM PC, the boot loader in the Master Boot Record (MBR) and the Partition Boot Record (PBR)
The boot sector code is the first-stage boot loader. It is located on fixed disks and removable drives.

## 3.2. Second-stage (OS initialization stage) boot loader
Such as GNU GRUB, rEFInd, BOOTMGR, Syslinux, NTLDR or iBoot. 
Load an operating system properly and transfer execution to it.
The operating system subsequently initializes itself and may load extra device drivers.

# 4. System Configuration
In this step, the drivers are loaded into the main memory. Drivers are programs that help in the functioning of the peripheral devices.

# 5. Loading System Utilities
System utilities are basic functioning programs, for example, volume control, antivirus, etc. In this step, system utilities are loaded into the memory.

# 6. User Authentication
If any password has been set up in the computer system, the system checks for user authentication. Once the user enters the login Id and password correctly the system finally starts.
