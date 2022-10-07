;
; CPUID
;

macro cpuid.test_bit cpuid_number, reg, bit
{
    mov eax, 1
    cpuid
    bt  reg, bit
;     jc  bit_set
;     jnc bit_not_set
; bit_set:
;     ;
; bit_not_set:
;     ;
}

; EAX : Maximum Input Value for Basic CPUID Information.
; EBX : “Genu”
; ECX : “ntel”
; EDX : “ineI”
macro CPUID.00H
{
    mov     eax, 00_h
    cpuid
    ; cmp     eax, 1 ; test CPUID level
    ; je      cpu_level_1
}


; EAX : Version Information: Type, Family, Model, and Stepping ID (see Figure 3-6).
; EBX : Bits 07 - 00: Brand Index.
;       Bits 15 - 08: CLFLUSH line size (Value ∗ 8 = cache line size in bytes; used also by CLFLUSHOPT).
;       Bits 23 - 16: Maximum number of addressable IDs for logical processors in this physical package*.
;       Bits 31 - 24: Initial APIC ID**.
; ECX : Feature Information
; EDX : Feature Information
; NOTES:
;       * The nearest power-of-2 integer that is not smaller than EBX[23:16] is the number of unique initial APIC
;         IDs reserved for addressing different logical processors in a physical package. This field is only valid if
;         CPUID.1.EDX.HTT[bit 28]= 1.
;       ** The 8-bit initial APIC ID in EBX[31:24] is replaced by the 32-bit x2APIC ID, available in Leaf 0BH and
;         Leaf 1FH.
;
; EAX register
; 31       23       15        7      0
; +--------+--------+--------+--------+
; |        |        |        |    ****| Stepping ID
; |        |        |        |****    | Model
; |        |        |    ****|        | Family ID
; |        |        |  **    |        | Processor Type
; |        |        |**      |        | Reserved
; |        |    ****|        |        | Extended Model ID
; |    ****|****    |        |        | Extended Family ID
; |****    |        |        |        | Reserved
; +--------+--------+--------+--------+
; Processor Type Field
;   00_B : Original OEM Processor 
;   01_B : Intel OverDrive® Processor
;   10_B : Dual processor (not applicable to Intel486 processors)
;   11_B : Intel reserved

; CPUID Signature Values of DisplayFamily_DisplayModel
Intel_P6_85 equ 06_85_H ; Intel® Xeon Phi™ Processor 7215, 7285, 7295 Series based on Knights Mill microarchitecture
Intel_P6_57 equ 06_57_H ; Intel® Xeon Phi™ Processor 3200, 5200, 7200 Series based on Knights Landing microarchitecture
Intel_P6_7E equ 06_7E_H ; Future Intel® Core™ processors based on Ice Lake microarchitecture
Intel_P6_70 equ 06_7D_H ; 
Intel_P6_66 equ 06_66_H ; Intel® Core™ processors based on Cannon Lake microarchitecture
Intel_P6_9E equ 06_9E_H ; 7th generation Intel® Core™ processors based on Kaby Lake microarchitecture, 8th and 9th generation Intel® Core™ processors based on Coffee Lake microarchitecture, Intel® Xeon® E processors based on Coffee Lake microarchitecture
Intel_8E_8E equ 06_8E_H ; 
Intel_P6_6C equ 06_6C_H ; Future Intel® Xeon® processors based on Ice Lake microarchitecture
Intel_P6_6A equ 06_6A_H ; Intel® Xeon® Processor Scalable Family based on Skylake microarchitecture, 2nd generation Intel® Xeon® Processor Scalable Family based on Cascade Lake product, and future Cooper Lake product
Intel_P6_55 equ 06_55_H ; 
Intel_P6_5E equ 06_5E_H ; 6th generation Intel Core processors and Intel Xeon processor E3-1500m v5 product family and E3- 1200 v5 product family based on Skylake microarchitecture
Intel_P6_4E equ 06_4E_H ; 
Intel_P6_56 equ 06_56_H ; Intel Xeon processor D-1500 product family based on Broadwell microarchitecture
Intel_P6_4F equ 06_4F_H ; Intel Xeon processor E5 v4 Family based on Broadwell microarchitecture, Intel Xeon processor E7 v4 Family, Intel Core i7-69xx Processor Extreme Edition
Intel_P6_47 equ 06_47_H ; 5th generation Intel Core processors, Intel Xeon processor E3-1200 v4 product family based on Broadwell microarchitecture
Intel_P6_3D equ 06_3D_H ; Intel Core M-5xxx Processor, 5th generation Intel Core processors based on Broadwell microarchitecture




