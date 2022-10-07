
setup_apic2:
    ; Enable specific interrupts
    OUT_PIC_1 11111001_b    ; Enable Cascade, Keyboard
    ; OUT_PIC_2 11111110_b    ; Enable RTC

    ; ; Set the periodic flag in the RTC
    ; mov  al, 0x0B           ; Status Register B
    ; out  0x70, al           ; Select the address
    ; in   al, 0x71           ; Read the current settings
    ; push rax
    ; mov  al, 0x0B           ; Status Register B
    ; out  0x70, al           ; Select the address
    ; pop  rax
    ; bts  ax, 6              ; Set Periodic(6)
    ; out  0x71, al           ; Write the new settings

    ; ; Acknowledge the RTC
    ; mov  al, 0x0C           ; Status Register C
    ; out  0x70, al           ; Select the address
    ; in   al, 0x71           ; Read the current settings
ret


; 
; 0XH - 82489DX discrete APIC
; 10H - 15HIntegrated APIC.
; 31       23       15               0
; +--------+--------+--------+--------+
; |********|        |        |        | Reserved
; |       *|        |        |        | Support for EOI-broadcast suppression
; |        |********|        |        | Max LVT Entry
; |        |        |********|        | Reserved
; |        |        |        |********| Version
; +--------+--------+--------+--------+
; Value after reset: 00BN 00VVH
; V = Version, N = # of LVT entries minus 1,
; B = 1 if EOI-broadcast suppression supported
; Address: FEE0 0030H
local_apic_version:
    ; Local_APIC_Version_Register equ FEE0_0030_H
    
    ; mov eax, Local_APIC_Version_Register
ret

; CPUID.01H:ECX[21] = 1
; CPUID.01H:ECX.x2APIC = 1

; CPUID.01H:EDX[9] = 1
; CPUID.01H:EDX.APIC = 1

; MSR.1BH
;   IA32_APIC_BASE[11] == 0
