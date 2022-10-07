;
; sector3
;
use64

sector3: ; 0x8200
core:
    ; Print core message
    mov rdi, style_blue
    mov rsi, core_msg
    call print_long

    ; Disable interrupts
    cli               

    ; Setup Interrupt Descriptor Table (IDT)
    ; call setup_idt_64

    ;
    call_clear_long style_blue
    call setup_interrupt_map
    call print_interrupt_map

    ; Setup APIC
    include 'pic/8259A.asm'
    pic.init                                                     \ ; init
        ( ICW1_INIT or \
          ICW1_CASCADE or \
          ICW1_EDGE or \
          ICW1_ICW4 \
        ), \ ;   cascade, edge-triggered
        32,                                                      \ ;   master starts from 32
        40,                                                      \ ;   slave  starts from 40
        00000100_B,                                              \ ;   slave IRQ2 
        00000010_B,                                              \ ;   slave cascade identity 0000_0010
        ICW4_8086                                                  ;   Intel 8086

    pic.set_mask \
        1111_1100_b, \ ; master:  timer.8254, keyboard
        1111_1111_b    ; slave

    include 'timer/8254.asm'
    ; pic.timer.init  20

    Timer.sleep 5

    ; pic.enable_irqs      \
    ;     IRQ_SYS_TIMER,   \ 
    ;     IRQ_KEYBOARD,    \
    ;     IRQ_CASCADE_PIC

    ; Enable interrupts
    ; hlt
    sti
    nop

    ;int 130
    ; int 82h ; 130

    ; Run infinite loop
    infinite_loop

    ; INCLUDE long-mode functions
    include '3_long_mode/idt_64.asm'
    include '3_long_mode/print_interrupt_map.asm'

    ; Define messages
    core_msg:  db 'Core.', 0
    include "strings.asm"
    core_msg2: String "Test"

    ; zero3: times 512 - ($ - sector3) db 0x00
