# APIC

## I/O APIC and Local APIC

Advanced Programmable Interrupt Controller (APIC)

```
+------------------+-------------------------------+
|   Chip set       |   CPU                         |
|                  |                               |
|                  |                               |
|   +----------+   |   +------------+   +------+   |
|   | I/O APIC |===|===| Local APIC |===| Core |   |
|   +----------+   |   +------------+   +------+   |
|                  |                               |
|                  |                               |
+------------------+-------------------------------+
```
The local APIC performs two primary functions for the processor:
- It receives interrupts from the processor’s interrupt pins, from internal sources and 
  from an external I/O APIC (or other external interrupt controller). 
  It sends these to the processor core for handling.
- In multiple processor (MP) systems, it sends and 
  receives interprocessor interrupt (IPI) messages to and 
  from other logical processors on the system bus. 
  PI messages can be used to distribute interrupts among the processors 
  in the system or to execute system wide functions 
  (such as, booting up processors or distributing work among a group of processors).

The external I/O APIC is part of Intel’s system chip set. Its primary function is to receive external interrupt events from the system and its associated I/O devices and relay them to the local APIC as interrupt messages. In MP systems, the I/O APIC also provides a mechanism for distributing external interrupts to the local APICs of selected processors or groups of processors on the system bus.

      
```  
      +--------------+
      |  Local APIC  |
1 ===>|              |
2 ===>|              |
3 ===>|              |
4 ===>|              |
5 ===>|              |
6 ===>|              |
7 ===>|              |
      +--------------+
```
Local APICs can receive interrupts from the following sources:
1. Locally connected I/O devices    (LINT0 and LINT1)
2. Externally connected I/O devices (I/O APIC)
3. Inter-processor interrupts       (IPI)
4. APIC timer generated interrupts
5. Performance monitoring counter interrupts
6. Thermal Sensor interrupts
7. APIC internal error interrupts

## Local APIC registers
The APIC registers are memory mapped and 
can be read and written to using the MOV instruction.

From FEE0_0000 4 kBytes.

Address    Register Name                            Software Read/Write
---------  ---------------------------------------  -------------------
FEE0 0000  Reserved
FEE0 0010  Reserved
FEE0 0020  Local APIC ID Register                   Read/Write.
FEE0 0030  Local APIC Version Register              Read Only.
FEE0 0040  Reserved
FEE0 0050  Reserved
FEE0 0060  Reserved
FEE0 0070  Reserved
FEE0 0080  Task Priority Register (TPR)             Read/Write.
FEE0 0090  Arbitration Priority Register1 (APR)     Read Only.
FEE0 00A0  Processor Priority Register (PPR)        Read Only.
FEE0 00B0  EOI RegisterWrite Only.
FEE0 00C0  Remote Read Register1 (RRD)              Read Only
FEE0 00D0  Logical Destination Register             Read/Write.
FEE0 00E0  Destination Format Register              Read/Write 
                                                    (see Section 10.6.2.2).
FEE0 00F0  Spurious Interrupt Vector Register       Read/Write 
                                                    (see Section 10.9).
FEE0 0100  In-Service Register (ISR); bits  31:  0  Read Only.
FEE0 0110  In-Service Register (ISR); bits  63: 32  Read Only.
FEE0 0120  In-Service Register (ISR); bits  95: 64  Read Only.
FEE0 0130  In-Service Register (ISR); bits 127: 96  Read Only.
FEE0 0140  In-Service Register (ISR); bits 159:128  Read Only.
FEE0 0150  In-Service Register (ISR); bits 191:160  Read Only.
FEE0 0160  In-Service Register (ISR); bits 223:192  Read Only.
FEE0 0170  In-Service Register (ISR); bits 255:224  Read Only.
FEE0 0180  Trigger Mode Register (TMR); bits 31: 0  Read Only.
FEE0 0190  Trigger Mode Register (TMR); bits 63:32  Read Only.
FEE0 01A0  Trigger Mode Register (TMR); bits 95:64  Read Only.

FEE0 01B0  Trigger Mode Register (TMR); bits 127:96         Read Only.
FEE0 01C0  Trigger Mode Register (TMR); bits 159:128        Read Only.
FEE0 01D0  Trigger Mode Register (TMR); bits 191:160        Read Only.
FEE0 01E0  Trigger Mode Register (TMR); bits 223:192        Read Only.
FEE0 01F0  Trigger Mode Register (TMR); bits 255:224        Read Only.
FEE0 0200  Interrupt Request Register (IRR); bits 31:0      Read Only.
FEE0 0210  Interrupt Request Register (IRR); bits 63:32     Read Only.
FEE0 0220  Interrupt Request Register (IRR); bits 95:64     Read Only.
FEE0 0230  Interrupt Request Register (IRR); bits 127:96    Read Only.
FEE0 0240  Interrupt Request Register (IRR); bits 159:128   Read Only.
FEE0 0250  Interrupt Request Register (IRR); bits 191:160   Read Only.
FEE0 0260  Interrupt Request Register (IRR); bits 223:192   Read Only.
FEE0 0270  Interrupt Request Register (IRR); bits 255:224   Read Only.
FEE0 0280  Error Status Register                            Read Only.
FEE0 0290
through
FEE0 02E0  Reserved
FEE0 02F0  LVT Corrected Machine Check Interrupt (CMCI) Register    Read/Write.
FEE0 0300  Interrupt Command Register (ICR); bits 0-31              Read/Write.
FEE0 0310  Interrupt Command Register (ICR); bits 32-63             Read/Write.
FEE0 0320  LVT Timer Register                                       Read/Write.
FEE0 0330  LVT Thermal Sensor Register2                             Read/Write.
FEE0 0340  LVT Performance Monitoring Counters Register3            Read/Write.
FEE0 0350  LVT LINT0 Register                                       Read/Write.
FEE0 0360  LVT LINT1 Register                                       Read/Write.
FEE0 0370  LVT Error Register                                       Read/Write.
FEE0 0380  Initial Count Register (for Timer)                       Read/Write.
FEE0 0390  Current Count Register (for Timer)                       Read Only.
FEE0 03A0 
through
FEE0 03D0  Reserved
FEE0 03E0  Divide Configuration Register (for Timer)
FEE0 03F0  Reserved

```asm
    mov   FEE0_0020_H, 0
```

### IPI
Inter Process Interrupts (IPIs)

## APIC
