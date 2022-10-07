;
; print
;

; Since we no longer have access to BIOS utilities, this function
; takes advantage of the VGA memory area. We will go over this more
; in a subsequent chapter, but it is a sequence in memory which
; controls what is printed on the screen.

; Number  Name          RGB          Hex
; ------  ------------  -----------  --------
;      0  Black           0   0   0  00 00 00
;      1  Blue            0   0 170  00 00 AA
;      2  Green           0 170   0  00 AA 00
;      3  Cyan            0 170 170  00 AA AA
;      4  Red           170   0   0  AA 00 00
;      5  Purple        170   0 170  AA 00 AA
;      6  Brown         170  85   0  AA 55 00
;      7  Gray          170 170 170  AA AA AA
;      8  Dark Gray      85  85  85  55 55 55
;      9  Light Blue     85  85 255  55 55 FF
;     10  Light Green    85 255  85  55 FF 55
;     11  Light Cyan     85 255 255  55 FF FF
;     12  Light Red     255  85  85  FF 55 55
;     13  Light Purple  255  85 255  FF 55 FF
;     14  Yellow        255 255  85  FF FF 55
;     15  White         255 255 255  FF FF FF


use64

vga_start                  equ 000B_8000_H
vga_extent                 equ (80 * 25 * 2)   ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
vga_stride                 equ (80 * 2)        ; VGA Memory is 80 chars (one char is 2 bytes)
style_wb                   equ 0F_H

; Simple 32-bit protected print routine
;   RDI : style
;   RSI : message
print_long:
    ; The pusha command stores the values of all
    ; registers so we don't have to worry about them
    push rax
    push rdx
    push rdi
    push rsi

    mov edx, vga_start
    shl edi, 8

    ; Do main loop
    print_long_loop:
        ; If char == \0, string is done
        cmp byte[rsi], 0
        je  print_long_done

        ; Handle strings that are too long
        cmp edx, vga_start + vga_extent
        je print_long_done

        ; Move character to al, style to ah
        mov ax, di
        mov al, byte[rsi]

        ; Print character to vga memory location
        mov word[rdx], ax

        ; Increment counter registers
        add esi, 1
        add edx, 2

        ; Redo loop
        jmp print_long_loop

print_long_done:
    ; Popa does the opposite of pusha, and restores all of
    ; the registers
    pop rsi
    pop rdi
    pop rdx
    pop rax

ret


; Simple 32-bit protected print routine
;   RDI : style
;   RSI : message
;   R11 : x
;   R12 : y
print_at_long:
    reg_x equ r11
    reg_y equ r12

    ; The pusha command stores the values of all
    ; registers so we don't have to worry about them
    push rax
    push rdx
    push rdi
    push rsi
    push r11
    push r12

    mov  rdx, vga_start
    shl  reg_x, 1 ; *2
    add  rdx, reg_x
    imul reg_y, vga_extent
    add  rdx, reg_y

    shl rdi, 8

    ; Do main loop
    print_at_long_loop:
        ; If char == \0, string is done
        cmp byte[rsi], 0
        je  print_at_long_done

        ; Handle strings that are too long
        cmp rdx, vga_start + vga_extent
        je print_at_long_done

        ; Move character to al, style to ah
        mov rax, rdi
        mov al, byte[rsi]

        ; Print character to vga memory location
        mov word[rdx], ax

        ; Increment counter registers
        add rsi, 1
        add rdx, 2

        ; Redo loop
        jmp print_at_long_loop

print_at_long_done:
    ; Popa does the opposite of pusha, and restores all of
    ; the registers
    pop r12
    pop r11
    pop rsi
    pop rdi
    pop rdx
    pop rax

ret

; Decimal value to string of ASCII chars
;   AX  : decimal value. 0..255
;   EDI : destination string location
; Result:
;   EDI : string of ASCII chars
; Example:
;   mov ax, 1
;   dec_to_string
;   cmp byte [edi], '1' ; ASCII.49
; Example 2:
;   mov ax, 11
;   dec_to_string
;   cmp byte [edi  ], '1' ; ASCII.49
;   cmp byte [edi+1], '1' ; ASCII.49
; Example 3:
;   mov ax, 111
;   dec_to_string
;   cmp byte [edi  ], '1' ; ASCII.49
;   cmp byte [edi+1], '1' ; ASCII.49
;   cmp byte [edi+2], '1' ; ASCII.49
;
; Uses: 
;   AX, CX, DX, EDI
dec_to_string:
    mov  dx, ax      ; save ax

    loop_start2:
        and  ax, 1111_b
        cmp  ax, 9
        jle  dec_ok2

        dec_over2:
            sub  ax, 10
            add  ax, 48  ; '0' ; ASCII.48
            stosb
            ; next_char
            mov  ax, dx
            mov  cl, 10  ; ... / 10
            div  cl
            mov  dx, ax

            jmp  loop_start2

        dec_ok2:
            add  ax, 48 ; '0' ; ASCII.48
            stosb
