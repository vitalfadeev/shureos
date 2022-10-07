;
; gdt_32
;

;
; Define the Flat Mode Configuration Global Descriptor Table (GDT)
; The flat mode table allows us to read and write code anywhere, without restriction
;

use16

struc gdt_32_descriptor_data_struct
{
    .limit dw        11111111_11111111_b ; limit
    .base1 dw        00000000_00000000_b ; base1
    .base2 db        00000000_b          ; base2
    .flags db        10010011_b          ; flags
    ;                .                   ;   P   
    ;                 ..                 ;   DPL 
    ;                   .                ;   S   
    ;                    ....            ;   Type
    ;                    .               ;    code
    ;                     .              ;    C  
    ;                      .             ;    R  
    ;                       .            ;    A  
    .flags2 db       11001111_b          ; flags 2
    ;                .                   ;   G    
    ;                 .                  ;   D/B  
    ;                  .                 ;   L    
    ;                   .                ;   AVL  
    ;                    ....            ;   Seg limit 16..19
    .base3 db        00000000_b
}

struc gdt_32_descriptor_code_struct
{
    .limit dw        11111111_11111111_b ; limit
    .base1 dw        00000000_00000000_b ; base1
    .base2 db        00000000_b          ; base2
    .flags db        10011011_b          ; flags
    ;                .                   ;   P   
    ;                 ..                 ;   DPL 
    ;                   .                ;   S   
    ;                    ....            ;   Type
    ;                    .               ;    code
    ;                     .              ;    C  
    ;                      .             ;    R  
    ;                       .            ;    A  
    .flags2 db       11001111_b          ; flags 2
    ;                .                   ;   G    
    ;                 .                  ;   D/B  
    ;                  .                 ;   L    
    ;                   .                ;   AVL  
    ;                    ....            ;   Seg limit 16..19
    .base3 db        00000000_b
}


; GDT
gdt_32_start:

; Define the null sector for the 32 bit gdt
; Null sector is required for memory integrity check
gdt_32_null:
    dd 0x00000000           ; All values in null entry are 0
    dd 0x00000000           ; All values in null entry are 0

gdt_32_descriptor_code gdt_32_descriptor_code_struct
gdt_32_descriptor_data gdt_32_descriptor_data_struct

gdt_32_end:
    ;


; Define the gdt descriptor
; This data structure gives cpu length and start address of gdt
; We will feed this structure to the CPU in order to set the protected mode GDT
gdtr_32:
    dw (gdt_32_end - gdt_32_start - 1)  ; Limit. 16 bit. Size of GDT, one byte less than true size
    dd gdt_32_start                     ; Base.  32 bit. Start of the 32 bit gdt

; Define helpers to find pointers to Code and Data segments
code_seg   equ (gdt_32_descriptor_code - gdt_32_start)
data_seg   equ (gdt_32_descriptor_data - gdt_32_start)