; 
; EBX register
; 31       23       15        7      0
; +--------+--------+--------+--------+
; |        |        |        |********| Brand Index.
; |        |        |********|        | CLFLUSH line size (Value ∗ 8 = cache line size in bytes; used also by CLFLUSHOPT).
; |        |********|        |        | Maximum number of addressable IDs for logical processors in this physical package*.
; |********|        |        |        | Initial APIC ID**.
; +--------+--------+--------+--------+
;
; Feature Information Returned in the ECX Register
; 31       23       15        7      0
; +--------+--------+--------+--------+
; |        |        |        |       *| SSE3
; |        |        |        |      * | PCLMULQDQ
; |        |        |        |     *  | DTES64
; |        |        |        |    *   | MONITOR
; |        |        |        |   *    | DS-CPL
; |        |        |        |  *     | VMX
; |        |        |        | *      | SMX
; |        |        |        |*       | EIST
; +--------+--------+--------+--------+ 
; |        |        |       *|        | TM2
; |        |        |      * |        | SSSE3
; |        |        |     *  |        | CNXT-ID
; |        |        |    *   |        | SDBG
; |        |        |   *    |        | FMA
; |        |        |  *     |        | CMPXCHG16B
; |        |        | *      |        | xTPR Update Control
; |        |        |*       |        | PDCM
; +--------+--------+--------+--------+ 
; |        |       *|        |        | Reserved
; |        |      * |        |        | PCID
; |        |     *  |        |        | DCA
; |        |    *   |        |        | SSE4.1
; |        |   *    |        |        | SSE4.2
; |        |  *     |        |        | x2APIC
; |        | *      |        |        | MOVBE
; |        |*       |        |        | POPCNT
; +--------+--------+--------+--------+ 
; |       *|        |        |        | TSC-Deadline
; |      * |        |        |        | AESNI
; |     *  |        |        |        | XSAVE
; |    *   |        |        |        | OSXSAVE
; |   *    |        |        |        | AVX
; |  *     |        |        |        | F16C
; | *      |        |        |        | RDRAND
; |*       |        |        |        | Not Used
; +--------+--------+--------+--------+
;  0 SSE3         Streaming SIMD Extensions 3 (SSE3). A value of 1 indicates the processor supports this
;                 technology.
;  1 PCLMULQDQ    PCLMULQDQ. A value of 1 indicates the processor supports the PCLMULQDQ instruction.
;  2 DTES64       64-bit DS Area. A value of 1 indicates the processor supports DS area using 64-bit layout.
;  3 MONITOR      MONITOR/MWAIT. A value of 1 indicates the processor supports this feature.
;  4 DS-CPL       CPL Qualified Debug Store. A value of 1 indicates the processor supports the extensions to the
;                 Debug Store feature to allow for branch message storage qualified by CPL.
;  5 VMX          Virtual Machine Extensions. A value of 1 indicates that the processor supports this technology.
;  6 SMX          Safer Mode Extensions. A value of 1 indicates that the processor supports this technology. See
;                 Chapter 6, “Safer Mode Extensions Reference”.
;  7 EIST         Enhanced Intel SpeedStep® technology. A value of 1 indicates that the processor supports this
;                 technology.
;  8 TM2          Thermal Monitor 2. A value of 1 indicates whether the processor supports this technology.
;  9 SSSE3        A value of 1 indicates the presence of the Supplemental Streaming SIMD Extensions 3 (SSSE3). A
;                 value of 0 indicates the instruction extensions are not present in the processor.
; 10 CNXT-ID      L1 Context ID. A value of 1 indicates the L1 data cache mode can be set to either adaptive mode
;                 or shared mode. A value of 0 indicates this feature is not supported. See definition of the
;                 IA32_MISC_ENABLE MSR Bit 24 (L1 Data Cache Context Mode) for details.
; 11 SDBG         A value of 1 indicates the processor supports IA32_DEBUG_INTERFACE MSR for silicon debug.
; 12 FMA          A value of 1 indicates the processor supports FMA extensions using YMM state.
; 13 CMPXCHG16B   CMPXCHG16B Available. A value of 1 indicates that the feature is available. See the
;                 “CMPXCHG8B/CMPXCHG16B—Compare and Exchange Bytes” section in this chapter for a
;                 description.
; 14 xTPR Update  xTPR Update Control. A value of 1 indicates that the processor supports changing
;    Control      IA32_MISC_ENABLE[bit 23].
; 15 PDCM         Perfmon and Debug Capability: A value of 1 indicates the processor supports the performance
;                 and debug feature indication MSR IA32_PERF_CAPABILITIES.
; 16 Reserved     Reserved
; 17 PCID         Process-context identifiers. A value of 1 indicates that the processor supports PCIDs and that
;                 software may set CR4.PCIDE to 1.
; 18 DCA          A value of 1 indicates the processor supports the ability to prefetch data from a memory mapped
;                 device.
; 19 SSE4.1       A value of 1 indicates that the processor supports SSE4.1.
; 20 SSE4.2       A value of 1 indicates that the processor supports SSE4.2.
; 21 x2APIC       A value of 1 indicates that the processor supports x2APIC feature.
; 22 MOVBE        A value of 1 indicates that the processor supports MOVBE instruction.
; 23 POPCNT       A value of 1 indicates that the processor supports the POPCNT instruction.
; 24 TSC-Deadline A value of 1 indicates that the processor’s local APIC timer supports one-shot operation using a
;                 TSC deadline value.
; 25 AESNI        A value of 1 indicates that the processor supports the AESNI instruction extensions.
; 26 XSAVE        A value of 1 indicates that the processor supports the XSAVE/XRSTOR processor extended states
;                 feature, the XSETBV/XGETBV instructions, and XCR0.
; 27 OSXSAVE      A value of 1 indicates that the OS has set CR4.OSXSAVE[bit 18] to enable XSETBV/XGETBV
;                 instructions to access XCR0 and to support processor extended state management using
;                 XSAVE/XRSTOR.
; 28 AVX          A value of 1 indicates the processor supports the AVX instruction extensions.
; 29 F16C         A value of 1 indicates that processor supports 16-bit floating-point conversion instructions.
; 30 RDRAND       A value of 1 indicates that processor supports RDRAND instruction.
; 31 Not Used     Always returns 0.
;
; Feature Information Returned in the EDX Register
; 31       23       15        7      0
; +--------+--------+--------+--------+
; |        |        |        |       *| FPU
; |        |        |        |      * | VME
; |        |        |        |     *  | DE
; |        |        |        |    *   | PSE
; |        |        |        |   *    | TSC
; |        |        |        |  *     | MSR
; |        |        |        | *      | PAE
; |        |        |        |*       | MCE
; +--------+--------+--------+--------+ 
; |        |        |       *|        | CX8
; |        |        |      * |        | APIC
; |        |        |     *  |        | Reserved
; |        |        |    *   |        | SEP
; |        |        |   *    |        | MTRR
; |        |        |  *     |        | PGE
; |        |        | *      |        | MCA
; |        |        |*       |        | CMOV
; +--------+--------+--------+--------+ 
; |        |       *|        |        | PAT
; |        |      * |        |        | PSE-36
; |        |     *  |        |        | PSN
; |        |    *   |        |        | CLFSH
; |        |   *    |        |        | Reserved
; |        |  *     |        |        | DS
; |        | *      |        |        | ACPI
; |        |*       |        |        | MMX
; +--------+--------+--------+--------+ 
; |       *|        |        |        | FXSR
; |      * |        |        |        | SSE
; |     *  |        |        |        | SSE2
; |    *   |        |        |        | SS
; |   *    |        |        |        | HTT
; |  *     |        |        |        | TM
; | *      |        |        |        | Reserved
; |*       |        |        |        | PBE
; +--------+--------+--------+--------+
;
;  0 FPU          Floating Point Unit On-Chip. The processor contains an x87 FPU.
;  1 VME          Virtual 8086 Mode Enhancements. Virtual 8086 mode enhancements, including CR4.VME for controlling the
;                 feature, CR4.PVI for protected mode virtual interrupts, software interrupt indirection, expansion of the TSS
;                 with the software indirection bitmap, and EFLAGS.VIF and EFLAGS.VIP flags.
;  2 DE           Debugging Extensions. Support for I/O breakpoints, including CR4.DE for controlling the feature, and optional
;                 trapping of accesses to DR4 and DR5.
;  3 PSE          Page Size Extension. Large pages of size 4 MByte are supported, including CR4.PSE for controlling the
;                 feature, the defined dirty bit in PDE (Page Directory Entries), optional reserved bit trapping in CR3, PDEs, and
;                 PTEs.
;  4 TSC          Time Stamp Counter. The RDTSC instruction is supported, including CR4.TSD for controlling privilege.
;  5 MSR          Model Specific Registers RDMSR and WRMSR Instructions. The RDMSR and WRMSR instructions are
;                 supported. Some of the MSRs are implementation dependent.
;  6 PAE          Physical Address Extension. Physical addresses greater than 32 bits are supported: extended page table
;                 entry formats, an extra level in the page translation tables is defined, 2-MByte pages are supported instead of
;                 4 Mbyte pages if PAE bit is 1.
;  7 MCE          Machine Check Exception. Exception 18 is defined for Machine Checks, including CR4.MCE for controlling the
;                 feature. This feature does not define the model-specific implementations of machine-check error logging,
;                 reporting, and processor shutdowns. Machine Check exception handlers may have to depend on processor
;                 version to do model specific processing of the exception, or test for the presence of the Machine Check feature.
;  8 CX8          CMPXCHG8B Instruction. The compare-and-exchange 8 bytes (64 bits) instruction is supported (implicitly
;                 locked and atomic).
;  9 APIC         APIC On-Chip. The processor contains an Advanced Programmable Interrupt Controller (APIC), responding to
;                 memory mapped commands in the physical address range FFFE0000H to FFFE0FFFH (by default - some
;                 processors permit the APIC to be relocated).
; 10 Reserved     Reserved
; 11 SEP          SYSENTER and SYSEXIT Instructions. The SYSENTER and SYSEXIT and associated MSRs are supported.
; 12 MTRR         Memory Type Range Registers. MTRRs are supported. The MTRRcap MSR contains feature bits that describe
;                 what memory types are supported, how many variable MTRRs are supported, and whether fixed MTRRs are
;                 supported.
; 13 PGE          Page Global Bit. The global bit is supported in paging-structure entries that map a page, indicating TLB entries
;                 that are common to different processes and need not be flushed. The CR4.PGE bit controls this feature.
; 14 MCA          Machine Check Architecture. A value of 1 indicates the Machine Check Architecture of reporting machine
;                 errors is supported. The MCG_CAP MSR contains feature bits describing how many banks of error reporting
;                 MSRs are supported.
; 15 CMOV         Conditional Move Instructions. The conditional move instruction CMOV is supported. In addition, if x87 FPU is
;                 present as indicated by the CPUID.FPU feature bit, then the FCOMI and FCMOV instructions are supported
; 16 PAT          Page Attribute Table. Page Attribute Table is supported. This feature augments the Memory Type Range
;                 Registers (MTRRs), allowing an operating system to specify attributes of memory accessed through a linear
;                 address on a 4KB granularity.
; 17 PSE-36       36-Bit Page Size Extension. 4-MByte pages addressing physical memory beyond 4 GBytes are supported with
;                 32-bit paging. This feature indicates that upper bits of the physical address of a 4-MByte page are encoded in
;                 bits 20:13 of the page-directory entry. Such physical addresses are limited by MAXPHYADDR and may be up to
;                 40 bits in size.
; 18 PSN          Processor Serial Number. The processor supports the 96-bit processor identification number feature and the
;                 feature is enabled.
; 19 CLFSH        CLFLUSH Instruction. CLFLUSH Instruction is supported.
; 20 Reserved     Reserved
; 21 DS           Debug Store. The processor supports the ability to write debug information into a memory resident buffer.
;                 This feature is used by the branch trace store (BTS) and processor event-based sampling (PEBS) facilities (see
;                 Chapter 23, “Introduction to Virtual-Machine Extensions,” in the Intel® 64 and IA-32 Architectures Software
;                 Developer’s Manual, Volume 3C).
; 2 2ACPI         Thermal Monitor and Software Controlled Clock Facilities. The processor implements internal MSRs that
;                 allow processor temperature to be monitored and processor performance to be modulated in predefined duty
;                 cycles under software control.
; 23 MMX          Intel MMX Technology. The processor supports the Intel MMX technology.
; 24 FXSR         FXSAVE and FXRSTOR Instructions. The FXSAVE and FXRSTOR instructions are supported for fast save and
;                 restore of the floating point context. Presence of this bit also indicates that CR4.OSFXSR is available for an
;                 operating system to indicate that it supports the FXSAVE and FXRSTOR instructions.
; 25 SSE          SSE. The processor supports the SSE extensions.
; 26 SSE2         SSE2. The processor supports the SSE2 extensions.
; 27 SS           Self Snoop. The processor supports the management of conflicting memory types by performing a snoop of its
;                 own cache structure for transactions issued to the bus.
; 28 HTT          Max APIC IDs reserved field is Valid. A value of 0 for HTT indicates there is only a single logical processor in
;                 the package and software should assume only a single APIC ID is reserved. A value of 1 for HTT indicates the
;                 value in CPUID.1.EBX[23:16] (the Maximum number of addressable IDs for logical processors in this package) is
;                 valid for the package.
; 29 TM           Thermal Monitor. The processor implements the thermal monitor automatic thermal control circuitry (TCC).
; 30 Reserved     Reserved
; 31 PBE          Pending Break Enable. The processor supports the use of the FERR#/PBE# pin when the processor is in the
;                 stop-clock state (STPCLK# is asserted) to signal the processor that an interrupt is pending and that the
;                 processor should return to normal operation to handle the interrupt. Bit 10 (PBE enable) in the
;                 IA32_MISC_ENABLE MSR enables this capability.


macro CPUID.01H
{
    mov     eax, 01_h
    cpuid
}

CPUID.EFLAGS                        equ ( 1 shl 21 )

CPUID.01H.ECX.SSE3                  equ ( 1 shl 0 )
CPUID.01H.ECX.PCLMULQDQ             equ ( 1 shl 1 )
CPUID.01H.ECX.DTES64                equ ( 1 shl 2 )
CPUID.01H.ECX.MONITOR               equ ( 1 shl 3 )
CPUID.01H.ECX.DS_CPL                equ ( 1 shl 4 )
CPUID.01H.ECX.VMX                   equ ( 1 shl 5 )
CPUID.01H.ECX.SMX                   equ ( 1 shl 6 )
CPUID.01H.ECX.EIST                  equ ( 1 shl 7 )
CPUID.01H.ECX.TM2                   equ ( 1 shl 8 )
CPUID.01H.ECX.SSSE3                 equ ( 1 shl 9 )
CPUID.01H.ECX.CNXT_ID               equ ( 1 shl 10 )
CPUID.01H.ECX.SDBG                  equ ( 1 shl 11 )
CPUID.01H.ECX.FMA                   equ ( 1 shl 12 )
CPUID.01H.ECX.CMPXCHG16B            equ ( 1 shl 13 )
CPUID.01H.ECX.xTPR_Update_Control   equ ( 1 shl 14 )
CPUID.01H.ECX.PDCM                  equ ( 1 shl 15 )
CPUID.01H.ECX.Reserved              equ ( 1 shl 16 )
CPUID.01H.ECX.PCID                  equ ( 1 shl 17 )
CPUID.01H.ECX.DCA                   equ ( 1 shl 18 )
CPUID.01H.ECX.SSE4.1                equ ( 1 shl 19 )
CPUID.01H.ECX.SSE4.2                equ ( 1 shl 20 )
CPUID.01H.ECX.x2APIC                equ ( 1 shl 21 )
CPUID.01H.ECX.MOVBE                 equ ( 1 shl 22 )
CPUID.01H.ECX.POPCNT                equ ( 1 shl 23 )
CPUID.01H.ECX.TSC_Deadline          equ ( 1 shl 24 )
CPUID.01H.ECX.AESNI                 equ ( 1 shl 25 )
CPUID.01H.ECX.XSAVE                 equ ( 1 shl 26 )
CPUID.01H.ECX.OSXSAVE               equ ( 1 shl 27 )
CPUID.01H.ECX.AVX                   equ ( 1 shl 28 )
CPUID.01H.ECX.F16C                  equ ( 1 shl 29 )
CPUID.01H.ECX.RDRAND                equ ( 1 shl 30 )
CPUID.01H.ECX.Not_Used              equ ( 1 shl 31 )

CPUID.01H.EDX.FPU                   equ ( 1 shl 0 )
CPUID.01H.EDX.VME                   equ ( 1 shl 1 )
CPUID.01H.EDX.DE                    equ ( 1 shl 2 )
CPUID.01H.EDX.PSE                   equ ( 1 shl 3 )
CPUID.01H.EDX.TSC                   equ ( 1 shl 4 )
CPUID.01H.EDX.5                     equ ( 1 shl 5 )
CPUID.01H.EDX.MSR                   equ ( 1 shl 5 )
CPUID.01H.EDX.PAE                   equ ( 1 shl 6 )
CPUID.01H.EDX.MCE                   equ ( 1 shl 7 )
CPUID.01H.EDX.CX8                   equ ( 1 shl 8 )
CPUID.01H.EDX.APIC                  equ ( 1 shl 9 )
CPUID.01H.EDX.Reserved              equ ( 1 shl 10 )
CPUID.01H.EDX.SEP                   equ ( 1 shl 11 )
CPUID.01H.EDX.MTRR                  equ ( 1 shl 12 )
CPUID.01H.EDX.PGE                   equ ( 1 shl 13 )
CPUID.01H.EDX.MCA                   equ ( 1 shl 14 )
CPUID.01H.EDX.CMOV                  equ ( 1 shl 15 )
CPUID.01H.EDX.PAT                   equ ( 1 shl 16 )
CPUID.01H.EDX.PSE_36                equ ( 1 shl 17 )
CPUID.01H.EDX.PSN                   equ ( 1 shl 18 )
CPUID.01H.EDX.CLFSH                 equ ( 1 shl 19 )
CPUID.01H.EDX.Reserved2             equ ( 1 shl 20 )
CPUID.01H.EDX.DS                    equ ( 1 shl 21 )
CPUID.01H.EDX.ACPI                  equ ( 1 shl 22 )
CPUID.01H.EDX.MMX                   equ ( 1 shl 23 )
CPUID.01H.EDX.FXSR                  equ ( 1 shl 24 )
CPUID.01H.EDX.SSE                   equ ( 1 shl 25 )
CPUID.01H.EDX.SSE2                  equ ( 1 shl 26 )
CPUID.01H.EDX.SS                    equ ( 1 shl 27 )
CPUID.01H.EDX.HTT                   equ ( 1 shl 28 )
CPUID.01H.EDX.TM                    equ ( 1 shl 29 )
CPUID.01H.EDX.Reserved3             equ ( 1 shl 30 )
CPUID.01H.EDX.PBE                   equ ( 1 shl 31 )

; INPUT EAX = 02H: TLB/Cache/Prefetch Information Returned in EAX, EBX, ECX, EDX
; Example:
;   mov eax, 02_H
;   cpuid
;     EAX  66 5B 50 01H
;     EBX  0H
;     ECX  0H
;     EDX  00 7A 70 00H
;
; 00H  General        Null descriptor, this byte contains no information
; 01H  TLB            Instruction TLB: 4 KByte pages, 4-way set associative, 32 entries
; 02H  TLB            Instruction TLB: 4 MByte pages, fully associative, 2 entries
; 03H  TLB            Data TLB: 4 KByte pages, 4-way set associative, 64 entries
; 04H  TLB            Data TLB: 4 MByte pages, 4-way set associative, 8 entries
; 05H  TLB            Data TLB1: 4 MByte pages, 4-way set associative, 32 entries
; 06H  Cache          1st-level instruction cache: 8 KBytes, 4-way set associative, 32 byte line size
; 08H  Cache          1st-level instruction cache: 16 KBytes, 4-way set associative, 32 byte line size
; 09H  Cache          1st-level instruction cache: 32KBytes, 4-way set associative, 64 byte line size
; 0AH  Cache          1st-level data cache: 8 KBytes, 2-way set associative, 32 byte line size
; 0BH  TLB            Instruction TLB: 4 MByte pages, 4-way set associative, 4 entries
; 0CH  Cache          1st-level data cache: 16 KBytes, 4-way set associative, 32 byte line size
; 0DH  Cache          1st-level data cache: 16 KBytes, 4-way set associative, 64 byte line size
; 0EH  Cache          1st-level data cache: 24 KBytes, 6-way set associative, 64 byte line size
; 1DH  Cache          2nd-level cache: 128 KBytes, 2-way set associative, 64 byte line size
; 21H  Cache          2nd-level cache: 256 KBytes, 8-way set associative, 64 byte line size
; 22H  Cache          3rd-level cache: 512 KBytes, 4-way set associative, 64 byte line size, 2 lines per sector
; 23H  Cache          3rd-level cache: 1 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector
; 24H  Cache          2nd-level cache: 1 MBytes, 16-way set associative, 64 byte line size
; 25H  Cache          3rd-level cache: 2 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector
; 29H  Cache          3rd-level cache: 4 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector
; 2CH  Cache          1st-level data cache: 32 KBytes, 8-way set associative, 64 byte line size
; 30H  Cache          1st-level instruction cache: 32 KBytes, 8-way set associative, 64 byte line size
; 40H  Cache          No 2nd-level cache or, if processor contains a valid 2nd-level cache, no 3rd-level cache
; 41H  Cache          2nd-level cache: 128 KBytes, 4-way set associative, 32 byte line size
; 42H  Cache          2nd-level cache: 256 KBytes, 4-way set associative, 32 byte line size
; 43H  Cache          2nd-level cache: 512 KBytes, 4-way set associative, 32 byte line size
; 44H  Cache          2nd-level cache: 1 MByte, 4-way set associative, 32 byte line size
; 45H  Cache          2nd-level cache: 2 MByte, 4-way set associative, 32 byte line size
; 46H  Cache          3rd-level cache: 4 MByte, 4-way set associative, 64 byte line size
; 47H  Cache          3rd-level cache: 8 MByte, 8-way set associative, 64 byte line size
; 48H  Cache          2nd-level cache: 3MByte, 12-way set associative, 64 byte line size
; 49H  Cache          3rd-level cache: 4MB, 16-way set associative, 64-byte line size (Intel Xeon processor MP, Family 0FH, Model 06H); 2nd-level cache: 4 MByte, 16-way set associative, 64 byte line size
; 4AH  Cache          3rd-level cache: 6MByte, 12-way set associative, 64 byte line size
; 4BH  Cache          3rd-level cache: 8MByte, 16-way set associative, 64 byte line size
; 4CH  Cache          3rd-level cache: 12MByte, 12-way set associative, 64 byte line size
; 4DH  Cache          3rd-level cache: 16MByte, 16-way set associative, 64 byte line size
; 4EH  Cache          2nd-level cache: 6MByte, 24-way set associative, 64 byte line size
; 4FH  TLB            Instruction TLB: 4 KByte pages, 32 entries
; 50H  TLB            Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 64 entries
; 51H  TLB            Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 128 entries
; 52H  TLB            Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 256 entries
; 55H  TLB            Instruction TLB: 2-MByte or 4-MByte pages, fully associative, 7 entries
; 56H  TLB            Data TLB0: 4 MByte pages, 4-way set associative, 16 entries
; 57H  TLB            Data TLB0: 4 KByte pages, 4-way associative, 16 entries
; 59H  TLB            Data TLB0: 4 KByte pages, fully associative, 16 entries
; 5AH  TLB            Data TLB0: 2 MByte or 4 MByte pages, 4-way set associative, 32 entries
; 5BH  TLB            Data TLB: 4 KByte and 4 MByte pages, 64 entries
; 5CH  TLB            Data TLB: 4 KByte and 4 MByte pages,128 entries
; 5DH  TLB            Data TLB: 4 KByte and 4 MByte pages,256 entries
; 60H  Cache          1st-level data cache: 16 KByte, 8-way set associative, 64 byte line size
; 61H  TLB            Instruction TLB: 4 KByte pages, fully associative, 48 entries
; 63H  TLB            Data TLB: 2 MByte or 4 MByte pages, 4-way set associative, 32 entries and a separate array with 1 GByte pages, 4-way set associative, 4 entries
; 64H  TLB            Data TLB: 4 KByte pages, 4-way set associative, 512 entries
; 66H  Cache          1st-level data cache: 8 KByte, 4-way set associative, 64 byte line size
; 67H  Cache          1st-level data cache: 16 KByte, 4-way set associative, 64 byte line size
; 68H  Cache          1st-level data cache: 32 KByte, 4-way set associative, 64 byte line size
; 6AH  Cache          uTLB: 4 KByte pages, 8-way set associative, 64 entries
; 6BH  Cache          DTLB: 4 KByte pages, 8-way set associative, 256 entries
; 6CH  Cache          DTLB: 2M/4M pages, 8-way set associative, 128 entries
; 6DH  Cache          DTLB: 1 GByte pages, fully associative, 16 entries
; 70H  Cache          Trace cache: 12 K-μop, 8-way set associative
; 71H  Cache          Trace cache: 16 K-μop, 8-way set associative
; 72H  Cache          Trace cache: 32 K-μop, 8-way set associative
; 76H  TLB            Instruction TLB: 2M/4M pages, fully associative, 8 entries
; 78H  Cache          2nd-level cache: 1 MByte, 4-way set associative, 64byte line size
; 79H  Cache          2nd-level cache: 128 KByte, 8-way set associative, 64 byte line size, 2 lines per sector
; 7AH  Cache          2nd-level cache: 256 KByte, 8-way set associative, 64 byte line size, 2 lines per sector
; 7BH  Cache          2nd-level cache: 512 KByte, 8-way set associative, 64 byte line size, 2 lines per sector
; 7CH  Cache          2nd-level cache: 1 MByte, 8-way set associative, 64 byte line size, 2 lines per sector
; 7DH  Cache          2nd-level cache: 2 MByte, 8-way set associative, 64byte line size
; 7FH  Cache          2nd-level cache: 512 KByte, 2-way set associative, 64-byte line size
; 80H  Cache          2nd-level cache: 512 KByte, 8-way set associative, 64-byte line size
; 82H  Cache          2nd-level cache: 256 KByte, 8-way set associative, 32 byte line size
; 83H  Cache          2nd-level cache: 512 KByte, 8-way set associative, 32 byte line size
; 84H  Cache          2nd-level cache: 1 MByte, 8-way set associative, 32 byte line size
; 85H  Cache          2nd-level cache: 2 MByte, 8-way set associative, 32 byte line size
; 86H  Cache          2nd-level cache: 512 KByte, 4-way set associative, 64 byte line size
; 87H  Cache          2nd-level cache: 1 MByte, 8-way set associative, 64 byte line size
; A0H  DTLB           DTLB: 4k pages, fully associative, 32 entries
; B0H  TLB            Instruction TLB: 4 KByte pages, 4-way set associative, 128 entries
; B1H  TLB            Instruction TLB: 2M pages, 4-way, 8 entries or 4M pages, 4-way, 4 entries
; B2H  TLB            Instruction TLB: 4KByte pages, 4-way set associative, 64 entries
; B3H  TLB            Data TLB: 4 KByte pages, 4-way set associative, 128 entries
; B4H  TLB            Data TLB1: 4 KByte pages, 4-way associative, 256 entries
; B5H  TLB            Instruction TLB: 4KByte pages, 8-way set associative, 64 entries
; B6H  TLB            Instruction TLB: 4KByte pages, 8-way set associative, 128 entries
; BAH  TLB            Data TLB1: 4 KByte pages, 4-way associative, 64 entries
; C0H  TLB            Data TLB: 4 KByte and 4 MByte pages, 4-way associative, 8 entries
; C1H  STLB           Shared 2nd-Level TLB: 4 KByte/2MByte pages, 8-way associative, 1024 entries
; C2H  DTLB           DTLB: 4 KByte/2 MByte pages, 4-way associative, 16 entries
; C3H  STLB           Shared 2nd-Level TLB: 4 KByte /2 MByte pages, 6-way associative, 1536 entries. Also 1GBbyte pages, 4-way, 16 entries.
; C4H  DTLB           DTLB: 2M/4M Byte pages, 4-way associative, 32 entries
; CAH  STLB           Shared 2nd-Level TLB: 4 KByte pages, 4-way associative, 512 entries
; D0H  Cache          3rd-level cache: 512 KByte, 4-way set associative, 64 byte line size
; D1H  Cache          3rd-level cache: 1 MByte, 4-way set associative, 64 byte line size
; D2H  Cache          3rd-level cache: 2 MByte, 4-way set associative, 64 byte line size
; D6H  Cache          3rd-level cache: 1 MByte, 8-way set associative, 64 byte line size
; D7H  Cache          3rd-level cache: 2 MByte, 8-way set associative, 64 byte line size
; D8H  Cache          3rd-level cache: 4 MByte, 8-way set associative, 64 byte line size
; DCH  Cache          3rd-level cache: 1.5 MByte, 12-way set associative, 64 byte line size
; DDH  Cache          3rd-level cache: 3 MByte, 12-way set associative, 64 byte line size
; DEH  Cache          3rd-level cache: 6 MByte, 12-way set associative, 64 byte line size
; E2H  Cache          3rd-level cache: 2 MByte, 16-way set associative, 64 byte line size
; E3H  Cache          3rd-level cache: 4 MByte, 16-way set associative, 64 byte line size
; E4H  Cache          3rd-level cache: 8 MByte, 16-way set associative, 64 byte line size
; EAH  Cache          3rd-level cache: 12MByte, 24-way set associative, 64 byte line size
; EBH  Cache          3rd-level cache: 18MByte, 24-way set associative, 64 byte line size
; ECH  Cache          3rd-level cache: 24MByte, 24-way set associative, 64 byte line size
; F0H  Prefetch       64-Byte prefetching
; F1H  Prefetch       128-Byte prefetching
; FEH  General        CPUID leaf 2 does not report TLB descriptor information; use CPUID leaf 18H to query TLB and other address translation parameters.
; FFH  General        CPUID leaf 2 does not report cache descriptor information, use CPUID leaf 4 to query cache parameter; s; 





; CPUID.1.EDX.HTT = 1
;   mov     eax, 1
;   cpuid
;   test    edx, CPUID.1.EDX.HTT
;   je      htt_code_block
;

; TEST EDX, \
;     CPUID.1.EDX.HTT,  htt_code_block,    \
;     CPUID.1.EDX.SS,   SS_code_block ,    \
;                       default_code_block
; 
;   test    edx, CPUID.1.EDX.HTT
;   je      htt_code_block
;   test    edx, CPUID.1.EDX.SS
;   je      ss_code_block
;   jmp     default_code_block
