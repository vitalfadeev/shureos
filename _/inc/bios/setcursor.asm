;
; setcursor
;
setcursor:
; in: dl=column, dh=row
        mov     ah, 2
        mov     bh, 0
        int     10h
        ret

macro _setcursor row,column
{
        mov     dx, row*256 + column
        call    setcursor
}
