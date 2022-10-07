;
; Prints a uppercase A.
;
macro print_a
{
    mov ah, 0x0E
    mov al, 'A'
    mov bh, 0x00
    int 10h
}
