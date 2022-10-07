;
; Interrupt map 16 x 16
;
include 'idt_64_const.asm'


y_values equ 16
x_step   equ 5
vectors  equ 256
reg_x    equ r11w
reg_y    equ r12w


;
; print_interrupt_map
;
print_interrupt_map:
    loop_start:
        mov  ecx, vectors
        xor  reg_x, reg_x
        xor  reg_y, reg_y
        mov  bh, style_blue

    loop_body:
        ; print
        mov  ax, vectors
        sub  ax, cx
        ; mov  reg_x, 2
        ; mov  reg_y, 2
        call print_dec_at

        ; next location
        inc  reg_y

        cmp  reg_y, y_values
        jge  reg_y_over
        jmp  reg_y_ok

        reg_y_over:
            add  reg_x, x_step ; x + x_step
            xor  reg_y, reg_y  ; y = 0

        reg_y_ok:
            ;

        loop loop_body

    loop_end:
        ;
ret


; Display decimal value. In VGA Text mode
;   AL : decimal value. 0..255
;   BH : style
; R11W : X
; R12W : Y
; uses edi
macro print_vector num
{
    mov  al, num
    mov  bh, style_green
    mov  reg_x, x_step * ( num / y_values )
    mov  reg_y, num mod y_values
    call print_dec_at
}


macro display_hex value
{
    bits = 16
    display `value # ": 0x"
    repeat bits/4
        d = '0' + value shr (bits-%*4) and 0Fh
        if d > '9'
            d = d + 'A'-'9'-1
        end if
        display d
    end repeat
    display 13,10
}

;
setup_interrupt_map:
    isr_step        equ ( isr_table_pos1 - isr_table_pos0 )
    r_idt_64_start  equ r10 ; hold IDT 64 address

    loop1_start:
        mov  r_idt_64_start, idt_64_start
        ;
        mov  r12, 0
        ;
        mov  r_interrupt, idt_64_gd_type_interrupt
        shl  r_interrupt, 5*8 ; 5 Bytes shift left
        ; gate code segment selector
        or   r_interrupt, 0000_1_000_00000000_00000000_b
        ;
        mov  r11, isr_table_start
        or   r11, r_interrupt   ; gate descriptor type attributes: 10001110_b
        ;
        mov  rdi, r_idt_64_start

    loop1_body:
        mov  rax, r11
        ; call setup_idt_64_interrupt_test

        ; gate descriptor
        ; put gate descriptor
        stosq                   ; store 64 bit rax, rdi+8
        ; put rest zero
        xor  rax, rax           ; zero
        stosq                   ; store 64 bit rax, rdi+8

        ;
        cmp  r12, 255
        je   loop1_end

        inc  r12
        add  r11, isr_step
        jmp  loop1_body

    loop1_end:
        ;

    lidt [idtr_store_2]
ret


; ISR Table
isr_table_start:
rept 256 int_number:0
{
    isr_table_pos#int_number:
        push ax
        push bx
        push dx

        mov  ax, int_number
        jmp  isr    
}
isr_table_end:;


; Interrupt Service Rutine (ISR)
;   AX : interrupt_number
isr:
    cli

    ; pic.get_isr ; into AX
    ; mov  al, ah
    ; xor  ah, ah


    ; pop error_code from stack
    cmp  ax, 8
        jne  is_no_error_code
    cmp  ax, 10
        jne  is_no_error_code
    cmp  ax, 11
        jne  is_no_error_code
    cmp  ax, 12
        jne  is_no_error_code
    cmp  ax, 13
    jne  is_no_error_code
        cmp  ax, 14
    jne  is_no_error_code
    cmp  ax, 17
        jne  is_no_error_code
    
    ; pop error_code
    is_with_error_code:
        pop  rdx

    is_no_error_code:
        ;

    mov  dx, ax ; save int number

    ; X
    ; num mod y_values
    xor  ah, ah
    mov  bl, y_values
    div  bl
    mov  al, ah
    xor  ah, ah
    xor  reg_y, reg_y
    mov  reg_y, ax

    ; Y
    ; x_step * ( num / y_values )
    mov  al, dl 
    mov  bl, y_values
    div  bl
    xor  ah, ah
    imul ax, x_step
    mov  reg_x, ax

    ; num
    xor  ah, ah
    mov  al, dl 

    ; print
    r_trigger equ r10
    cmp r_trigger, 0
    je  print_style_blue
    jmp print_style_green

    print_style_blue:
        mov  bh, style_green
        not  r_trigger

    print_style_green:
        mov  bh, style_green
        not  r_trigger

    call print_dec_at

    sti

    cmp al, 32
    je  TimerIRQ
    jge isr_exit
    ; hlt
    ; jmp $

    isr_exit:
        mov al, 0x20
        out 0x20, al    ; Send the EOI to the PIC

    pop dx
    pop bx
    pop ax

iret


TimerIRQ:
    mov  eax, [CountDown]
    
    test eax, eax
    jz   TimerDone

    dec  eax
    mov  [CountDown], eax

    TimerDone:
        jmp isr_exit
iret

; IDTR register value
idtr_store_2:
    dw idt_64_end - idt_64_start  - 1 ; limit. 16 bit. 0x0FFF
    dq idt_64_start                   ; base.  64 bit. 0xA200
    ; dw 0x0FFF
    ; dq 0x7D19

CountDown: dd 100
