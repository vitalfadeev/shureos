;
; to_long_mode
;

use32

include 'gdt_64.asm'  
include 'cr.asm'


to_long_mode:
    ; Elevate to 64-bit mode 
    mov ecx, 0xC000_0080  ; IA32_EFER
    rdmsr
    or  eax, 1_0000_0000b
    wrmsr

    ; Enable paging
    CR0.set_bit CR0.PG
    
    gdt_64.init

    jmp code_seg_64:init_lm

use64
init_lm:
    cli
    mov ax, data_seg_64   ; Set the A-register to the data descriptor.
    mov ds, ax            ; Set the data segment to the A-register.
    mov es, ax            ; Set the extra segment to the A-register.
    mov fs, ax            ; Set the F-segment to the A-register.
    mov gs, ax            ; Set the G-segment to the A-register.
    mov ss, ax            ; Set the stack segment to the A-register.

    ; Since the stack pointers got messed up in the elevation process, and we
    ; want a fresh stack, we need to reset them now.
    ; mov rbp, 1000_H + 8192; 3000h. may be 7B00_H
    ; mov rsp, rbp

    ; long mode
    jmp sector2           ; in sector2.asm

