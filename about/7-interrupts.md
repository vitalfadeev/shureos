# Interrupts
```
+-----------------------------------------------+
| Event                                         | ; with **vector number**
+-----------------------+-----------------------+
| Exception             | Interrupt             |
+-------+-------+-------+                       |
| fault | trap  | abort |                       |
+-------+-------+-------+-----------------------+
```

fault : allows the program to be restarted. 
        return address: to the faulting instruction.
trap  : allow execution. 
        return address: to instruction after the trapping instruction.
abort : not allow a restart of the program or task. 
        return address: no

**Exceptions** occur when the processor detects an error condition while executing an instruction, such as division by zero.

**Interrupts** occur at random times during the execution of a program, in response to signals from hardware.

## Verctors
 16 predefined exceptions
 18 standard ISA interrupts
 14 reserved
208 user defined interrupts
--- -----------------------
256 vectors

Vector numbers in the range 0 through 31 are reserved by the Intel 64 and IA-32 architectures for architecture-defined exceptions and interrupts.

Associated with entries in the IDT.

```
+-------------+--------------------------------------------------------------+
| 0 ...  31   | 32 ... 255                                                   |
+-------------+--------------------------------------------------------------+
  Predefined    I/O devices  
```

```
Vector  Mnemonic  Description          Type       Error  Source
------  --------  -------------------  ---------  -----  -------------------------------
     0  #DE       Divide Error         Fault      No     DIV and IDIV instructions
     1  #DB       Debug Exception      Fault/     No     Instruction, data, and 
                                       Trap              I/O breakpoints single-step and 
                                                         others
     2  —         NMI Interrupt        Interrupt  No     Nonmaskable external interrupt
     3  #BP       Breakpoint           Trap       No     INT3 instruction
     4  #OF       Overflow             Trap       No     INTO instruction
     5  #BR       BOUND Range Exceeded Fault      No     BOUND instruction
     6  #UD       Invalid Opcode       Fault      No     UD instruction or 
                  (Undefined Opcode)                     reserved opcode
     7  #NM       Device Not Available Fault      No     Floating-point or 
                  (No MathCoprocessor)                   WAIT/FWAIT instruction
     8  #DF       DoubleFault          Abort      Yes    Any instruction that can
                                                  (zero) generate an exception, 
                                                         an NMI, or an INTR
     9  -         Coprocessor Segment  Fault      No     Floating-point instruction
                  Overrun (reserved)   
    10  #TS       Invalid TSS          Fault      Yes    Task switch or TSS access
    11  #NP       Segment Not Present  Fault      Yes    Loading segment registers or
                                                         accessing system segments
    12  #SS       Stack-Segment Fault  Fault      Yes    Stack operations and SS 
                                                         register loads
    13  #GP       General Protection   Fault      Yes    Any memory reference and 
                                                         other protection checks
    14  #PF       Page Fault           Fault      Yes    Any memory reference
    15  —         (Intel reserved.                No
                  Do not use.)   
    16  #MF       x87 FPU              Fault      No     x87 FPU floating-point or 
                  Floating-Point Error                   WAIT/FWAIT instruction
                  (Math Fault)                    
    17  #AC       Alignment Check      Fault      Yes    Any data reference in memory
                                                  (Zero)
    18  #MC       Machine Check        Abort      No     Error codes (if any) and 
                                                         source are model dependent
    19  #XM       SIMD Floating-Point  Fault      No     SSE/SSE2/SSE3 floating-point
                  Exception                              instructions
    20  #VE       Virtualization       Fault      No     EPT violations
                  Exception
    21-31         Intel reserved. 
                  Do not use.
    32-255        User Defined         Interrupt  No     External interrupt or
                  (Non-reserved)                         INT n instruction
                  Interrupts
```


