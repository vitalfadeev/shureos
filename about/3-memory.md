# Memory

## Physical memory layout

```
-----------------------+---------------+------------+--------------------------
linear address range   | size          | type       | use
-----------------------+---------------+------------+--------------------------
         0 -       3FF |         1_024 | RAM        | real-mode interrupt 
                       |               |            | vector table (IVT)
-----------------------+---------------+            +--------------------------
       400 -       4FF |           256 |            | BIOS data area (BDA)
-----------------------+---------------+            +--------------------------
       500 -      7BFF |        30_463 |            | free conventional memory  
                       |               |            | (below 1 meg)
                       |               |            |
       CF8             |             4 |            | PCI -W порт адреса Addr
       CFC             |               |            | PCI RW порт данных Data
-----------------------+---------------+            +--------------------------
      1000 -      7BFF |        27_648 |            | your OS stack             <- stack
-----------------------+---------------+            +--------------------------
      7C00 -      7DFF |           512 |            | your OS BootSector        <- sector0
-----------------------+---------------+            +--------------------------
      7E00 -    7_FFFF |       492_032 |            | conventional memory
-----------------------+---------------+            +--------------------------
    8_0000 -    9_FFFF |       131_072 |            | extended BIOS data area 
                       |               |            | (EBDA)
-----------------------+---------------+------------+--------------------------
    A_0000 -    B_7FFF |        98_304 | video RAM  | EGA/VGA framebuffers
-----------------------+---------------+            +--------------------------
    B_8000 -    B_FFFF |        32_768 |            | CGA text buffer
-----------------------+---------------+------------+--------------------------
    C_0000 -    C_7FFF |        32_768 | ROM        | EGA/VGA BIOS ROM
                       |               |            | (32K is typical size)
-----------------------+---------------+------------+--------------------------
    C_8000 -    E_FFFF |       163_840 | ROM        | BIOS Expansions
                       |               | Shadow RAM | ROM and hardware mapped / 
                       |               | HW RAM     | Shadow RAM
-----------------------+---------------+------------+--------------------------
    F_0000 -    F_FFFF |        65_536 | ROM        | motherboard BIOS 
                       |               |            | (64K is typical size)
                       |               |            | Shadow RAM
-----------------------+---------------+------------+--------------------------
   10_0000 - FEBF_FFFF | 4_272_947_200 | RAM        | free extended memory 
                       |               |            | (1 meg and above)
-----------------------+---------------+------------+--------------------------
  EC0_0000 - FFFF_FFFF |    20_971_520 | various    | motherboard BIOS, 
                       |               |            | PnP NVRAM, ACPI, etc.
                       |               |            |                    
 FEС0_0000 -           |               |            |  APIC registers
                       |               |            |
 FEE0_0000 - FEE0_1000 |          4096 |            | LAPIC registers:
 FEE0_0090             |             4 |            |   Arbitration Priority Register(APR)
 FEE0_00D0             |             4 |            |   Logical Destination Register (LDR)
 FEE0_00E0             |             4 |            |   Destination Format Register  (DFR)
 FEE0_0280             |             4 |            |   Error Status Register        (ESR)
                       |               |            |   Local Vector Table (LVT):
 FEE0_02F0             |             4 |            |     CMCI Register
                       |               |            |     Interrupt Command Register (ICR)
 FEE0_0300             |             4 |            |       bits (0 - 31)
 FEE0_0310             |             4 |            |       bits (32 - 63)
 FEE0_0320             |             4 |            |     Timer Register
 FEE0_0330             |             4 |            |     Thermal Monitor Register
 FEE0_0340             |             4 |            |     Performance Counter Register
 FEE0_0350             |             4 |            |     LINT0 Register
 FEE0_0360             |             4 |            |     LINT1 Register
 FEE0_0370             |             4 |            |     Error Register
                       |               |            |   LAPIC Timer:
 FEE0_0380             |             4 |            |     Initial Count Register
 FEE0_0390             |             4 |            |     Current Count Register
 FEE0_03E0             |             4 |            |     Divide Configuration Register
-----------------------+---------------+------------+--------------------------
```


