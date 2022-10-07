;
; print_string_vga
;
; RSI - string, zero ended
; RDI - style
;
; Since we no longer have access to BIOS utilities, this function
; takes advantage of the VGA memory area. We will go over this more
; in a subsequent chapter, but it is a sequence in memory which
; controls what is printed on the screen.

use64

; Define necessary constants
vga_start                  equ 0x000B8000
vga_extent                 equ (80 * 25 * 2)           ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
style_wb                   equ 0x0F

; Simple 32-bit protected print routine
; Style stored in rdi, message stored in rsi
print_string_vga:
    ; The pusha command stores the values of all
    ; registers so we don't have to worry about them
    push rax
    push rdx
    push rdi
    push rsi

    mov rdx, vga_start
    shl rdi, 8

    ; Do main loop
    print_string_vga_loop:
        ; If char == \0, string is done
        cmp byte[rsi], 0
        je  print_string_vga_done

        ; Handle strings that are too long
        cmp rdx, vga_start + vga_extent
        je print_string_vga_done

        ; Move character to al, style to ah
        mov rax, rdi
        mov al, byte[rsi]

        ; Print character to vga memory location
        mov word[rdx], ax

        ; Increment counter registers
        add rsi, 1
        add rdx, 2

        ; Redo loop
        jmp print_string_vga_loop

print_string_vga_done:
    ; Popa does the opposite of pusha, and restores all of
    ; the registers
    pop rsi
    pop rdi
    pop rdx
    pop rax

    ret