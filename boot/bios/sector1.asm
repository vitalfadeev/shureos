;
; BEGIN SECOND SECTOR. THIS ONE CONTAINS 32-BIT CODE ONLY
;
use32

sector1:
begin_protected:

    ; Clear vga memory output
    call clear_protected

    ; Test VGA-style print function
    mov  esi, protected_alert
    call print_protected

    ; Entering 64 bit long mode
    call detect_lm_protected
    call init_pt_protected

    ; 64 bit long mode
    mov  esi, protected_alert_64
    call print_protected

    ; to long mode
    call to_long_mode

    ; infinite loop
    jmp $

    ; INCLUDE protected-mode functions
    include '2_protected_mode/clear_protected.asm'
    include '2_protected_mode/print_protected.asm'
    include '2_protected_mode/detect_lm_protected.asm'
    include '2_protected_mode/init_pt_protected.asm'
    include '2_protected_mode/to_long_mode.asm'

    ; Define necessary constants
    vga_start                        equ 0x000B8000
    vga_extent                       equ (80 * 25 * 2) ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
    vga_stride                       equ (80 * 2)      ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
    style_wb                         equ 0x0F          ; blue
    kernel_start                     equ 0x00100000    ; Kernel is at 1MB

    ; Define messages
    protected_alert:                 db '32-bit mode ', 0
    protected_alert_64:              db '64-bit mode ', 0

    ; Fill with zeros to the end of the sector
    zero1: times 512 - ($ - sector1) db 0x00
