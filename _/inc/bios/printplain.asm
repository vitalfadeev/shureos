;
; printplain
;
printplain:
; in: si->string
        pusha
        lodsb
@@:
        call    putchar
        lodsb
        test    al, al
        jnz     @b
        popa
        ret
