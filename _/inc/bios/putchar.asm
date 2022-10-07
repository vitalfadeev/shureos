;
; putchar
;
putchar:
; in: al=character
        mov     ah, 0Eh
        mov     bh, 0
        int     10h
        ret
