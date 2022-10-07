;
; sector 2 
;
use64

; Define necessary constants
style_blue  equ 0x1F
style_green equ 0x2F

macro call_clear_long  style
{
    mov rdi, style
    call clear_long
}

macro call_print_long  style, msg
{
    mov rdi, style
    mov rsi, msg
    call print_long
}


sector2:
begin_long_mode:
    ; Clear screen (to blue)
    call_clear_long style_blue

    ; Print long mode message
    call_print_long style_blue, long_mode_msg

    ; Run kernel
    jmp core

    ; INCLUDE long-mode functions
    include '3_long_mode/clear_long.asm'
    include '3_long_mode/print_long.asm'

    ; Define messages
    long_mode_msg:  db 'Now running in fully-enabled, 64-bit long mode!', 0

    ; Fill with zeros to the end of the sector
    zero2: times 512 - ($ - sector2) db 0x00