## 0x0000:0000 - 0x0000:03FF Таблица векторов прерываний
Таблица векторов прерываний
Доступно 256 прерываний.
Каждый вектор занимает в x86 4 байта, в x86-64 16 байт - полный адрес.
Размер всей таблицы - 1 Кб ( x86-64 16*256=4096= 4 kB ).
В реальном режиме (Long mode) элементом IDT является 32/64-битный FAR-адрес обработчика прерывания.
Первый этап инициализации выполняется BIOS, перед загрузкой ОС. Второй непосредственно самой операционной системой.
Таблица прерываний глобальна. Размещение в физической памяти определяется регистром IDTR.
При возникновении прерывания (внешнего, аппаратного, или вызванного инструкцией Int):
- из IDT выбирается дескриптор шлюза, соответственно номеру прерывания;
- проверяются условия защиты (права доступа);
- при соблюдении условий защиты выполняется переход на подпрограмму-обработчик этого прерывания.

## 0xB8000 - VGA memory (text mode)
The VGA text buffer is located at physical memory address 0xB8000. Since this address is usually used by 16-bit x86 processes operating in real-mode, it is also the first half of memory segment 0xB800. The text buffer data can be read and written, and bitwise operations can be applied. A part of text buffer memory above the scope of the current mode is accessible, but is not shown.

## 0xFFFFFFF0
On 32-bit and 64-bit x86 processors.
Pointing to the firmware (UEFI or BIOS) entry point inside the ROM. This memory location typically contains a jump instruction that transfers execution to the location of the firmware (UEFI or BIOS) start-up program. This program runs a power-on self-test (POST) to check and initialize required devices such as main memory (DRAM), the PCI bus and the PCI devices (including running embedded Option ROMs).

