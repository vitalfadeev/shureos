;
; gdt_64
;

;
; Define the Flat Mode Configuration Global Descriptor Table (GDT)
; The flat mode table allows us to read and write code anywhere, without restriction
;

align 8

; (64 bit length)
struc gdt_64_descriptor_data_struct
{
    ;                ********_********
    .limit dw        00000000_00000000_b ; ignored
    ;                ********_********
    .base1 dw        00000000_00000000_b ; ignored

    ;                ********_********
    .base2 db                 00000000_b ; ignored
    .flags db        10010011_b          ; flags    (93_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1: code, 0: data
    ;                ****                ; 
    ;                   .                ;   S (1: code|data, 0: system)
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    ;                             ****   ; ignored
    .flags2 db                10100000_b ; flags 2  (A0_h)
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .base3 db        00000000_b          ; ignored
}

; (64 bit length)
struc gdt_64_descriptor_code_struct
{
    ;                ********_********
    .limit dw        00000000_00000000_b ; ignored
    ;                ********_********
    .base1 dw        00000000_00000000_b ; ignored

    ;                ********_********
    .base2 db                 00000000_b ; ignored
    .flags db        10011011_b          ; flags    (9B_h)
    ;                    ****            ;   Type
    ;                       .            ;    A  
    ;                      .             ;    R  
    ;                     .              ;    C  
    ;                    .               ;    1: code, 0: data
    ;                ****                ; 
    ;                   .                ;   S (1: code|data, 0: system)
    ;                 ..                 ;   DPL 
    ;                .                   ;   P   

    ;                ********_********
    ;                             ****   ; ignored
    .flags2 db                10100000_b ; flags 2  (A0_h)
    ;                         ****       ;   
    ;                            .       ;   AVL
    ;                           .        ;   L    
    ;                          .         ;   D/B  
    ;                         .          ;   G    
    .base3 db        00000000_b          ; ignored
}


;
macro gdt_64.init
{
    lgdt [gdtr_64_store]
}


; GDT
align 8
gdt_64_start:

; Define the null sector for the 64 bit gdt
; Null sector is required for memory integrity check
gdt_64_null:
    dq 00000000_h        ; All values in null entry are 0.  (64 bit length)
    gdt_64_descriptor_code gdt_64_descriptor_code_struct  ; (64 bit length)
    gdt_64_descriptor_data gdt_64_descriptor_data_struct  ; (64 bit length)
gdt_64_end:


; Define the gdt descriptor
; This data structure gives cpu length and start address of gdt
; We will feed this structure to the CPU in order to set the protected mode GDT
gdtr_64_store:
    dw gdt_64_end - gdt_64_start - 1  ; Limit. 16 bit. Size of GDT, one byte less than true size
    dq gdt_64_start                   ; Base.  64 bit. Start of the 64 bit gdt


; Define helpers to find pointers to Code and Data segments
code_seg_64   equ ( gdt_64_descriptor_code - gdt_64_start )
data_seg_64   equ ( gdt_64_descriptor_data - gdt_64_start )

code_seg_64_sel equ code_seg_64
data_seg_64_sel equ data_seg_64
