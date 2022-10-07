;
; print helo
;

;include "../../_/inc/print_string_bios.inc"

macro print_helo
{
    mov bx, msg_hello_world
    call print_string_bios
}

msg_hello_world:                db 'Hello World!', 0
