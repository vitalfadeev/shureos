;
; idt_64_const
;
sector_size                 equ 512
idt_64_gate_descriptors     equ 256
idt_64_gate_descriptor_size equ 16

idt_64_start                equ ( 0x7C00 + ((sectors_to_read + 1) * sector_size) ) ; 0x7C00+(24+1)*512 = 0xA200
idt_64_end                  equ ( idt_64_start + ( idt_64_gate_descriptors * idt_64_gate_descriptor_size ) ) ; 0x7D19 - (256*16) = 0x6D19

; If the index points to an interrupt gate or trap gate, 
; the processor calls the exception or interrupt handler 
; in a manner similar to a CALL to a call gate.
;
; If index points to a task gate, 
; the processor executes a task switch to the exception- or interrupt-handler task 
; in a manner similar to a CALL to a task gate.
;
idt_64_gd_type_task         equ 10001101_b  ; unused by OS. task gate
idt_64_gd_type_call         equ 10001100_b  ; unused by OS. call gate
idt_64_gd_type_interrupt    equ 10001110_b  ; interrupt gate - kind of call gate ; 0x8E
idt_64_gd_type_trap         equ 10001111_b  ; trap gate      - kind of call gate
