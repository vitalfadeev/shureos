;
; idt_64_gate
;

include 'idt_64_const.asm'

struc idt_64_gate_descriptor
{
    .offset_1 dw 00000000_00000000_b  ; offset bits 0..15
    .selector dw 00000000_00000000_b  ; a code segment selector in GDT or LDT
    .ist      db 00000000_b           ; ist
    ;            .....                ;   rest of bits zero.
    ;                 ...             ;   bits 0..2: Interrupt Stack Table offset
    .typeattr db 10001110_b           ; type attributes
    ;            .                    ;   P 
    ;             ..                  ;   DPL
    ;               .                 ;   0
    ;                ....             ;   gate type
    .offset_2 dw 00000000_00000000_b  ; offset bits 16..31
    .offset_3 dd 00000000_00000000_00000000_00000000_b ; offset bits 32..63
    .reserved dd 00000000_00000000_00000000_00000000_b ; reserved
}


;  cl: vector number.    8 bit
; rax: handler address. 64 bit
idt_64_gate_descriptor_init:
    ; gate descriptor start
    ; lea rdi, [idt_64_start + rcx * 16]
    mov  rdi, idt_64_start
    shl  rcx, 4            ; rcx * 16
    add  rdi, rcx

    ; offset_1
    mov  byte[rdi], al     ; stosw
    inc  rdi               ;
    mov  byte[rdi], ah     ;
    inc  rdi               ;

    ; type
    inc  rdi
    inc  rdi
    inc  rdi
    inc  rdi
    mov  byte[rdi], 10001110_b
ret
