;
; Main loop
;
macro main_loop
{    
main_loop:
    hlt                     ; Stop CPU. Wait for interrupt

    check_operations_store  ; Check store size, read new operation, dispatch, read all operations from store, dispatch

    jmp main_loop           ;
}


macro check_operations_store
{
    ; check_operations_store_size ;
    ; read_operation              ;
    ; dispatch                    ;
}

