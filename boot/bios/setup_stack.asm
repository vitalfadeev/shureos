;
; setup_stack
;
; +---------------+ <- top of the stack ( RSS + STACK_SIZE )
; | var1          | 
; |               | <- RSP
; +---------------+
; |               |
; |               |
; +---------------+ <- RSS
;                      bottom of the stack

macro setup_stack
{
    ; 1. Establish a stack segment.
    STACK_START  equ 0 ; 1024 * 1024            ; 1 MByte ; RAM size is stack top
    ; STACK_SIZE   equ 4096                     ; 4 kByte
    STACK_SIZE   equ 0x0500                     ; 4 kByte
    STACK_END    equ (STACK_START - STACK_SIZE) ; 1 MByte - 4 kByte
    STACK_SEG    equ 0                          ; stack segment in 64 bit long mode is 0
    STACK_BOTTOM equ 0                          ; bottom of the stack ( SS:SP )
    STACK_TOP    equ STACK_SIZE                 ; top of the stack    ( SS:SP )

    ; 2. Load the segment selector for the stack segment into the SS register using a MOV, POP, or LSS instruction.
    mov ax, STACK_SEG              ; bottom of the stack
    mov ss, ax

    ; 3. Load the stack pointer for the stack into the ESP register using a MOV, POP, or LSS instruction. The LSS
    ; instruction can be used to load the SS and ESP registers in one operation.
    mov sp, STACK_TOP              ; top of the stack

    ; Base pointer
    mov bp, sp
}
