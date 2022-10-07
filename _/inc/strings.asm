;
; strings
;

; macro to code bytes
macro String string ;Place Constant String Onto the Stack
{
    local length, ptr, calculated, zero

    length : dd calculated ; <---- size of string goes here
    ptr    : db string
    calculated = $ - ptr
    zero   : db 0
}