## Standard ISA IRQs
```
Vec  IRQ  Description
---  ---  --------------------------------------------------------
 32    0  Programmable Interrupt Timer Interrupt
 33    1  Keyboard Interrupt
 34    2  Cascade (used internally by the two PICs. never raised)
 35    3  COM2 (if enabled)
 36    4  COM1 (if enabled)
 37    5  LPT2 (if enabled)
 38    6  Floppy Disk
 39    7  LPT1 / Unreliable "spurious" interrupt (usually)
 40    8  CMOS real-time clock (if enabled)
 41    9  Free for peripherals / legacy SCSI / NIC
 42   10  Free for peripherals / SCSI / NIC
 43   11  Free for peripherals / SCSI / NIC
 44   12  PS2 Mouse
 45   13  FPU / Coprocessor / Inter-processor
 46   14  Primary ATA Hard Disk
 47   15  Secondary ATA Hard Disk
```


## Default PC Interrupt Vector Assignment
```
Int     Description
----    ----------------------------------------------------------
0-31    Protected Mode Exceptions (Reserved by Intel)
8-15    Default mapping of IRQ0-7 by the BIOS at bootstrap
70h-78h Default mapping of IRQ8-15 by the BIOS at bootstrap
```

## IDT
External interrupts, software interrupts and exceptions are handled through the interrupt descriptor table (IDT).

The IDT stores a collection of gate descriptors that provide access to interrupt and exception handlers.

Gate descriptors in the IDT can be:
- interrupt
- trap
- task

Only 256 interrupt or exception vectors.

### IDT entry (gate descriptor)
8 Byte in IA-32 protected mode.
For found index into the IDT, the processor scales the exception or interrupt vector by 8 (the number of bytes in a gate descriptor).
```
    offset = interrupt_number * 8
    interrupt_address = idtr + offset
```

All empty descriptor slots in the IDT should have the present flag for the
descriptor set to 0.

### IDT entry in long mode

Example type_attributes values that people are likely to use (assuming DPL is 0):
- 64-bit Interrupt Gate: 0x8E 
  (p=1, dpl=0b00, type=0b1110 => type_attributes=0b1000_1110=0x8E)

```
127                                 95                                 64
+--------+--------+--------+--------+--------+--------+--------+--------+
|                 |                 |********_********|********_********| offset 32..63
|********_********|********_********|                 |                 | reserved
+--------+--------+--------+--------+--------+--------+--------+--------+

63                47       39       31                15               0 
+--------+--------+--------+--------+--------+--------+--------+--------+
|                 |                 |                 |********_********| offset  0..15
|                 |                 |********_********|                 | segment selector
|                 |         ********|                 |                 | IST
|                 |         .....   |                 |                 |   reserved
|                 |              ...|                 |                 |   IST offset
|                 |********         |                 |                 | type attributes
|                 |.                |                 |                 |   P
|                 | ..              |                 |                 |   DPL
|                 |   .             |                 |                 |   0
|                 |    .            |                 |                 |   D
|                 |     ...         |                 |                 |   gate type
|********_********|                 |                 |                 | offset 16..31
+--------+--------+--------+--------+--------+--------+--------+--------+
DPL      - Descriptor Privilege Level
Offset   - Offset to procedure entry point
P        - Segment Present flag
Selector - Segment Selector for destination code segment
D        - Size of gate: 1 = 32/64 bits; 0 = 16 bits
type     - 000 = reserved, 101 = task, 110 = interrupt, 111 = trap
IST      - Interrupt Stack Table
```

Empty gate desriptor
```asm
struc idt_64_gate_descriptor
{
    .offset_1 dw 00000000_00000000_b  ; offset bits 0..15
    .selector dw 00000000_00000000_b  ; a code segment selector in GDT or LDT
    .ist      db          00000000_b  ; ist
    ;                     .....       ;   bits 3..7: is zero.
    ;                          ...    ;   bits 0..2: Interrupt Stack Table offset
    .typeattr db 00000000_b           ; type attributes
    ;            .                    ;   P 
    ;             ..                  ;   DPL
    ;               .                 ;   0
    ;                .                ;   32/64 bit
    ;                 ...             ;   gate type
    .offset_2 dw 00000000_00000000_b  ; offset bits 16..31
    .offset_3 dd 00000000_00000000_00000000_00000000_b ; offset bits 32..63
    .reserved dd 00000000_00000000_00000000_00000000_b ; reserved
}
```

