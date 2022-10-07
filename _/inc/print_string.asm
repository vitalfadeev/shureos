; 
; Print string
;
; Example:
;   _start:
;       prints 0xd, 0xa, 9
;       prints 'hi!', 0xd, 0xa
;       mov ax, msg
;       prints ax, 0xd, 0xa
;       prints msg
;   
;       int 0x20
;   ret
;  
;   msg db 'hey there!', 0x24
;
macro print_string [str*]
{
print_string:
    ; In SI = String.
    ; Out = Nothing.

    ; Setup int 10h parameters.
    mov ah, 0x0E
    mov bh, 0x00

.loop:
    ; Load a byte from SI into AL
    ; and then increase SI.
    lodsb

    ; If AL contains a null-terminating
    ; character, then stop printing.
    cmp al, 0x00
    je .done

    int 10h

    jmp .loop

.done:
    ; Return control to the caller.
    ret


string: db "Hello, world!", 0
}
