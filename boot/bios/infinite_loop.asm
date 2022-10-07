;
; infinite loop
;

macro infinite_loop
{
infinite_loop:
    ; This hangs the computer.
    hlt
    jmp infinite_loop
}
