;
; unit
;
include "../../_/inc/enum.inc"

enum $1,1, \
    TYPE_OS_UNIT, \
    TYPE_PROCESS_UNIT, \
    TYPE_INPUT_FIELD_UNIT, \
    TYPE_

entry_point:
    ;

;
struc unit first_child,last_child,left,right,parent,entry_point,type
{
        .first_child dw first_child
        .last_child  dw last_child
        .left        dw left
        .right       dw right
        .parent      dw parent
        .entry_point dw entry_point
        .type        dw type
}

; unit
;   unit
;     unit

; os_unit
;   process_unit
;     input_field_unit

; entry_point:      ; opcode, a1, a2, a3, a4
;   cmp opcode
;     case OPCODE1
;       process a1, a2, a3, a4
;       jmp os_main_loop
;     case OPCODE2
;       process a1, a2, a3, a4
;       jmp os_main_loop

