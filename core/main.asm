;
; main.asm
;
format binary
use64

include "inc/main_loop.inc"
include "../_/inc/print_a.inc"


macro setup_long_mode
{
    ; Если загрузка выполняется через BIOS, то код загрузчика (из сектора #0) исполняется в реальном режиме. 
    ; Если вместо BIOS используется UEFI, то переход в Long mode происходит ещё раньше, и никакого кода в реальном режиме уже не выполняется.

    ; nothing to do
}


; IDT_000 dq 0x0
; IDT_001 dq 0x8
; IDT_002 dq 0x10
; IDT_003 dq 0x18
; IDT_004 dq 0x20
; IDT_005 dq 0x28
; IDT_006 dq 0x30
; IDT_007 dq 0x38
; IDT_008 dq 0x40
; IDT_009 dq 0x48
; IDT_010 dq 0x50
; IDT_011 dq 0x58
; IDT_012 dq 0x60
; IDT_013 dq 0x68
; IDT_014 dq 0x70
; IDT_015 dq 0x78
; IDT_USB dq 0x80


macro print_b
{
    mov ah, 0x0E
    mov al, 'B'
    mov bh, 0x00
    int 10h
}


macro setup_interrupts
{
    xor      rax, rax
    xor      rdi, rdi
    mov      [rdi], rax
    add      rdi, 8
    xor      rdx, rdx
    mov      rdx, IDT_IRQ_0
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_1
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_2
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_3
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_4
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_5
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_6
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_7
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_8
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_9
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_10
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_11
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_12
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_13
    mov      [rdi], rdx

    add      rdi, 8
    mov      [rdi], rax
    add      rdi, 8
    mov      rdx, IDT_IRQ_14
    mov      [rdi], rdx


    ; USB
usb_interrupt:
    ;
keyboard_interrupt:
    ;

IDT_IRQ_0:
IDT_IRQ_1:
IDT_IRQ_2:
IDT_IRQ_3:
IDT_IRQ_4:
IDT_IRQ_5:
IDT_IRQ_6:
IDT_IRQ_7:
IDT_IRQ_8:
IDT_IRQ_9:
IDT_IRQ_10:
IDT_IRQ_11:
IDT_IRQ_12:
IDT_IRQ_13:
IDT_IRQ_14:
IDT_IRQ_15:
    print_b
    iret
}


macro setup
{    
setup:
    setup_long_mode
    setup_interrupts
}


main:
    setup
    main_loop

; operations store
;   read
;   write
;   empty

; register
;   active unit - for receive operation

; operation
;   opcode
;   a1
;   a2
;   a3
;   a4
;   for_unit

; global main_loop, global jump
;   main_loop:
;     check operations store
;     dispatch
;       jmp main_loop

; keyboard
; text_display
; VGA, SVGA, VESA, DIRECT_VIDEO_MEMORY
; network_card

; when deleted process
;  then delete all operations for process
