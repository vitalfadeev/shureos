;
; print helo
;
; requires:
;   print_string_bios

macro print message
{
    mov bx, message
    call print_string_bios
}
