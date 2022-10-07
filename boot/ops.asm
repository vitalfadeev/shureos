
include "operation.inc"

struc times [arg] 
{ 
common 
  match n def, arg \{ 
    rept 1 %:1 \\{ . def  \\} 
    rept n-1 %:2 \\{ .\\#_\\#% def \\} 
  \} 
}

r_ops_start equ r8
r_ops_first equ r9
r_ops_last  equ r10


OPS_MAX_SIZE equ 1024;

; array
ops times OPS_MAX_SIZE Operation


section '.data' writeable

    szDeleteEvent   db "delete_event", 0
    szExitMsg       db "closing application...", 10, 10, 0
    szClicked       db "clicked", 0
    szClickMe       db "Click me!", 0
    szWasClicked    db "Button was clicked...", 10, 10, 0


section '.bss' writeable

    hWindow     dd ?
    hButton     dd ?


section '.text' executable


macro ops_store_init ops_start_ptr
{
    mov     r_ops_start, ops         ; load into registers
    mov     r_ops_first, r_ops_start ; first = store.ptr;
    mov     r_ops_last,  r_ops_start ; last  = store.ptr;
}

macro ops_init
{
    mov     r_ops_start, ops
    ops_store_init ops_start_ptr
}

macro ops_pop
{
    ;
}


macro ops_push
{
    ;
}
