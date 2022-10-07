;
; getkey
;
getkey:                         ; Use BIOS INT 16h to read a key from the keyboard
; get number in range [bl,bh] (bl,bh in ['0'..'9'])
; in: bx=range
; out: ax=digit (1..9, 10 for 0)
        mov     ah, 0       ; If 'int 16h' is called with 'ah' equal to zero, the BIOS will not return control to the caller
        int     16h         ; until a key is available in the system type ahead buffer. On return, 'al' contains the ASCII
        cmp     al, 27      ; code for the key read from the buffer and 'ah' contains the keyboard scan code. (27=>ESC)
        jz      @f          ; If ESC is pressed, return (user doesn't want to change any value).
        cmp     al, bl      ; Compare 'al' (ASCII code of key pressed) with 'bl' (lowest accepted char from the range).
        jb      getkey      ; ASCII code is below lowest accepted value => continue waiting for another key.
        cmp     al, bh      ; Compare 'al' (ASCII code of key pressed) with 'bh' (highest accepted char from the range).
        ja      getkey      ; ASCII code is above highest accepted value => continue waiting for another key.
        push    ax          ; If the pressed key is in the accepted range, save it on the stack and echo to screen.
        call    putchar
        pop     ax
        and     ax, 0Fh     ; Convert ASCII code to number: '1'->1, '2'->2, etc. 0Fh=1111b.
        jnz     @f          ; ASCII code for '0' is 48 (110000b). (110000b AND 1111b) = 0
        mov     al, 10      ; So if key '0' was entered, return 10 in 'ax'
@@:
        ret
