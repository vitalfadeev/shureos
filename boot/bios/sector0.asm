;
; Bootloader 
; 0 sector
;
; Load next sectors, then run loaded code
; 512 byte
;
format binary
use16
org 0x7C00           ; for BootSector

sector_size     equ 512
sectors_to_read equ 24

include "print.asm"
include "setup_stack.asm"
include "load_sector_1.asm"
include "infinite_loop.asm"
include "save_boot_drive.asm"

macro do_msg code, message
{
    print message
    code
    print ok_msg
}


start:
sector0:
    ; start
    do_msg nop, loading_sector_0_msg

    ; initializing stack
    do_msg setup_stack, initializing_stack_msg

    ; saving boot drive
    save_boot_drive

    ; loading kernel
    do_msg load_sector_1, loading_sector_1_msg

    ; And elevate our CPU to 32-bit mode
    print protected_msg
    call to_protected_mode

    ; infinite loop
    jmp $

    ; messages
    loading_sector_0_msg:    db 'Loading sector 0...     ', 0
    initializing_stack_msg:  db 'Initializing stack...   ', 0
    loading_sector_1_msg:    db 'Loading sector 1...     ', 0
    protected_msg:           db 'Entering in 32-bit protected mode', 0
    ok_msg:                  db '[ OK ]', 0x0d, 0x0a, 0

    ; functions
    include '1_real_mode/print_string_bios.asm'
    include '1_real_mode/load_bios.asm'
    include '1_real_mode/print_hex_bios.asm'
    include '1_real_mode/to_protected_mode.asm'

    ; Boot drive storage
    boot_drive:              db 0x00

    ; Fills our bootloader with zero padding.
    zero:   times 510-($-$$) db 0x00

    ; This is our boot sector signature, without it,
    ; the BIOS will not load our bootloader into memory.
    SECTOR_0_MAGIC_NUMBER:   dw 0xAA55


; BEGIN 2ND SECTOR. THIS ONE CONTAINS 32-BIT CODE ONLY
include 'sector1.asm'

; BEGIN 3RD SECTOR. THIS ONE CONTAINS 64-BIT CODE ONLY
include 'sector2.asm'

; BEGIN 4RD SECTOR. THIS ONE CONTAINS kecore code
include 'sector3.asm'


; OUT  same as write
; IN   same as read

