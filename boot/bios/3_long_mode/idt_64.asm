;
; idt_64:
;
use64

include 'idt_64_const.asm'
include 'idt_64_gate_descriptor.asm'
include 'idt_64_vectors.asm'


;  0 trap       fault
;  1 trap       fault/abort
;  2 interrupt
;  3 trap
;  4 trap
;  5 trap       fault
;  6 trap       fault
;  7 trap       fault
;  8 trap       abort
;  9 trap       fault
; 10 trap       fault
; 11 trap       fault
; 12 trap       fault
; 13 trap       fault
; 14 trap       fault
; 15 trap       fault
; 16 trap       fault
; 17 trap       fault
; 18 trap       abort
; 19 trap       fault
; 20 trap       fault
; 21 trap       fault
; 22 trap       fault
; 23 trap       fault
; 24 trap       fault
; 25 trap       fault
; 26 trap       fault
; 27 trap       fault
; 28 trap       fault
; 29 trap       fault
; 30 trap       fault
; 31 trap       fault
; 32 interrupt
; .. interrupt
;255 interrupt


macro pushaq
{
    push rax
    push rcx
    push rdx
    push rbx
    push rbp
    push rsi
    push rdi
}

macro popaq
{
    pop rdi
    pop rsi
    pop rbp
    pop rbx
    pop rdx
    pop rcx
    pop rax
}


; cached info
r_trap          equ r8  ; hold gate descriptor type attrs for trap      : 10001111_b
r_interrupt     equ r9  ; hold gate descriptor type attrs for interrupt : 10001110_b
r_idt_64_start  equ r10 ; hold IDT 64 address


;
; call_setup_idt_64_exception
;
macro call_setup_idt_64_exception  handler_address
{
    lea  rax, [handler_address]
    call setup_idt_64_exception
}


;
; setup_idt_64_exception
;
; rax            : address of the handler  (64 bit, but actual 16 bit)
; rdi            : gate desctiptor address (64 bit, but actial 16 bit)
; r_trap         : hold gate descriptor type attrs for trap: 10001111_b
setup_idt_64_exception:
    ; gate descriptor
    or   rax, r_trap    ; gate descriptor type attributes: 10001111_b
    ; put gate descriptor
    stosq                   ; store 64 bit rax, rdi+8
    ; put rest zeros
    xor  rax, rax           ; zero
    stosq                   ; store 64 bit rax, rdi+8
ret


;
; call_setup_idt_64_reserved
;
; rdi            : address of the gate descriptor
macro setup_idt_64_reserved
{
    stosq                   ; store 64 bit rax, rdi+8
    stosq                   ; store 64 bit rax, rdi+8
}


;
; call_setup_idt_64_interrupt
;
macro call_setup_idt_64_interrupt  handler_address
{
    lea  rax, [handler_address]
    call setup_idt_64_interrupt
}


;
; setup_idt_64_interrupt
;
; rax            : address of the handler  (64 bit, but actual 16 bit)
; rdi            : gate desctiptor address (64 bit, but actial 16 bit)
; r_interrupt    : hold gate descriptor type attrs for interrupt: 10001110_b
setup_idt_64_interrupt:
    ; gate descriptor
    or   rax, r_interrupt   ; gate descriptor type attributes: 10001110_b
    ; put gate descriptor
    stosq                   ; store 64 bit rax, rdi+8
    ; put rest zero
    xor  rax, rax           ; zero
    stosq                   ; store 64 bit rax, rdi+8
ret


;
; call_setup_idt_64_interrupt_test
;
macro call_setup_idt_64_interrupt_test  int_number, handler_address
{
    mov  rcx, int_number
    mov  rax, handler_address
    call setup_idt_64_interrupt_test
}


;
; setup_idt_64_interrupt_test
;
; rcx            : interrupt number
; rax            : address of the handler  (64 bit, but actual 16 bit)
; rdi            : gate desctiptor address (64 bit, but actial 16 bit)
; r_interrupt    : hold gate descriptor type attrs for interrupt: 10001110_b
setup_idt_64_interrupt_test:
    ; IDT address
    mov   rdi, r_idt_64_start
    ; gate offset
    shl   rcx, 4 ; rcx * 16
    ; gate address
    add   rdi, rcx

    ; gate descriptor
    or   rax, r_interrupt   ; gate descriptor type attributes: 10001110_b
    ; put gate descriptor
    stosq                   ; store 64 bit rax, rdi+8
    ; put rest zero
    xor  rax, rax           ; zero
    stosq                   ; store 64 bit rax, rdi+8
