format ELF64
; format MS64 COFF

public main
;entry start

include "ops.inc"
include "cdecl.inc"
include "types.inc"


macro dispatch
{
    ;
}

start:
proc main argc, argv

    lea eax, [argc]
    lea ebx, [argv]

    ; RDI = arg1
    ; RSI = arg2
    ; RDX = opcode
    ; RCX = instance
    ; R8  = store
    ; R9  = store.first
    ; R10 = store.last
  
    ops_init

main_loop:
    ops_pop
    dispatch

    jmp main_loop

    ret

endp