#### Task-gate descriptor
```asm
struc idt_64_task_gate_descriptor
{
    .unused_1 dw 00000000_00000000_b  ;
    .selector dw 00000000_00000000_b  ; TSS segment selector
    .unused_2 db          00000000_b  ; 
    .typeattr db 10001101_b           ; type attributes
    ;            .                    ;   P 
    ;             ..                  ;   DPL
    ;               .                 ;   0
    ;                .                ;   32/64 bit
    ;                 ...             ;   gate type
    .unused_3 dw 00000000_00000000_b  ;
    .unused_4 dd 00000000_00000000_00000000_00000000_b ;
    .unused_5 dd 00000000_00000000_00000000_00000000_b ;
}
```

#### Interrupt-gate descriptor
```asm
struc idt_64_interrupt_gate_descriptor
{
    .offset_1 dw 00000000_00000000_b  ; offset bits 0..15
    .selector dw 00000000_00000000_b  ; a code segment selector in GDT or LDT
    .ist      db          00000000_b  ; ist
    ;                     .....       ;   bits 3..7: is zero.
    ;                          ...    ;   bits 0..2: Interrupt Stack Table offset
    .typeattr db 10001110_b           ; type attributes
    ;            .                    ;   P 
    ;             ..                  ;   DPL
    ;               .                 ;   0
    ;                .                ;   32/64 bit
    ;                 ...             ;   gate type
    .offset_2 dw 00000000_00000000_b  ; offset bits 16..31
    .offset_3 dd 00000000_00000000_00000000_00000000_b ; offset bits 32..63
    .reserved dd 00000000_00000000_00000000_00000000_b ; reserved
}
```

#### Trap-gate descriptor
```asm
struc idt_64_trap_gate_descriptor
{
    .offset_1 dw 00000000_00000000_b  ; offset bits 0..15
    .selector dw 00000000_00000000_b  ; a code segment selector in GDT or LDT
    .ist      db          00000000_b  ; ist
    ;                     .....       ;   bits 3..7: is zero.
    ;                          ...    ;   bits 0..2: Interrupt Stack Table offset
    .typeattr db 10001110_b           ; type attributes
    ;            .                    ;   P 
    ;             ..                  ;   DPL
    ;               .                 ;   0
    ;                .                ;   32/64 bit
    ;                 ...             ;   gate type
    .offset_2 dw 00000000_00000000_b  ; offset bits 16..31
    .offset_3 dd 00000000_00000000_00000000_00000000_b ; offset bits 32..63
    .reserved dd 00000000_00000000_00000000_00000000_b ; reserved
}
```

## IDTR - location IDT
The linear address for the base of the IDT is contained in the IDT register (IDTR).

```
47                                  15               0
+--------+--------+--------+--------+--------+--------+
| base address                      | limit           |
+--------+--------+--------+--------+--------+--------+
```

### IDT and IDTR setup
```asm
align 16

idt_64_start:
    ; 256 entries
idt_64_end:

idtr_store:
    dw idt_64_end - idt_64_end - 1 ; limit. 16 bit
    dq idt_64_start                ; base.  64 bit

    ; Load IDT location into IDTR
    lidt [idtr_store]
```

## Handler procedure
### Exception handler procedure
Saved on stack: 
- SS          : 64 bit
- RSP         : 64 bit
- RFLAGS      : 64 bit
- CS          : 64 bit
- RIP         : 64 bit
- error_code  : 64 bit

### Interrupt handler procedure
Saved on stack: 
- SS          : 64 bit
- RSP         : 64 bit
- RFLAGS      : 64 bit
- CS          : 64 bit
- RIP         : 64 bit

### Error code
```
63                47                31                15               0
+--------+--------+--------+--------+--------+--------+--------+--------+
|                 |                 |                 |                *| EXT
|                 |                 |                 |               * | IDT
|                 |                 |                 |              *  | TI
|                 |                 |                 |********_*****   | SS Index
|********_********|********_********|********_********|                 | Reserved
+--------+--------+--------+--------+--------+--------+--------+--------+
SS Index  Segment Selector Index
```


### Code segment selector
```
+--------+--------+
|        |      **| RPL
|        |     *  | TI
|********|*****   | Index
+--------+--------+
Index : one of 0..8192 descriptors
TI    : Table indicator: 0 = GDT, 1 = LDT
RPL   : Rquested Privelege Level
```
