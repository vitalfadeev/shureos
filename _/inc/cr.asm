;
; CR (Control Registers)
;

; CR 1
CR0.PE          equ ( 1        ) ; Protection Enable
CR0.MP          equ ( 1 shl  1 ) ; Monitor Coprocessor
CR0.EM          equ ( 1 shl  2 ) ; Emulation
CR0.TS          equ ( 1 shl  3 ) ; Task Switched
CR0.ET          equ ( 1 shl  4 ) ; Extension Type
CR0.NE          equ ( 1 shl  5 ) ; Numeric Error
CR0.WP          equ ( 1 shl 16 ) ; Write Protect
CR0.AM          equ ( 1 shl 18 ) ; Alignment Mask
CR0.NW          equ ( 1 shl 29 ) ; Not Write-through
CR0.CD          equ ( 1 shl 30 ) ; Cache Disable
CR0.PG          equ ( 1 shl 31 ) ; Paging

; CR 3
CR3.PWT         equ ( 1 shl  3 ) ; Page-level Write-Through
CR3.PCD         equ ( 1 shl  4 ) ; Page-level Cache Disable

; CR 4
CR4.VME         equ ( 1        ) ; Virtual-8086 Mode Extensions
CR4.PVI         equ ( 1 shl  1 ) ; Protected-Mode Virtual Interrupts
CR4.TSD         equ ( 1 shl  2 ) ; Time Stamp Disable
CR4.DE          equ ( 1 shl  3 ) ; Debugging Extensions
CR4.PSE         equ ( 1 shl  4 ) ; Page Size Extensions
CR4.PAE         equ ( 1 shl  5 ) ; Physical Address Extension
CR4.MCE         equ ( 1 shl  6 ) ; Machine-Check Enable
CR4.PGE         equ ( 1 shl  7 ) ; Page Global Enable
CR4.PCE         equ ( 1 shl  8 ) ; Performance-Monitoring Counter Enable
CR4.OSFXSR      equ ( 1 shl  9 ) ; Operating System Support for FXSAVE and FXRSTOR instructions
CR4.OSXMMEXCPT  equ ( 1 shl 10 ) ; Operating System Support for Unmasked SIMD Floating-Point Exceptions
CR4.UMIP        equ ( 1 shl 11 ) ; User-Mode Instruction Prevention
CR4.VMXE        equ ( 1 shl 13 ) ; VMX-Enable Bit
CR4.SMXE        equ ( 1 shl 14 ) ; SMX-Enable Bit
CR4.FSGSBASE    equ ( 1 shl 16 ) ; FSGSBASE-Enable Bit
CR4.PCIDE       equ ( 1 shl 17 ) ; PCID-Enable Bit
CR4.OSXSAVE     equ ( 1 shl 18 ) ; XSAVE and Processor Extended States-Enable Bit
CR4.SMEP        equ ( 1 shl 20 ) ; SMEP-Enable Bit
CR4.SMAP        equ ( 1 shl 21 ) ; SMAP-Enable Bit
CR4.PKE         equ ( 1 shl 21 ) ; Protection-Key-Enable Bit

; CR 8
CR8.TPL         equ ( 111_B    ) ; Task Priority Level

; XCR 0
XCR0.X87        equ ( 1        ) ; This bit 0 must be 1. An attempt to write 0 to this bit causes a #GP exception.
XCR0.SSE        equ ( 1 shl  1 ) ; If 1, the XSAVE feature set can be used to manage MXCSR and the XMM registers (XMM0-XMM15 in 64-bit mode; otherwise XMM0-XMM7).
XCR0.AVX        equ ( 1 shl  2 ) ; If 1, AVX instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the YMM registers (YMM0-YMM15 in 64-bit mode; otherwise YMM0-YMM7).
XCR0.BNDREG     equ ( 1 shl  3 ) ; If 1, MPX instructions can be executed and the XSAVE feature set can be used to manage the bounds registers BND0–BND3.
XCR0.BNDCSR     equ ( 1 shl  4 ) ; If 1, MPX instructions can be executed and the XSAVE feature set can be used to manage the BNDCFGU and BNDSTATUS registers.
XCR0.opmask     equ ( 1 shl  5 ) ; If 1, AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the opmask registers k0–k7.
XCR0.ZMM_Hi256  equ ( 1 shl  6 ) ; If 1, AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper halves of the lower ZMM registers (ZMM0-ZMM15 in 64-bit mode; otherwise ZMM0-ZMM7).
XCR0.Hi16_ZMM   equ ( 1 shl  7 ) ; If 1, AVX-512 instructions can be executed and the XSAVE feature set can be used to manage the upper ZMM registers (ZMM16-ZMM31, only in 64-bit mode).
XCR0.PKRU       equ ( 1 shl  9 ) ; If 1, the XSAVE feature set can be used to manage the PKRU register (see Section 2.7).


; Set bit in CR0
; Example:
;   CR0.set_bit CR0.PE
; Using: 
;   EAX
macro CR0.set_bit bit_mask
{
    mov eax, cr0
    or  eax, bit_mask
    mov cr0, eax
}
