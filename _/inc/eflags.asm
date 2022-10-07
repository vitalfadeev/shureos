;
; eflags
;
;
; 31       23       15        7      0
; +--------+--------+--------+--------+
; |        |        |        |       *| CF
; |        |        |        |      * | 1
; |        |        |        |     *  | PF
; |        |        |        |    *   | 0
; |        |        |        |   *    | AF
; |        |        |        |  *     | 0
; |        |        |        | *      | ZF
; |        |        |        |*       | SF
; +--------+--------+--------+--------+ 
; |        |        |       *|        | TF
; |        |        |      * |        | IF
; |        |        |     *  |        | DF
; |        |        |    *   |        | OF
; |        |        |  **    |        | IOPL
; |        |        | *      |        | NT
; |        |        |*       |        | 0
; +--------+--------+--------+--------+ 
; |        |       *|        |        | RF
; |        |      * |        |        | VM
; |        |     *  |        |        | AC
; |        |    *   |        |        | VIF
; |        |   *    |        |        | VIP
; |        |  *     |        |        | ID
; |        | *      |        |        | 0
; |        |*       |        |        | 0
; +--------+--------+--------+--------+ 
; |       *|        |        |        | 0
; |      * |        |        |        | 0
; |     *  |        |        |        | 0
; |    *   |        |        |        | 0
; |   *    |        |        |        | 0
; |  *     |        |        |        | 0
; | *      |        |        |        | 0
; |*       |        |        |        | 0
; +--------+--------+--------+--------+
; 31   0
; ..   0
; 20   0
; 21 X ID Flag (ID)
; 20 X Virtual Interrupt Pending (VIP)
; 19 X Virtual Interrupt Flag (VIF)
; 18 X Alignment Check / Access Control (AC)
; 17 X Virtual-8086 Mode (VM)
; 16 X Resume Flag (RF)
; 15   0
; 14 X Nested Task (NT)
; 13 X I/O Privilege Level (IOPL). b.1
; 12   I/O Privilege Level (IOPL). b.0
; 11 S Overflow Flag (OF)
; 10 C Direction Flag (DF)
;  9 X Interrupt Enable Flag (IF)
;  8 X Trap Flag (TF)
;  7 S Sign Flag (SF)
;  6 S Zero Flag (ZF)
;  5   0
;  4 S Auxiliary Carry Flag (AF)
;  3   0
;  2 S Parity Flag (PF)
;  1   1
;  0 S Carry Flag (CF)
;
; S Indicates a Status Flag
; C Indicates a Control Flag
; X Indicates a System Flag

EFLAGS.CF   equ ( 1 shl  0 )
EFLAGS.1    equ ( 1 shl  1 )
EFLAGS.PF   equ ( 1 shl  2 )
EFLAGS.3    equ ( 1 shl  3 )
EFLAGS.AF   equ ( 1 shl  4 )
EFLAGS.5    equ ( 1 shl  5 )
EFLAGS.ZF   equ ( 1 shl  6 )
EFLAGS.SF   equ ( 1 shl  7 )
EFLAGS.TF   equ ( 1 shl  9 )
EFLAGS.IF   equ ( 1 shl  9 )
EFLAGS.DF   equ ( 1 shl 10 )
EFLAGS.OF   equ ( 1 shl 11 )
EFLAGS.IOPL equ ( 11_b shl 12 )
EFLAGS.NT   equ ( 1 shl 14 )
EFLAGS.15   equ ( 1 shl 15 )
EFLAGS.RF   equ ( 1 shl 16 )
EFLAGS.VM   equ ( 1 shl 17 )
EFLAGS.AC   equ ( 1 shl 18 )
EFLAGS.VIF  equ ( 1 shl 19 )
EFLAGS.VIP  equ ( 1 shl 20 )
EFLAGS.ID   equ ( 1 shl 21 )
EFLAGS.21   equ ( 1 shl 21 )