ret


; Handlers
virtual
; align 8
; handlers_table:
;     dd int_0_handler, int_1_handler
end virtual

; ECX : selector (0, 1, 2, 3)
;       mov ecx, [selector]


;
; Setup 256 IDT gate descriptors
;
setup_idt_64:
    ; GDT 64 START
    lea  r_idt_64_start, [idt_64_start]

    ; GATE DESCRIPTOR TYPES
    ; exception (fault, trap, abort)
    mov  r_trap, idt_64_gd_type_trap
    shl  r_trap, 5*8 ; 5 Bytes shift left
    ; gate code segment selector
    or   r_trap, 0000_1_000_00000000_00000000_b

    ; interrupt
    mov  r_interrupt, idt_64_gd_type_interrupt
    shl  r_interrupt, 5*8 ; 5 Bytes shift left
    ; gate code segment selector
    or   r_interrupt, 0000_1_000_00000000_00000000_b

    ; SETUP EXCEPTION GATES
    ; mov  rdi, r_idt_64_start
    ; std                                        ; forward rirection ( later rdi + 8 )
    ; call_setup_idt_64_exception  int_0_handler ;  0
    ; call_setup_idt_64_exception  int_1_handler ;  1
    ; call_setup_idt_64_interrupt  int_2_handler ;  2
    ; call_setup_idt_64_exception  int_3_handler ;  3
    ; call_setup_idt_64_exception  int_4_handler ;  4
    ; call_setup_idt_64_exception  int_5_handler ;  5
    ; call_setup_idt_64_exception  int_6_handler ;  6
    ; call_setup_idt_64_exception  int_7_handler ;  7
    ; call_setup_idt_64_exception  int_8_handler ;  8
    ; call_setup_idt_64_exception  int_9_handler ;  9
    ; call_setup_idt_64_exception int_10_handler ; 10
    ; call_setup_idt_64_exception int_11_handler ; 11
    ; call_setup_idt_64_exception int_12_handler ; 12
    ; call_setup_idt_64_exception int_13_handler ; 13
    ; call_setup_idt_64_exception int_14_handler ; 14
    ; setup_idt_64_reserved                      ; 15
    ; call_setup_idt_64_exception int_16_handler ; 16
    ; call_setup_idt_64_exception int_17_handler ; 17
    ; call_setup_idt_64_exception int_18_handler ; 18
    ; call_setup_idt_64_exception int_19_handler ; 19
    ; call_setup_idt_64_exception int_20_handler ; 20

    ; ; SETUP RESERVED GATES
    ; ; (code-size, memory-read optimized version)
    ; setup_idt_64_reserved                      ; 21
    ; setup_idt_64_reserved                      ; 22
    ; setup_idt_64_reserved                      ; 23
    ; setup_idt_64_reserved                      ; 24
    ; setup_idt_64_reserved                      ; 25
    ; setup_idt_64_reserved                      ; 26
    ; setup_idt_64_reserved                      ; 27
    ; setup_idt_64_reserved                      ; 28
    ; setup_idt_64_reserved                      ; 29
    ; setup_idt_64_reserved                      ; 30
    ; setup_idt_64_reserved                      ; 31


; mov  rcx, 2 * (31 - 21 + 1)                ; 12..31, 31 included
; rep stosq    

    ; SETUP INTERRUPT GATES
    ; call_setup_idt_64_interrupt int_32_handler ; 32 ; Timer
    ; call_setup_idt_64_interrupt int_33_handler ; 33 ; Keyboard


; 32..255 interrupts
; rept 255-32 int_number:32
; {
;     mov  rcx, int_number
;     mov  rax, int_handler_test__#int_number
;     call setup_idt_64_interrupt_test
; }


; loop1_start:
;     mov  r12, 255

; loop1_body:
;     mov  rcx, r12    
;     lea  rax, [int_handler_test__32]
;     call setup_idt_64_interrupt_test

;     cmp  r12, 31
;     je   loop1_end
;     dec  r12
;     jmp  loop1_body

