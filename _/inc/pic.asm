;
; pic
;
;
; apic
;

; Advanced Programmable Interrupt Controller (APIC)
;
; +------------------+-------------------------------+
; |   Chip set       |   CPU                         |
; |                  |                               |
; |   +----------+   |   +------------+   +------+   |
; |   | I/O APIC |===|===| Local APIC |===| Core |   |
; |   +----------+   |   +------------+   +------+   |
; |                  |                               |
; +------------------+-------------------------------+
;
; The local APIC performs two primary functions for the processor:
; - It receives interrupts from the processor’s interrupt pins, from internal sources and 
;   from an external I/O APIC (or other external interrupt controller). 
;   It sends these to the processor core for handling.
; - In multiple processor (MP) systems, it sends and 
;   receives interprocessor interrupt (IPI) messages to and 
;   from other logical processors on the system bus. 
;   IPI messages can be used to distribute interrupts among the processors 
;   in the system or to execute system wide functions 
;   (such as, booting up processors or distributing work among a group of processors).


; sources:
;   pins: RESET#, FLUSH#, STPCLK#, SMI#, R/S#, and INIT#
;         LINT[1:0]
;   message on the system bus
;   message on the APIC serial bus

; processor’s local APIC
; system-based I/O APIC (8259A)

; Enabling or Disabling the Local APIC
; The local APIC can be enabled or disabled in either of two ways:
; 1. Using the APIC global enable/disable flag in the IA32_APIC_BASE MSR
; 2. Using the APIC software enable/disable flag in the spurious-interrupt vector register
include 'msr.asm'
include 'cpuid.asm'

; spurious-interrupt vector register SVR
pic.SVR                 equ 0FEE000F0_H
pic.SVR.APIC_ENABLED    equ ( 1 shl 8 )

; EFLAGS.CF : 0 - disabled, 1 - enabled
macro pic.local_apic.test_enabled
{
    msr.test_bit IA32_APIC_BASE, 11
}

; re-enable Local APIC
macro pic.local_apic.reenable
{
    msr.set_bit msr.APIC_BASE, 11
}

; APIC Software Enable/Disable
; EFLAGS.CR : 0 - disabled, 1 - enabled
macro pic.local_apic.test_software_enabled
{
    ; read SVR
    mov esi, pic.SVR; Address of SVR
    mov eax, [esi]
    bt  eax, pic.SVR.APIC_ENABLED
}

;
macro pic.local_apic.reenable_software_disabled
{
    ; read SVR
    mov esi, pic.SVR; Address of SVR
    mov eax, [esi]

    ; update bit
    or  eax, pic.SVR.APIC_ENABLED; Set bit 8 to enable (0 on reset)

    ; write SVR
    mov [esi], eax
}

; check Presence Local APIC
; EFLAGS.CR : 0 - no, 1 - present
macro pic.local_apic.test_presence
{
    cpuid.test_bit 01H, edx, CPUID.01H.EDX.APIC
}


;
macro pic.local_apic.enable
{
    ; test current state
    pic.local_apic.test_enabled
    jc  local_apic_enabled
    jnc local_apic_disabled

    local_apic_enabled:
        pic.local_apic.test_software_enabled
        jc  local_apic_software_enabled
        jnc local_apic_software_disabled

        local_apic_software_enabled:
            ;

        local_apic_software_disabled:
            ; re-enable
            or  eax, pic.SVR.APIC_ENABLED   ; Set bit 8 to enable (0 on reset)
            mov [esi], eax                  ; write SVR

    local_apic_disabled:
        ; check Presence Local APIC
        pic.local_apic.test_presence
        jc  has_local_apic
        jnc no_local_apic

        has_local_apic:
            ; re-enable Local APIC
            pic.local_apic.reenable

        no_local_apic:
            ;
}

;
macro pic.local_apic.disable
{
    ;
}

;
macro pic.local_apic.location
{
    msr.read_bits msr.APIC_BASE, 12, 35 ; 12..35 includes 35. 24 bit
}

