
r_arg1        equ rdi
r_arg2        equ rsi
r_opcode      equ rdx
r_instance    equ rcx

r_store_start equ r8
r_store_first equ r9
r_store_last  equ r10


STORE_MAX_SIZE = 1024
static T[ STORE_MAX_SIZE ] store            ; first in first out


macro store_init _start
{
    mov     r_store_start, _start           ; load into registers
    mov     r_store_first, r_store_start    ; first = store.ptr;
    mov     r_store_first, r_store_start    ; last  = store.ptr;
}


macro store_empty
{
    cmp     r_store_first, r_store_last     ;
}


macro store_pop
{
    mov     r_arg1, [r_store_first]                         ;
    mov     r_arg2, [r_store_first + size_t.sizeof]         ;
    mov     r_opcode, [r_store_first + size_t.sizeof * 2]   ;
    mov     r_instance, [r_store_first + size_t.sizeof * 3] ;
}


macro store_push
{
    ;
}