; loop1_end:
;     ;





    ; call_setup_idt_64_interrupt_test 33, int_handler_test_ ; 33 ; Keyboard
    ; call_setup_idt_64_interrupt_test 80h, int_handler_test_ ; 0x81 ; Keyboard
    ; call_setup_idt_64_interrupt_test 81h, int_handler_test_ ; 0x81 ; Keyboard

    ; LOAD IDT 64 address into IDTR
    lidt [idtr_store]
ret


;
; IDT 64 exception handlers
;
; int_0_handler:
;     cli
;     mov dword [0xB8000], 'E 0 '
;     print_vector 0
;     jmp $
; iretq

; int_1_handler:
;     cli
;     mov dword [0xB8000], 'E 1 '
;     print_vector 1
;     jmp $
; iretq

; int_2_handler:
;     cli
;     mov dword [0xB8000], 'E 2 '
;     print_vector 2
;     jmp $
; iretq

; int_3_handler:
;     cli
;     mov dword [0xB8000], 'E 3 '
;     print_vector 3
;     jmp $
; iretq

; int_4_handler:
;     cli
;     mov dword [0xB8000], 'E 4 '
;     print_vector 4
;     jmp $
; iretq

; int_5_handler:
;     cli
;     mov dword [0xB8000], 'E 5 '
;     print_vector 5
;     jmp $
; iretq

; int_6_handler:
;     cli
;     mov dword [0xB8000], 'E 6 '
;     print_vector 6
;     jmp $
; iretq

; int_7_handler:
;     cli
;     mov dword [0xB8000], 'E 7 '
;     print_vector 7
;     jmp $
; iretq

; int_8_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E 8 '
;     print_vector 8
;     jmp $
; iretq

; int_9_handler:
;     cli
;     mov dword [0xB8000], 'E 9 '
;     print_vector 9
;     jmp $
; iretq

; int_10_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E A '
;     print_vector 10
;     jmp $
; iretq

; int_11_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E B '
;     print_vector 11
;     jmp $
; iretq

; int_12_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E C '
;     print_vector 12
;     jmp $
; iretq

; int_13_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E D '
;     print_vector 13
;     jmp $
; iretq

; int_14_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E E '
;     print_vector 14
;     jmp $
; iretq

; int_15_handler:
;     cli
;     mov dword [0xB8000], 'E F '
;     print_vector 15
;     jmp $
; iretq

; int_16_handler:
;     cli
;     mov dword [0xB8000], 'E G '
;     print_vector 16
;     jmp $
; iretq

; int_17_handler:
;     pop rax     ; get error code from stack
;     cli
;     mov dword [0xB8000], 'E H '
;     print_vector 17
;     jmp $
; iretq

; int_18_handler:
;     cli
;     mov dword [0xB8000], 'E I '
;     print_vector 18
;     jmp $
; iretq

; int_19_handler:
;     cli
;     mov dword [0xB8000], 'E J '
;     print_vector 19
;     jmp $
; iretq

; int_20_handler:
;     cli
;     mov dword [0xB8000], 'E K '
;     print_vector 20
;     jmp $
; iretq


;
; IDT 64 interrupt handlers
; 
; int_31_handler:
;     cli
;     mov dword [0xB8000], 'E R '
;     print_vector 31
;     jmp $
; iretq

; int_handler_test:
;     cli
;     ; mov dword [0xB8000], '- - '
;     ; hlt
;     ; jmp $
;     print_vector 255
;     sti
; iretq



; rept 255-32 int_number:32
; {
;     int_handler_test__#int_number:
;         cli
;         ; mov dword [0xB8000], '* * '
;         print_vector int_number
;         sti
;     iretq
; }

; int_handler_test_:
;     cli
;     mov dword [0xB8000], '* * '
;     ; hlt
;     ; jmp $
;     print_vector 33
;     sti
; iretq

; int_32_handler:
;     cli
;     print_vector 32
;     sti
; iretq

; int_33_handler:
;     cli
;     print_vector 33
;     sti
; iretq


; Messages
; b_msg: dd 'b ', 0


; IDTR register value
idtr_store:
    dw idt_64_end - idt_64_start  - 1 ; limit. 16 bit
    dq idt_64_start                   ; base.  64 bit