## 0x7C00h boot code
(usually segment:offset 0000h:7C00h
Once the BIOS has found a bootable device it loads the boot sector to linear address 7C00h and transfers execution to the boot code.
In the case of a hard disk, this is referred to as the Master Boot Record (MBR)

## 0xFEE00000 LAPIC 
Регистры LAPIC расположены обычно по адресу 0xFEE00000

## 0xFEС00000 APIC I/O 
Регистры I/O APIC по адресу 0xFEС00000

## 0x0CF8 PCI Address
PCI -W порт адреса Address

+---+---------+-------+----------+--------+---------------+-+-+
|31 |30     24|23   16|15      11|10     8|7             2|1|0|
+---+---------+-------+----------+--------+---------------+-+-+
| с | резерв  |шина   |устройство| функция|Индекс регистра|0|0|
+---+---------+-------+----------+--------+---------------+-+-+

## 0x0CFC PCI Data
PCI RW порт данных Data


## Segmentation

Logical address -> Linear address
```
15             0    31 (63)                           0
+---------------+   +--------------------------------+
| Seg selector  |   | Other (Effective address)      |
+---------------+   +--------------------------------+
  |                                     |
  |                                     |
  |       Descriptor                    |
  |       table                         |
  |     +------------+ Base address     V
  +---->| Segment    |--------------->  +
        | descriptor |                  |
        +------------+                  |
                                        |
                        31 (63)         V               0
                        +--------------------------------+
                        | Linear address                 |
                        +--------------------------------+

```

### Segment selector
```
15              0
+----------------+
|*************   | 3-15 - Index
|             *  | 2    - Table Indicator (TI): 0-GDT, 1-LDT
|              **| 0-1  - Requested Privilege Level (RPL)
+----------------+
```

The first entry of the GDT is not used by the processor.

### Segment registers

Used for holding up to 6 segment selectors.

```
CS - code
SS - stack
DS - data
ES - |
FS - | additional data-segment registers
GS - |
```

### Segment descriptor
#### Data Segment descriptor 32
```asm
63                                31                                  0
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |                 |                 |********_********| Limit 0..15
|                  |                 |********_********|                 | Base  0..15
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |        _********|                 |                 | Base 16..23
|                  |    ****         |                 |                 | Type
|                  |       .         |                 |                 |   A
|                  |      .          |                 |                 |   W
|                  |     .           |                 |                 |   E
|                  |    .            |                 |                 |   0 (0: data)
|                  |   *             |                 |                 | S (1:code/data)
|                  | **              |                 |                 | DPL
|                  |*                |                 |                 | P
|              ****|                 |                 |                 | Limit 16..19
|             *    |                 |                 |                 | AVL
|            *     |                 |                 |                 | 0
|          *       |                 |                 |                 | B
|         *        |                 |                 |                 | G
|********_         |                 |                 |                 | Base  24..31
+--------+---------+--------+--------+--------+-------+---------+--------+
A      Accessed
W      Writable
E      Expansion Direction
DPL    Descriptor Privilege Level
P      Present
AVL    Available to Sys. Programmers
G      Granularity
B      Big
LIMIT  Segment Limit
```

#### Code Segment descriptor 32
```asm
63                                31                                  0
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |                 |                 |********_********| Limit 0..15
|                  |                 |********_********|                 | Base  0..15
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |        _********|                 |                 | Base 16..23
|                  |    ****         |                 |                 | Type
|                  |       .         |                 |                 |   A
|                  |      .          |                 |                 |   R
|                  |     .           |                 |                 |   C
|                  |    .            |                 |                 |   1 (1: code)
|                  |   *             |                 |                 | 1 (1:code|data)
|                  | **              |                 |                 | DPL
|                  |*                |                 |                 | P
|              ****|                 |                 |                 | Limit 16..19
|             *    |                 |                 |                 | AVL
|            *     |                 |                 |                 | 0
|          *       |                 |                 |                 | D
|         *        |                 |                 |                 | G
|********_         |                 |                 |                 | Base  24..31
+--------+---------+--------+--------+--------+-------+---------+--------+
A      Accessed
R      Readable
C      Conforming
DPL    Descriptor Privilege Level
P      Present
AVL    Available to Sys. Programmers
D      Default
G      Granularity
LIMIT  Segment Limit
```

#### System Segment descriptor 32
```asm
63                                31                                  0
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |                 |                 |********_********| Limit 0..15
|                  |                 |********_********|                 | Base  0..15
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |        _********|                 |                 | Base 16..23
|                  |    ****         |                 |                 | Type
|                  |   *             |                 |                 | (0: system)
|                  | **              |                 |                 | DPL
|                  |*                |                 |                 | P
|              ****|                 |                 |                 | Limit 16..19
|             *    |                 |                 |                 | -
|            *     |                 |                 |                 | 0
|          *       |                 |                 |                 | -
|         *        |                 |                 |                 | G
|********_         |                 |                 |                 | Base  24..31
+--------+---------+--------+--------+--------+-------+---------+--------+
A      Accessed
DPL    Descriptor Privilege Level
LIMIT  Segment Limit
P      Present
```

#### SYSTEM DESCRIPTOR TYPES
When the S (descriptor type) flag in a segment descriptor is clear, the descriptor type is a system descriptor. The processor recognizes the following types of system descriptors:
- Local descriptor-table (LDT) segment descriptor.
- Task-state segment (TSS) descriptor.
- Call-gate descriptor.
- Interrupt-gate descriptor.
- Trap-gate descriptor.
- Task-gate descriptor.



#### Code Segment descriptor 64

Code segments continue to exist in 64-bit mode even though, for address calculations, the segment base is treated as zero. Some code-segment (CS) descriptor content (the base address and limit fields) is ignored; the remaining fields function normally (except for the readable bit in the type field).

In 64-bit mode, the processor does not perform runtime limit checking on code or data segments. However, the processor does check descriptor-table limits.

```asm
63                                31                                  0
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |                 |--------_--------|--------_--------| - 
+--------+---------+--------+--------+--------+--------+--------+--------+
|                  |        _--------|                 |                 | -
|                  |    ****         |                 |                 | Type
|                  |       .         |                 |                 |   A
|                  |      .          |                 |                 |   R
|                  |     .           |                 |                 |   C
|                  |    .            |                 |                 |   1 (1: code)
|                  |   *             |                 |                 | S (1:code|data)
|                  | **              |                 |                 | DPL
|                  |*                |                 |                 | P
|              ----|                 |                 |                 | -
|             *    |                 |                 |                 | AVL
|            *     |                 |                 |                 | L
|          *       |                 |                 |                 | D
|         *        |                 |                 |                 | G
|--------_         |                 |                 |                 | -
+--------+---------+--------+--------+--------+-------+---------+--------+
A      Accessed
R      Readable
C      Conforming
DPL    Descriptor Privilege Level
P      Present
AVL    Available to Sys. Programmers
L      Long mode flag (64-bit mode)
D      Default
G      Granularity
S      System flag (1: code or data, 0: system)
-      ignored
```


### 32 bit example
```asm
struc gdt_32_descriptor_data_struct
{
    ;                ********_********
    .limit dw        00000000_00000000_b ; Limit 0..15
    ;                ********_********
    .base1 dw        00000000_00000000_b ; Base  0..15

    ;                ********_********
    .base2 db                 00000000_b ; Base 16..23
    .flags db        10010011_b          ; flags    (93_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1: code, 0: data
    ;                ****                ; 
    ;                   .                ;   S (1: code|data, 0: system)
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    .flags2 db                10000000_b ; flags 2  (80_h)
    ;                             ****   ; Limit 16..19
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .base3 db        00000000_b          ; Base  24..31
}
```
```asm
struc gdt_32_descriptor_code_struct
{
    ;                ********_********
    .limit dw        00000000_00000000_b ; Limit 0..15
    ;                ********_********
    .base1 dw        00000000_00000000_b ; Base  0..15

    ;                ********_********
    .base2 db                 00000000_b ; Base 16..23
    .flags db        10011010_b          ; flags    (9A_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1
    ;                ****                ; 
    ;                   .                ;   1
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    .flags2 db                10000000_b ; flags 2  (80_h)
    ;                             ****   ; Limit 16..19
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .base3 db        00000000_b          ; Base  24..31
}
```

### 64 bit example
```asm
struc gdt_64_descriptor_data_struct
{
    ;                ********_********
    .igno1 dw        00000000_00000000_b ; ignored
    ;                ********_********
    .igno2 dw        00000000_00000000_b ; ignored

    ;                ********_********
    .igno3 db                 00000000_b ; ignored
    .flags db        10010010_b          ; flags   (92_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1: code, 0: data
    ;                ****                ; 
    ;                   .                ;   S (1: code|data, 0: system)
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    .flags2 db                10100000_b ; flags 2  (A0_h)
    ;                             ****   ; ignored
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .igno4 db        00000000_b          ; ignored
}
```

```asm
struc gdt_64_descriptor_code_struct
{
    ;                ********_********
    .limit dw        00000000_00000000_b ; ignored
    ;                ********_********
    .base1 dw        00000000_00000000_b ; ignored

    ;                ********_********
    .base2 db                 00000000_b ; ignored
    .flags db        10011010_b          ; flags   (9A_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1
    ;                ****                ; 
    ;                   .                ;   1
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    .flags2 db                10100000_b ; flags 2  (A0_h)
    ;                             ****   ; ignored
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .base3 db        00000000_b          ; ignored
}

; A       Accessed
; AVL     Available to Sys. Programmer’s
; C       Conforming
; D       Default
; DPL     Descriptor Privilege Level
; L       64-Bit Flag
; G       Granularity
; R       Readable
; P       Present
```


### QEMU info mtree

```
(qemu) info mem
0000000000000000-0000000000200000 0000000000200000 -rw
0000007e00000000-0000007e40000000 0000000040000000 -r-
0000007e40000000-0000007e80000000 0000000040000000 -rw
0000007e80000000-0000007ec0000000 0000000040000000 -r-
0000007f00000000-0000007f40000000 0000000040000000 -r-
0000007f40000000-0000007f80000000 0000000040000000 -rw
(qemu) info registers 
RAX=00000000000000fc RBX=0000000000001f95 RCX=0000000000000000 RDX=0000000000000000
RSI=00000000000090aa RDI=00000000000b89fc RBP=0000000000003000 RSP=0000000000003000
R8 =0000000000000000 R9 =00008e0000080000 R10=000000000000ae00 R11=00008e0000080050
R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
RIP=000000000000824f RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0010 0000000000000000 00000fff 00a09300 DPL=0 DS   [-WA]
CS =0008 0000000000000000 00000fff 00a09a00 DPL=0 CS64 [-R-]
SS =0010 0000000000000000 00000fff 00a09300 DPL=0 DS   [-WA]
DS =0010 0000000000000000 00000fff 00a09300 DPL=0 DS   [-WA]
FS =0010 0000000000000000 00000fff 00a09300 DPL=0 DS   [-WA]
GS =0010 0000000000000000 00000fff 00a09300 DPL=0 DS   [-WA]
LDT=0000 0000000000000000 0000ffff 00008200 DPL=0 LDT
TR =0000 0000000000000000 0000ffff 00008b00 DPL=0 TSS64-busy
GDT=     0000000000007f80 00000017
IDT=     0000000000007d19 00000fff
CR0=80000011 CR2=0000000000000000 CR3=0000000000001000 CR4=00000020
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000500
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=0000000000000000 0000000000000000 XMM01=0000000000000000 0000000000000000
XMM02=0000000000000000 0000000000000000 XMM03=0000000000000000 0000000000000000
XMM04=0000000000000000 0000000000000000 XMM05=0000000000000000 0000000000000000
XMM06=0000000000000000 0000000000000000 XMM07=0000000000000000 0000000000000000
XMM08=0000000000000000 0000000000000000 XMM09=0000000000000000 0000000000000000
XMM10=0000000000000000 0000000000000000 XMM11=0000000000000000 0000000000000000
XMM12=0000000000000000 0000000000000000 XMM13=0000000000000000 0000000000000000
XMM14=0000000000000000 0000000000000000 XMM15=0000000000000000 0000000000000000
(qemu) info mtree
address-space: memory
  0000000000000000-ffffffffffffffff (prio 0, i/o): system
    0000000000000000-000000003fffffff (prio 0, ram): alias ram-below-4g @pc.ram 0000000000000000-000000003fffffff
    0000000000000000-ffffffffffffffff (prio -1, i/o): pci
      00000000000a0000-00000000000bffff (prio 1, i/o): vga-lowmem
      00000000000c0000-00000000000dffff (prio 1, rom): pc.rom
      00000000000e0000-00000000000fffff (prio 1, rom): alias isa-bios @pc.bios 0000000000020000-000000000003ffff
      00000000fd000000-00000000fdffffff (prio 1, ram): vga.vram
      00000000feb80000-00000000feb9ffff (prio 1, i/o): e1000-mmio
      00000000febb0000-00000000febb0fff (prio 1, i/o): vga.mmio
        00000000febb0000-00000000febb017f (prio 0, i/o): edid
        00000000febb0400-00000000febb041f (prio 0, i/o): vga ioports remapped
        00000000febb0500-00000000febb0515 (prio 0, i/o): bochs dispi interface
        00000000febb0600-00000000febb0607 (prio 0, i/o): qemu extended regs
      00000000fffc0000-00000000ffffffff (prio 0, rom): pc.bios
    00000000000a0000-00000000000bffff (prio 1, i/o): alias smram-region @pci 00000000000a0000-00000000000bffff
    00000000000c0000-00000000000c3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c0000-00000000000c3fff
    00000000000c4000-00000000000c7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c4000-00000000000c7fff
    00000000000c8000-00000000000cbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000c8000-00000000000cbfff
    00000000000cb000-00000000000cdfff (prio 1000, ram): alias kvmvapic-rom @pc.ram 00000000000cb000-00000000000cdfff
    00000000000cc000-00000000000cffff (prio 1, ram): alias pam-rom @pc.ram 00000000000cc000-00000000000cffff
    00000000000d0000-00000000000d3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d0000-00000000000d3fff
    00000000000d4000-00000000000d7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d4000-00000000000d7fff
    00000000000d8000-00000000000dbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000d8000-00000000000dbfff
    00000000000dc000-00000000000dffff (prio 1, ram): alias pam-rom @pc.ram 00000000000dc000-00000000000dffff
    00000000000e0000-00000000000e3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e0000-00000000000e3fff
    00000000000e4000-00000000000e7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e4000-00000000000e7fff
    00000000000e8000-00000000000ebfff (prio 1, ram): alias pam-ram @pc.ram 00000000000e8000-00000000000ebfff
    00000000000ec000-00000000000effff (prio 1, ram): alias pam-ram @pc.ram 00000000000ec000-00000000000effff
    00000000000f0000-00000000000fffff (prio 1, ram): alias pam-rom @pc.ram 00000000000f0000-00000000000fffff
    00000000fec00000-00000000fec00fff (prio 0, i/o): ioapic
    00000000fed00000-00000000fed003ff (prio 0, i/o): hpet
    00000000fee00000-00000000feefffff (prio 4096, i/o): apic-msi

address-space: I/O
  0000000000000000-000000000000ffff (prio 0, i/o): io
    0000000000000000-0000000000000007 (prio 0, i/o): dma-chan
    0000000000000008-000000000000000f (prio 0, i/o): dma-cont
    0000000000000020-0000000000000021 (prio 0, i/o): pic
    0000000000000040-0000000000000043 (prio 0, i/o): pit
    0000000000000060-0000000000000060 (prio 0, i/o): i8042-data
    0000000000000061-0000000000000061 (prio 0, i/o): pcspk
    0000000000000064-0000000000000064 (prio 0, i/o): i8042-cmd
    0000000000000070-0000000000000071 (prio 0, i/o): rtc
      0000000000000070-0000000000000070 (prio 0, i/o): rtc-index
    000000000000007e-000000000000007f (prio 0, i/o): kvmvapic
    0000000000000080-0000000000000080 (prio 0, i/o): ioport80
    0000000000000081-0000000000000083 (prio 0, i/o): dma-page
    0000000000000087-0000000000000087 (prio 0, i/o): dma-page
    0000000000000089-000000000000008b (prio 0, i/o): dma-page
    000000000000008f-000000000000008f (prio 0, i/o): dma-page
    0000000000000092-0000000000000092 (prio 0, i/o): port92
    00000000000000a0-00000000000000a1 (prio 0, i/o): pic
    00000000000000b2-00000000000000b3 (prio 0, i/o): apm-io
    00000000000000c0-00000000000000cf (prio 0, i/o): dma-chan
    00000000000000d0-00000000000000df (prio 0, i/o): dma-cont
    00000000000000f0-00000000000000f0 (prio 0, i/o): ioportF0
    0000000000000170-0000000000000177 (prio 0, i/o): ide
    00000000000001ce-00000000000001d1 (prio 0, i/o): vbe
    00000000000001f0-00000000000001f7 (prio 0, i/o): ide
    0000000000000376-0000000000000376 (prio 0, i/o): ide
    0000000000000378-000000000000037f (prio 0, i/o): parallel
    00000000000003b4-00000000000003b5 (prio 0, i/o): vga
    00000000000003ba-00000000000003ba (prio 0, i/o): vga
    00000000000003c0-00000000000003cf (prio 0, i/o): vga
    00000000000003d4-00000000000003d5 (prio 0, i/o): vga
    00000000000003da-00000000000003da (prio 0, i/o): vga
    00000000000003f1-00000000000003f5 (prio 0, i/o): fdc
    00000000000003f6-00000000000003f6 (prio 0, i/o): ide
    00000000000003f7-00000000000003f7 (prio 0, i/o): fdc
    00000000000003f8-00000000000003ff (prio 0, i/o): serial
    00000000000004d0-00000000000004d0 (prio 0, i/o): elcr
    00000000000004d1-00000000000004d1 (prio 0, i/o): elcr
    0000000000000510-0000000000000511 (prio 0, i/o): fwcfg
    0000000000000514-000000000000051b (prio 0, i/o): fwcfg.dma
    0000000000000600-000000000000063f (prio 0, i/o): piix4-pm
      0000000000000600-0000000000000603 (prio 0, i/o): acpi-evt
      0000000000000604-0000000000000605 (prio 0, i/o): acpi-cnt
      0000000000000608-000000000000060b (prio 0, i/o): acpi-tmr
    0000000000000700-000000000000073f (prio 0, i/o): pm-smbus
    0000000000000cf8-0000000000000cfb (prio 0, i/o): pci-conf-idx
    0000000000000cf9-0000000000000cf9 (prio 1, i/o): piix3-reset-control
    0000000000000cfc-0000000000000cff (prio 0, i/o): pci-conf-data
    0000000000005658-0000000000005658 (prio 0, i/o): vmport
    000000000000ae00-000000000000ae17 (prio 0, i/o): acpi-pci-hotplug
    000000000000af00-000000000000af1f (prio 0, i/o): acpi-cpu-hotplug
    000000000000afe0-000000000000afe3 (prio 0, i/o): acpi-gpe0
    000000000000c000-000000000000c03f (prio 1, i/o): e1000-io
    000000000000c040-000000000000c04f (prio 1, i/o): piix-bmdma-container
      000000000000c040-000000000000c043 (prio 0, i/o): piix-bmdma
      000000000000c044-000000000000c047 (prio 0, i/o): bmdma
      000000000000c048-000000000000c04b (prio 0, i/o): piix-bmdma
      000000000000c04c-000000000000c04f (prio 0, i/o): bmdma

address-space: cpu-memory-0
  0000000000000000-ffffffffffffffff (prio 0, i/o): system
    0000000000000000-000000003fffffff (prio 0, ram): alias ram-below-4g @pc.ram 0000000000000000-000000003fffffff
    0000000000000000-ffffffffffffffff (prio -1, i/o): pci
      00000000000a0000-00000000000bffff (prio 1, i/o): vga-lowmem
      00000000000c0000-00000000000dffff (prio 1, rom): pc.rom
      00000000000e0000-00000000000fffff (prio 1, rom): alias isa-bios @pc.bios 0000000000020000-000000000003ffff
      00000000fd000000-00000000fdffffff (prio 1, ram): vga.vram
      00000000feb80000-00000000feb9ffff (prio 1, i/o): e1000-mmio
      00000000febb0000-00000000febb0fff (prio 1, i/o): vga.mmio
        00000000febb0000-00000000febb017f (prio 0, i/o): edid
        00000000febb0400-00000000febb041f (prio 0, i/o): vga ioports remapped
        00000000febb0500-00000000febb0515 (prio 0, i/o): bochs dispi interface
        00000000febb0600-00000000febb0607 (prio 0, i/o): qemu extended regs
      00000000fffc0000-00000000ffffffff (prio 0, rom): pc.bios
    00000000000a0000-00000000000bffff (prio 1, i/o): alias smram-region @pci 00000000000a0000-00000000000bffff
    00000000000c0000-00000000000c3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c0000-00000000000c3fff
    00000000000c4000-00000000000c7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c4000-00000000000c7fff
    00000000000c8000-00000000000cbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000c8000-00000000000cbfff
    00000000000cb000-00000000000cdfff (prio 1000, ram): alias kvmvapic-rom @pc.ram 00000000000cb000-00000000000cdfff
    00000000000cc000-00000000000cffff (prio 1, ram): alias pam-rom @pc.ram 00000000000cc000-00000000000cffff
    00000000000d0000-00000000000d3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d0000-00000000000d3fff
    00000000000d4000-00000000000d7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d4000-00000000000d7fff
    00000000000d8000-00000000000dbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000d8000-00000000000dbfff
    00000000000dc000-00000000000dffff (prio 1, ram): alias pam-rom @pc.ram 00000000000dc000-00000000000dffff
    00000000000e0000-00000000000e3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e0000-00000000000e3fff
    00000000000e4000-00000000000e7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e4000-00000000000e7fff
    00000000000e8000-00000000000ebfff (prio 1, ram): alias pam-ram @pc.ram 00000000000e8000-00000000000ebfff
    00000000000ec000-00000000000effff (prio 1, ram): alias pam-ram @pc.ram 00000000000ec000-00000000000effff
    00000000000f0000-00000000000fffff (prio 1, ram): alias pam-rom @pc.ram 00000000000f0000-00000000000fffff
    00000000fec00000-00000000fec00fff (prio 0, i/o): ioapic
    00000000fed00000-00000000fed003ff (prio 0, i/o): hpet
    00000000fee00000-00000000feefffff (prio 4096, i/o): apic-msi

address-space: cpu-smm-0
  0000000000000000-ffffffffffffffff (prio 0, i/o): memory
    0000000000000000-00000000ffffffff (prio 1, i/o): alias smram @smram 0000000000000000-00000000ffffffff
    0000000000000000-ffffffffffffffff (prio 0, i/o): alias memory @system 0000000000000000-ffffffffffffffff

address-space: i440FX
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

address-space: PIIX3
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

address-space: VGA
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

address-space: e1000
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

address-space: piix3-ide
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

address-space: PIIX4_PM
  0000000000000000-ffffffffffffffff (prio 0, i/o): bus master container

memory-region: pc.ram
  0000000000000000-000000003fffffff (prio 0, ram): pc.ram

memory-region: pc.bios
  00000000fffc0000-00000000ffffffff (prio 0, rom): pc.bios

memory-region: pci
  0000000000000000-ffffffffffffffff (prio -1, i/o): pci
    00000000000a0000-00000000000bffff (prio 1, i/o): vga-lowmem
    00000000000c0000-00000000000dffff (prio 1, rom): pc.rom
    00000000000e0000-00000000000fffff (prio 1, rom): alias isa-bios @pc.bios 0000000000020000-000000000003ffff
    00000000fd000000-00000000fdffffff (prio 1, ram): vga.vram
    00000000feb80000-00000000feb9ffff (prio 1, i/o): e1000-mmio
    00000000febb0000-00000000febb0fff (prio 1, i/o): vga.mmio
      00000000febb0000-00000000febb017f (prio 0, i/o): edid
      00000000febb0400-00000000febb041f (prio 0, i/o): vga ioports remapped
      00000000febb0500-00000000febb0515 (prio 0, i/o): bochs dispi interface
      00000000febb0600-00000000febb0607 (prio 0, i/o): qemu extended regs
    00000000fffc0000-00000000ffffffff (prio 0, rom): pc.bios

memory-region: smram
  0000000000000000-00000000ffffffff (prio 0, i/o): smram
    00000000000a0000-00000000000bffff (prio 0, ram): alias smram-low @pc.ram 00000000000a0000-00000000000bffff

memory-region: system
  0000000000000000-ffffffffffffffff (prio 0, i/o): system
    0000000000000000-000000003fffffff (prio 0, ram): alias ram-below-4g @pc.ram 0000000000000000-000000003fffffff
    0000000000000000-ffffffffffffffff (prio -1, i/o): pci
      00000000000a0000-00000000000bffff (prio 1, i/o): vga-lowmem
      00000000000c0000-00000000000dffff (prio 1, rom): pc.rom
      00000000000e0000-00000000000fffff (prio 1, rom): alias isa-bios @pc.bios 0000000000020000-000000000003ffff
      00000000fd000000-00000000fdffffff (prio 1, ram): vga.vram
      00000000feb80000-00000000feb9ffff (prio 1, i/o): e1000-mmio
      00000000febb0000-00000000febb0fff (prio 1, i/o): vga.mmio
        00000000febb0000-00000000febb017f (prio 0, i/o): edid
        00000000febb0400-00000000febb041f (prio 0, i/o): vga ioports remapped
        00000000febb0500-00000000febb0515 (prio 0, i/o): bochs dispi interface
        00000000febb0600-00000000febb0607 (prio 0, i/o): qemu extended regs
      00000000fffc0000-00000000ffffffff (prio 0, rom): pc.bios
    00000000000a0000-00000000000bffff (prio 1, i/o): alias smram-region @pci 00000000000a0000-00000000000bffff
    00000000000c0000-00000000000c3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c0000-00000000000c3fff
    00000000000c4000-00000000000c7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000c4000-00000000000c7fff
    00000000000c8000-00000000000cbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000c8000-00000000000cbfff
    00000000000cb000-00000000000cdfff (prio 1000, ram): alias kvmvapic-rom @pc.ram 00000000000cb000-00000000000cdfff
    00000000000cc000-00000000000cffff (prio 1, ram): alias pam-rom @pc.ram 00000000000cc000-00000000000cffff
    00000000000d0000-00000000000d3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d0000-00000000000d3fff
    00000000000d4000-00000000000d7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000d4000-00000000000d7fff
    00000000000d8000-00000000000dbfff (prio 1, ram): alias pam-rom @pc.ram 00000000000d8000-00000000000dbfff
    00000000000dc000-00000000000dffff (prio 1, ram): alias pam-rom @pc.ram 00000000000dc000-00000000000dffff
    00000000000e0000-00000000000e3fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e0000-00000000000e3fff
    00000000000e4000-00000000000e7fff (prio 1, ram): alias pam-rom @pc.ram 00000000000e4000-00000000000e7fff
    00000000000e8000-00000000000ebfff (prio 1, ram): alias pam-ram @pc.ram 00000000000e8000-00000000000ebfff
    00000000000ec000-00000000000effff (prio 1, ram): alias pam-ram @pc.ram 00000000000ec000-00000000000effff
    00000000000f0000-00000000000fffff (prio 1, ram): alias pam-rom @pc.ram 00000000000f0000-00000000000fffff
    00000000fec00000-00000000fec00fff (prio 0, i/o): ioapic
    00000000fed00000-00000000fed003ff (prio 0, i/o): hpet
    00000000fee00000-00000000feefffff (prio 4096, i/o): apic-msi
```

## Allocate

```
0..2**64

Pages: 
0 2**64 / 2**8
1 2**56 / 2**8
2 2**48 / 2**8
3 2**40 / 2**8
4 2**32 / 2**8
5 2**24 / 2**8
6 2**16 / 2**8
7 2**8  / 2**8

+------------------------------+
| 0
| ...
| 255
+------------------------------+
| Page ( 2**64 - 2**8 Bytes )
+------------------------------+

Used:
 0 2**64 = ~10 844 674 407 000 000 000 Bytes 
 1 2**56 =      72 057 594 037 927 936 Bytes
 2 2**48 =         281 474 976 710 656 Bytes ( 281 TBytes )
 3 2**40 =           1 099 511 627 776 Bytes (   1 TBytes )
 4 2**32 =               4 294 967 296 Bytes (   4 GBytes )
 5 2**24 =                  16 777 216 Bytes
 6 2**16 =                      65 526 Bytes
 7 2**8  =                         256 Bytes

Free:
 0
 1
 2
 3
 4
 5
 6
 7

Page:
+--------------+
| Size         |
+--------------+
| Next         |
+--------------+
| Block        |
|              |
|              |
+--------------+

```