ret

; Display decimal value. In VGA Text mode
;   AL  : decimal value. 0..255
;   BH  : style
;   EDI : destination
; Result:
;   String on screen
; Example:
;   mov ax, 1
;   print_dec
; Example 2:
;   mov ax, 11
;   print_dec
; Example 3:
;   mov ax, 111
;   print_dec
;
; Uses: 
;   AX, BX, EDI
print_dec:
    push rax
    push rbx

    reg_style equ bh
    reg_rest  equ bl

    ; digits
    cld              ; forward direction STOSW.EDI

    ; > 100
    cmp  al, 100
    jnc  dec_greater_100  ; 127 <= AL <= 255. for unsigned > 127.
    jl   dec_lower_100    ;   0 <= AL <= 100

    dec_greater_100:
        mov  bl, 100 ; / 100
        div  bl
        mov  reg_rest, ah  ; rest

        ; print
        mov  ah, reg_style
        add  al, 48  ; '0' ; ASCII.48
        stosw

        ; next digit
        ; test 01 .. 09
        cmp  reg_rest, 10
        jge  dec_10_99

        ; 01 .. 09
        dec_01_09:
            ; print '0'
            mov  ah, reg_style
            mov  al, '0'  ; ASCII.48
            stosw      
            mov  al, reg_rest  ; rest to AX
            jmp  dec_lower_10

        ; 10 .. 99
        dec_10_99:
            mov  al, reg_rest  ; rest to AX
            jmp  dec_greate_10

    ; < 100
    dec_lower_100:
        ; print start ' '
        mov  reg_rest, al
        mov  ah, reg_style
        mov  al, ' '  ; ASCII.48
        stosw      
        mov  al, reg_rest  ; rest to AX

        ;
        cmp  al, 10
        jge  dec_greate_10

        ; print middle ' '
        mov  ah, reg_style
        mov  al, ' '  ; ASCII.48
        stosw      
        mov  al, reg_rest  ; rest to AX
        jmp  dec_lower_10

        ; > 10
        dec_greate_10:
            mov  ah, 0   ; 
            mov  bl, 10  ; / 10
            div  bl
            mov  reg_rest, ah  ; rest

            ; print
            mov  ah, reg_style
            add  al, 48  ; '0' ; ASCII.48
            stosw

            ; next digit
            mov  al, reg_rest

        ; < 10
        dec_lower_10:
            mov  ah, reg_style
            add  al, 48  ; '0' ; ASCII.48
            stosw

    pop  rbx
    pop  rax
ret

; Display hex value. In VGA Text mode
;   AL  : Value. 0..255. 00..FF.
;   BH  : style
;   EDI : destination
; Result:
;   String on screen
; uses: 
;   AX, BX, EDI
print_hex:
    mov  bl, ah

    ; 1.
    char1:
        and  al, 1111_B

        cmp  al, 9
        jg   print_A_F

        ; 0..9
        print_0_9:
            mov  ah, bh
            add  al, 48  ; '0' ; ASCII.48
            stosw
            jmp  char2

        ; A..F
        print_A_F:
            ; print A..F
            mov  ah, bh
            add  al, 65-10  ; 'A' ; ASCII.65
            stosw

    ; .2
    char2:
        mov  al, bl

        cmp  al, 9
        jg   char2_print_A_F

        ; 0..9
        char2_print_0_9:
            add  al, 48  ; '0' ; ASCII.48
            stosw
            jmp  exit

        ; A..F
        char2_print_A_F:
            ; print A..F
            add  al, 65-10  ; 'A' ; ASCII.65
            stosw

    exit:
        ;
ret

; Display decimal value. In VGA Text mode
;   AL : decimal value. 0..255
;   BH : style
; R11W : X
; R12W : Y
; Uses: 
;   EDI
print_dec_at:
    reg_x equ r11w
    reg_y equ r12w

    push rax
    push rbx
    push rdx

    ; VGA Text
    mov  edi, vga_start
    ; X
    xor  edx, edx
    mov  dx, reg_x
    shl  dx, 1 ; *2
    add  edi, edx
    ; Y
    xor  edx, edx
    mov  dx, reg_y
    imul edx, vga_stride
    add  edi, edx
    ; print
    call print_dec

    pop  rdx
    pop  rbx
    pop  rax
ret
