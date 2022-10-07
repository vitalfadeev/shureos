;
; print
;
print:
; in: si->string
        mov     al, 186
        call    putchar
        mov     al, ' '
        call    putchar

