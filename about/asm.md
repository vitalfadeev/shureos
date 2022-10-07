;
; asm
;
# ASM

## jump by selector to handler (switch-case-goto)

```asm
; CX : selector (0, 1, 2, 3)
;      mov cx, [selector]

use64

; by selector
    and cx, 0000_0011_b
    jmp qword[.table + rcx * 8]

; Handlers
virtual
align 8
.table:
     dq \
        int_0_handler, \
        int_1_handler, \
        int_2_handler
end virtual
```

