;
; msr
;
; MSR
;   RDMSR
;   WRMSR
;     mov ecx, IA32_P5_MC_ADDR
;     rdmsr
;     ; readed into EDX:EAX


macro msr.test_bit msr_number, bit
{
    mov ecx, msr_number
    rdmsr
    if bit < 32
        bt  eax, bit
    else
        bt  edx, bit-32
    end if
;     jc  bit_set
;     jnc bit_not_set
; bit_set:
;     ;
; bit_not_set:
;     ;
}

;
macro msr.set_bit  msr_number, bit
{
    mov ecx, msr_number
    bst eax, bit
    wrmsr    
}

; EAX : result
macro msr.read_bits  msr_number, bit_start, bit_limit
{
    mov ecx, msr_number
    rdmsr

    if bit_start < 32
        shr eax, bit_start

        if bit_limit  < 32
            and eax, ( ( 1 shl ( bit_limit - bit_start + 1 ) ) - 1 )

        else
            and eax, ( ( 1 shl ( 32 - bit_start + 1 ) ) - 1 )
            and edx, ( ( 1 shl ( bit_limit - 32 + 1 ) ) - 1 )
            shl rdx, 32
            or  rax, rdx

        end if

    else
        shr edx, bit_start - 32
        and edx, ( ( 1 shl ( bit_limit - bit_start + 1 ) ) - 1 )
        mov eax, edx

    end if
}


;
IA32_P5_MC_ADDR                     equ  0_H ;  0
 msr.P5_MC_ADDR                     equ  0_H ;  0

IA32_P5_MC_TYPE                     equ  1_H ;  1
 msr.P5_MC_TYPE                     equ  1_H ;  1

IA32_MONITOR_FILTER_SIZE            equ  6_H ;  6
 msr.MONITOR_FILTER_SIZE            equ  6_H ;  6

IA32_TIME_STAMP_COUNTER             equ 10_H ; 16 
 msr.TSC                            equ 10_H ; 16

IA32_PLATFORM_ID                    equ 17_H ; 23
 msr.MSR_PLATFORM_ID                equ 17_H ; 23

IA32_APIC_BASE                      equ 1B_H ; 27
 msr.APIC_BASE                      equ 1B_H ; 27
 msr.APIC_BASE.0                    equ (         1        ) ; Reserved
 msr.APIC_BASE.1                    equ (         1 shl  1 ) ; Reserved
 msr.APIC_BASE.2                    equ (         1 shl  2 ) ; Reserved
 msr.APIC_BASE.3                    equ (         1 shl  3 ) ; Reserved
 msr.APIC_BASE.4                    equ (         1 shl  4 ) ; Reserved
 msr.APIC_BASE.5                    equ (         1 shl  5 ) ; Reserved
 msr.APIC_BASE.6                    equ (         1 shl  6 ) ; Reserved
 msr.APIC_BASE.7                    equ (         1 shl  7 ) ; Reserved
 msr.APIC_BASE.8                    equ (         1 shl  8 ) ; BSP flag (R/W)
 msr.APIC_BASE.9                    equ (         1 shl  9 ) ; Reserved
 msr.APIC_BASE.10                   equ (         1 shl 10 ) ; Enable x2APIC mode.
 msr.APIC_BASE.11                   equ (         1 shl 11 ) ; APIC Global Enable (R/W)
 msr.APIC_BASE.12_62                equ (11111111_11111111_11111111_11111111_B shl 12 ) ; APIC Base (R/W)
 msr.APIC_BASE.63                   equ (         1 shl 63 ) ; Reserved

IA32_FEATURE_CONTROL                equ 3A_H ; 58
 msr.FEATURE_CONTROL                equ 3A_H ; 58
 msr.FEATURE_CONTROL.0              equ (         1        ) ; Lock bit (R/WO):
 msr.FEATURE_CONTROL.1              equ (         1 shl 1  ) ; Enable VMX inside SMX operation (R/WL)
 msr.FEATURE_CONTROL.2              equ (         1 shl 2  ) ; Enable VMX outside SMX operation (R/WL)
 msr.FEATURE_CONTROL.3_7            equ (   11111_B shl 3  ) ; Reserved
 msr.FEATURE_CONTROL.8_14           equ ( 1111111_B shl 8  ) ; SENTER Local Function Enables (R/WL)
 msr.FEATURE_CONTROL.15             equ (         1 shl 15 ) ; SENTER Global Enable (R/WL)
 msr.FEATURE_CONTROL.16             equ (         1 shl 16 ) ; Reserved
 msr.FEATURE_CONTROL.17             equ (         1 shl 17 ) ; SGX Launch Control Enable (R/WL):
 msr.FEATURE_CONTROL.18             equ (         1 shl 18 ) ; SGX Global Enable (R/WL)
 msr.FEATURE_CONTROL.19             equ (         1 shl 19 ) ; Reserved
 msr.FEATURE_CONTROL.20             equ (         1 shl 20 ) ; LMCE On (R/WL)
 msr.FEATURE_CONTROL.21_63          equ (         1 shl 21 ) ; Reserved

IA32_TSC_ADJUST                     equ 3B_H ; 59
 msr.TSC_ADJUST                     equ 3B_H ; 59

IA32_SPEC_CTRL                      equ 48_H ; 72
 msr.SPEC_CTRL                      equ 48_H ; 72
 msr.SPEC_CTRL.0                    equ (         1        ) ; Indirect Branch Restricted Speculation (IBRS). Restricts speculation of indirect branch.
 msr.SPEC_CTRL.IBRS                 equ (         1        ) ; 
 msr.SPEC_CTRL.1                    equ (         1 shl  1 ) ; Single Thread Indirect Branch Predictors (STIBP)
 msr.SPEC_CTRL.STIBP                equ (         1 shl  1 ) ; 
 msr.SPEC_CTRL.2                    equ (         1 shl  2 ) ; Speculative Store Bypass Disable (SSBD) delays speculative execution of a load until the addresses for all older stores are known
 msr.SPEC_CTRL.SSBD                 equ (         1 shl  2 ) ; 
 msr.SPEC_CTRL.3_63                 equ (         1 shl  3 ) ; Reserved

IA32_PRED_CMD                       equ 49_H ; 73
 msr.PRED_CMD                       equ 49_H ; 73
 msr.PRED_CMD.0                     equ (         1 ) ; Indirect Branch Prediction Barrier (IBPB)
 msr.PRED_CMD.IBPB                  equ (         1 ) ; 

IA32_BIOS_UPDT_TRIG                 equ 79_H ; 121
 msr.BIOS_UPDT_TRIG                 equ 79_H ; 121

IA32_BIOS_SIGN_ID                   equ 8B_H ; 139
 msr.BIOS_SIGN_BBL_CR_D3            equ 8B_H ; 139

IA32_SGXLEPUBKEYHASH0               equ 8C_H ; 140
 msr.SGXLEPUBKEYHASH0               equ 8C_H ; 140

IA32_SGXLEPUBKEYHASH1               equ 8D_H ; 141
 msr.SGXLEPUBKEYHASH1               equ 8D_H ; 141

IA32_SGXLEPUBKEYHASH2               equ 8E_H ; 142
 msr.SGXLEPUBKEYHASH2               equ 8E_H ; 142

IA32_SGXLEPUBKEYHASH3               equ 8F_H ; 143
 msr.SGXLEPUBKEYHASH3               equ 8F_H ; 143

IA32_SMM_MONITOR_CTL                equ 9B_H ; 155
 msr.SMM_MONITOR_CTL                equ 9B_H ; 155
 msr.SMM_MONITOR_CTL.0              equ (         1        ) ; Valid (R/W)
 msr.SMM_MONITOR_CTL.1              equ (         1 shl  1 ) ; Reserved
 msr.SMM_MONITOR_CTL.2              equ (         1 shl  2 ) ; Controls SMI unblocking by VMXOFF
 msr.SMM_MONITOR_CTL.3_11           equ (111111111_B shl 3 ) ; Reserved
 msr.SMM_MONITOR_CTL.12_31          equ ( 111111111_11111111_1111_B shl 12 ) ; MSEG Base (R/W)
 msr.SMM_MONITOR_CTL.32_63          equ (         1 shl 32 ) ; Reserved

IA32_SMBASE                         equ 9E_H ; 158
 msr.SMBASE                         equ 9E_H ; 158

IA32_PMC0                           equ C1_H ; 193
 msr.PERFCTR0                       equ C1_H ; 193

IA32_PMC1                           equ C2_H ; 194
 msr.PERFCTR1                       equ C2_H ; 194

IA32_PMC2                           equ C3_H ; 195
 msr.PMC2                           equ C3_H ; 195

IA32_PMC3                           equ C4_H ; 196
 msr.PMC3                           equ C4_H ; 196

IA32_PMC4                           equ C5_H ; 197
 msr.PMC4                           equ C5_H ; 197

IA32_PMC5                           equ C6_H ; 198
 msr.PMC5                           equ C6_H ; 198

IA32_PMC6                           equ C7_H ; 199
 msr.PMC6                           equ C7_H ; 199

IA32_PMC7                           equ C8_H ; 200
 msr.PMC7                           equ C8_H ; 200

IA32_CORE_CAPABILITY                equ CF_H ; 207
 msr.CORE_CAPABILITY                equ CF_H ; 207
 msr.CORE_CAPABILITY.0_4            equ (   11111_B        ) ; Reserved.
 msr.CORE_CAPABILITY.5              equ (         1 shl 5 ) ; #AC(0) exception for split locked accesses supported.
 msr.CORE_CAPABILITY.6_31           equ (         1 shl 6 ) ; Reserved.

IA32_UMWAIT_CONTROL                 equ E1_H ; 225
 msr.UMWAIT_CONTROL                 equ E1_H ; 225
 msr.UMWAIT_CONTROL.0               equ (         1        ) ; C0.2 is not allowed by the OS.
 msr.UMWAIT_CONTROL.1               equ (         1 shl  1 ) ; Reserved.
 msr.UMWAIT_CONTROL.2_31            equ (11111111_11111111_11111111_111111_B shl 2 ) ; Determines the maximum time in TSC- quanta that the processor can reside in either C0.1 or C0.2

IA32_MPERF                          equ E7_H ; 231
 msr.MPERF                          equ E7_H ; 231

IA32_APERF                          equ E8_H ; 232
 msr.APERF                          equ E8_H ; 232

IA32_MTRRCAP                        equ FE_H ; 254
 msr.MTRRCAP                        equ FE_H ; 254
 msr.MTRRcap                        equ FE_H ; 254
 msr.MTRRCAP.0_7                    equ (11111111_B        ) ; VCNT: The number of variable memory type ranges in the processor.
 msr.MTRRCAP.VCNT                   equ (11111111_B        ) ; 
 msr.MTRRCAP.8                      equ (         1 shl  8 ) ; Fixed range MTRRs are supported when set.
 msr.MTRRCAP.9                      equ (         1 shl  9 ) ; Reserved
 msr.MTRRCAP.10                     equ (         1 shl 10 ) ; WC Supported when set.
 msr.MTRRCAP.11                     equ (         1 shl 11 ) ; SMRR Supported when set.
 msr.MTRRCAP.12                     equ (         1 shl 12 ) ; PRMRR supported when set.
 msr.MTRRCAP.13_63                  equ (11111111_11111111_11111111_11111111_1111_B shl 13 ) ; Reserved

IA32_ARCH_CAPABILITIES              equ 10A_H ; 266
 msr.ARCH_CAPABILITIES              equ 10A_H ; 266
 msr.ARCH_CAPABILITIES.0            equ (         1        ) ; RDCL_NO: The processor is not susceptible to Rogue Data Cache Load (RDCL).
 msr.ARCH_CAPABILITIES.RDCL_NO      equ (         1        ) ; 
 msr.ARCH_CAPABILITIES.1            equ (         1 shl  1 ) ; IBRS_ALL: The processor supports enhanced IBRS.
 msr.ARCH_CAPABILITIES.IBRS_ALL     equ (         1 shl  1 ) ; 
 msr.ARCH_CAPABILITIES.2            equ (         1 shl  2 ) ; RSBA: The processor supports RSB Alternate.
 msr.ARCH_CAPABILITIES.RSBA         equ (         1 shl  2 ) ; 
 msr.ARCH_CAPABILITIES.3            equ (         1 shl  3 ) ; SKIP_L1DFL_VMENTRY: A value of 1 indicates the hypervisor need not flush the L1D on VM entry.
 msr.ARCH_CAPABILITIES.SKIP_L1DFL_VMENTRY equ (   1 shl  3 ) ;
 msr.ARCH_CAPABILITIES.4            equ (         1 shl  4 ) ; SSB_NO: Processor is not susceptible to Speculative Store Bypass.
 msr.ARCH_CAPABILITIES.SSB_NO       equ (         1 shl  4 ) ; 
 msr.ARCH_CAPABILITIES.5_63         equ (         1 shl  5 ) ; Reserved

IA32_FLUSH_CMD                      equ 10B_H ; 267
 msr.FLUSH_CMD                      equ 10B_H ; 267
 msr.FLUSH_CMD.0                    equ (         1        ) ; L1D_FLUSH: Writeback and invalidate the L1 data cache.
 msr.FLUSH_CMD.L1D_FLUSH            equ (         1        ) ; 

IA32_SYSENTER_CS                    equ 174_H ; 372
 msr.SYSENTER_CS                    equ 174_H ; 372
 msr.SYSENTER_CS.0_15               equ ( 11111111_11111111_B        ) ; CS Selector.
 msr.SYSENTER_CS.16_31              equ ( 11111111_11111111_B shl 16 ) ; Not used.

IA32_SYSENTER_ESP                   equ 175_H ; 373
 msr.SYSENTER_ESP                   equ 175_H ; 373

IA32_SYSENTER_EIP                   equ 176_H ; 374
 msr.SYSENTER_EIP                   equ 176_H ; 374

IA32_MCG_CAP                        equ 179_H ; 377
 msr.MCG_CAP                        equ 179_H ; 377
 msr.MCG_CAP.0_7                    equ (11111111_B        ) ; Count: Number of reporting banks.
 msr.MCG_CAP.Count                  equ (11111111_B        ) ; 
 msr.MCG_CAP.8                      equ (         1 shl  8 ) ; MCG_CTL_P: IA32_MCG_CTL is present if this bit is set.
 msr.MCG_CAP.MCG_CTL_P              equ (         1 shl  8 ) ;
 msr.MCG_CAP.9                      equ (         1 shl  9 ) ; MCG_EXT_P: Extended machine check state registers are present if this bit is set.
 msr.MCG_CAP.MCG_EXT_P              equ (         1 shl  9 ) ;
 msr.MCG_CAP.10                     equ (         1 shl 10 ) ; MCP_CMCI_P: Support for corrected MC error event is present.
 msr.MCG_CAP.MCP_CMCI_P             equ (         1 shl 10 ) ; 
 msr.MCG_CAP.11                     equ (         1 shl 11 ) ; MCG_TES_P: Threshold-based error status register are present if this bit is set.
 msr.MCG_CAP.MCG_TES_P              equ (         1 shl 11 ) ; 
 msr.MCG_CAP.12_15                  equ (    1111_B shl 12 ) ; Reserved
 msr.MCG_CAP.16_23                  equ (11111111_B shl 16 ) ; MCG_EXT_CNT: Number of extended machine check state registers present.
 msr.MCG_CAP.MCG_EXT_CNT            equ (11111111_B shl 16 ) ; 
 msr.MCG_CAP.24                     equ (         1 shl 24 ) ; MCG_SER_P: The processor supports software error recovery if this bit is set.
 msr.MCG_CAP.MCG_SER_P              equ (         1 shl 24 ) ; 
 msr.MCG_CAP.25                     equ (         1 shl 25 ) ; Reserved
 msr.MCG_CAP.26                     equ (         1 shl 26 ) ; MCG_ELOG_P: Indicates that the processor allows platform firmware to be invoked when an error is detected so that it may provide additional platform specific information in an ACPI format “Generic Error Data Entry” that augments the data included in machine check bank registers.
 msr.MCG_CAP.MCG_ELOG_P             equ (         1 shl 26 ) ; 
 msr.MCG_CAP.27                     equ (         1 shl 27 ) ; MCG_LMCE_P: Indicates that the processor supports extended state in IA32_MCG_STATUS and associated MSR necessary to configure Local Machine Check Exception (LMCE).
 msr.MCG_CAP.MCG_LMCE_P             equ (         1 shl 27 ) ; 
 msr.MCG_CAP.28_63                  equ (         1 shl 28 ) ; Reserved

IA32_MCG_STATUS                     equ 17A_H ; 378
 msr.MCG_STATUS                     equ 17A_H ; 378
 msr.MCG_STATUS.0                   equ (         1        ) ; RIPV. Restart IP valid.
 msr.MCG_STATUS.RIPV                equ (         1        ) ;
 msr.MCG_STATUS.1                   equ (         1 shl  1 ) ; EIPV. Error IP valid.
 msr.MCG_STATUS.EIPV                equ (         1 shl  1 ) ; 
 msr.MCG_STATUS.2                   equ (         1 shl  2 ) ; MCIP. Machine check in progress.
 msr.MCG_STATUS.MCIP                equ (         1 shl  2 ) ; 
 msr.MCG_STATUS.3                   equ (         1 shl  3 ) ; LMCE_S
 msr.MCG_STATUS.MCIP                equ (         1 shl  3 ) ; 
 msr.MCG_STATUS.4_63                equ (         1 shl  4 ) ; Reserved

IA32_MCG_CTL                        equ 17B_H ; 379
 msr.MCG_CTL                        equ 17B_H ; 379

IA32_PERFEVTSEL0                    equ 186_H ; 390
 msr.PERFEVTSEL0                    equ 186_H ; 390
 msr.PERFEVTSEL0.0_7                equ (11111111_B        ) ; Event Select: Selects a performance event logic unit.
 msr.PERFEVTSEL0.EventSelect        equ (11111111_B        ) ; 
 msr.PERFEVTSEL0.8_15               equ (11111111_B shl  8 ) ; UMask: Qualifies the microarchitectural condition to detect on the selected event logic.
 msr.PERFEVTSEL0.UMask              equ (11111111_B shl  8 ) ;
 msr.PERFEVTSEL0.16                 equ (         1 shl 16 ) ; USR: Counts while in privilege level is not ring 0.
 msr.PERFEVTSEL0.USR                equ (         1 shl 16 ) ;
 msr.PERFEVTSEL0.17                 equ (         1 shl 17 ) ; OS: Counts while in privilege level is ring 0.
 msr.PERFEVTSEL0.OS                 equ (         1 shl 17 ) ;
 msr.PERFEVTSEL0.18                 equ (         1 shl 18 ) ; Edge: Enables edge detection if set.
 msr.PERFEVTSEL0.Edge               equ (         1 shl 18 ) ; 
 msr.PERFEVTSEL0.19                 equ (         1 shl 19 ) ; PC: Enables pin control.
 msr.PERFEVTSEL0.PC                 equ (         1 shl 19 ) ; 
 msr.PERFEVTSEL0.20                 equ (         1 shl 20 ) ; INT: Enables interrupt on counter overflow.
 msr.PERFEVTSEL0.INT                equ (         1 shl 20 ) ;
 msr.PERFEVTSEL0.21                 equ (         1 shl 21 ) ; AnyThread: When set to 1, it enables counting the associated event conditions occurring across all logical processors sharing a processor core. When set to 0, the counter only increments the associated event conditions occurring in the logical processor which programmed the msr.
 msr.PERFEVTSEL0.AnyThread          equ (         1 shl 21 ) ;
 msr.PERFEVTSEL0.22                 equ (         1 shl 22 ) ; EN: Enables the corresponding performance counter to commence counting when this bit is set.
 msr.PERFEVTSEL0.EN                 equ (         1 shl 22 ) ; 
 msr.PERFEVTSEL0.23                 equ (         1 shl 23 ) ; INV: Invert the CMASK.
 msr.PERFEVTSEL0.INV                equ (         1 shl 23 ) ; 
 msr.PERFEVTSEL0.24_31              equ (11111111_B shl 24 ) ; CMASK: When CMASK is not zero, the corresponding performance counter increments each cycle if the event count is greater than or equal to the CMASK.
 msr.PERFEVTSEL0.CMASK              equ (11111111_B shl 24 ) ;
 msr.PERFEVTSEL0.32_63              equ (         1 shl 32 ) ; Reserved.

IA32_PERF_STATUS                    equ 198_H ; 408
 msr.PERF_STATUS                    equ 198_H ; 408
 msr.PERF_STATUS.0_15               equ (11111111_11111111_B ) ; Current performance State Value.
 msr.PERF_STATUS.13_63              equ (         1 shl 16   ) ; Reserved

IA32_PERF_CTL                       equ 199_H ; 409
 msr.PERF_CTL                       equ 199_H ; 409
 msr.PERF_CTL.0_15                  equ (11111111_11111111_B        ) ; Target performance State Value.
 msr.PERF_CTL.16_31                 equ (11111111_11111111_B shl 16 ) ; Reserved.
 msr.PERF_CTL.32                    equ (         1 shl 32 ) ; IDA Engage (R/W)
 msr.PERF_CTL.33_63                 equ (         1 shl 33 ) ; Reserved

IA32_CLOCK_MODULATION               equ 19A_H ; 410
 msr.CLOCK_MODULATION               equ 19A_H ; 410
 msr.CLOCK_MODULATION.0             equ (         1        ) ; Extended On-Demand Clock Modulation Duty Cycle.
 msr.CLOCK_MODULATION.1_3           equ (     111_B shl  1 ) ; On-Demand Clock Modulation Duty Cycle:
 msr.CLOCK_MODULATION.4             equ (         1 shl  4 ) ; On-Demand Clock Modulation Enable
 msr.CLOCK_MODULATION.5_63          equ (         1 shl  5 ) ; Reserved

IA32_THERM_INTERRUPT                equ 19B_H ; 411
 msr.THERM_INTERRUPT                equ 19B_H ; 411
 msr.THERM_INTERRUPT.0              equ (         1        ) ; High-Temperature Interrupt Enable
 msr.THERM_INTERRUPT.1              equ (         1 shl  1 ) ; Low-Temperature Interrupt Enable
 msr.THERM_INTERRUPT.2              equ (         1 shl  2 ) ; PROCHOT# Interrupt Enable
 msr.THERM_INTERRUPT.3              equ (         1 shl  3 ) ; FORCEPR# Interrupt Enable
 msr.THERM_INTERRUPT.4              equ (         1 shl  4 ) ; Critical Temperature Interrupt Enable
 msr.THERM_INTERRUPT.5_7            equ (     111_B shl  5 ) ; Reserved
 msr.THERM_INTERRUPT.8_14           equ ( 1111111_B shl  8 ) ; Threshold #1 Value
 msr.THERM_INTERRUPT.15             equ (         1 shl 15 ) ; Threshold #1 Interrupt Enable
 msr.THERM_INTERRUPT.16_22          equ ( 1111111_B shl 15 ) ; Threshold #2 Value
 msr.THERM_INTERRUPT.23             equ (         1 shl 23 ) ; Threshold #2 Interrupt Enable
 msr.THERM_INTERRUPT.24             equ (         1 shl 24 ) ; Power Limit Notification Enable
 msr.THERM_INTERRUPT.25_63          equ (         1 shl 25 ) ; Reserved

IA32_THERM_STATUS                   equ 19C_H ; 412
 msr.THERM_STATUS                   equ 19C_H ; 412
 msr.THERM_STATUS.0                 equ (         1        ) ; Thermal Status (RO)
 msr.THERM_STATUS.1                 equ (         1 shl  1 ) ; Thermal Status Log (R/W)
 msr.THERM_STATUS.2                 equ (         1 shl  2 ) ; PROCHOT # or FORCEPR# event (RO)
 msr.THERM_STATUS.3                 equ (         1 shl  3 ) ; PROCHOT # or FORCEPR# log (R/WC0)
 msr.THERM_STATUS.4                 equ (         1 shl  4 ) ; Critical Temperature Status (RO)
 msr.THERM_STATUS.5                 equ (         1 shl  5 ) ; Critical Temperature Status log (R/WC0)
 msr.THERM_STATUS.6                 equ (         1 shl  6 ) ; Thermal Threshold #1 Status (RO)
 msr.THERM_STATUS.7                 equ (         1 shl  7 ) ; Thermal Threshold #1 log (R/WC0)
 msr.THERM_STATUS.8                 equ (         1 shl  8 ) ; Thermal Threshold #2 Status (RO)
 msr.THERM_STATUS.9                 equ (         1 shl  9 ) ; Thermal Threshold #2 log (R/WC0)
 msr.THERM_STATUS.10                equ (         1 shl 10 ) ; Power Limitation Status (RO)
 msr.THERM_STATUS.11                equ (         1 shl 11 ) ; Power Limitation log (R/WC0)
 msr.THERM_STATUS.12                equ (         1 shl 12 ) ; Current Limit Status (RO)
 msr.THERM_STATUS.13                equ (         1 shl 13 ) ; Current Limit log (R/WC0)
 msr.THERM_STATUS.14                equ (         1 shl 14 ) ; Cross Domain Limit Status (RO)
 msr.THERM_STATUS.15                equ (         1 shl 15 ) ; Cross Domain Limit log (R/WC0)
 msr.THERM_STATUS.16_22             equ ( 1111111_B shl 16 ) ; Digital Readout (RO)
 msr.THERM_STATUS.23_26             equ (    1111_B shl 23 ) ; Reserved
 msr.THERM_STATUS.27_30             equ (    1111_B shl 27 ) ; Resolution in Degrees Celsius (RO)
 msr.THERM_STATUS.31                equ (         1 shl 31 ) ; Reading Valid (RO)
 msr.THERM_STATUS.32_63             equ (         1 shl 32 ) ; Reserved

IA32_MISC_ENABLE                    equ 1A0_H ; 416
 msr.MISC_ENABLE                    equ 1A0_H ; 416
 msr.MISC_ENABLE.0                  equ (         1        ) ; Fast-Strings Enable
 msr.MISC_ENABLE.1_2                equ (      11_B shl  1 ) ; Reserved
 msr.MISC_ENABLE.3                  equ (         3 shl  1 ) ; Automatic Thermal Control Circuit Enable (R/W)
 msr.MISC_ENABLE.4_6                equ (     111_B shl  4 ) ; Reserved
 msr.MISC_ENABLE.7                  equ (         1 shl  7 ) ; Performance Monitoring Available (R)
 msr.MISC_ENABLE.8_10               equ (     111_B shl  8 ) ; Reserved
 msr.MISC_ENABLE.11                 equ (         1 shl 11 ) ; Branch Trace Storage Unavailable (RO)
 msr.MISC_ENABLE.12                 equ (         1 shl 12 ) ; Processor Event Based Sampling (PEBS) Unavailable (RO)
 msr.MISC_ENABLE.13_15              equ (     111_B shl 13 ) ; Reserved
 msr.MISC_ENABLE.16                 equ (         1 shl 16 ) ; Enhanced Intel SpeedStep Technology Enable (R/W)
 msr.MISC_ENABLE.17                 equ (         1 shl 17 ) ; Reserved
 msr.MISC_ENABLE.18                 equ (         1 shl 18 ) ; ENABLE MONITOR FSM (R/W)
 msr.MISC_ENABLE.19_21              equ (     111_B shl 19 ) ; Reserved
 msr.MISC_ENABLE.22                 equ (         1 shl 22 ) ; Limit CPUID Maxval (R/W)
 msr.MISC_ENABLE.23                 equ (         1 shl 23 ) ; xTPR Message Disable (R/W)
 msr.MISC_ENABLE.24_33              equ ( 11111111_11_B shl 24 ) ; Reserved
 msr.MISC_ENABLE.34                 equ (         1 shl 34 ) ; XD Bit Disable (R/W)
 msr.MISC_ENABLE.35_63              equ (         1 shl 35 ) ; Reserved

IA32_ENERGY_PERF_BIAS               equ 1B0_H ; 432
 msr.ENERGY_PERF_BIAS               equ 1B0_H ; 432
 msr.ENERGY_PERF_BIAS.0_3           equ (    1111_B       ) ; Power Policy Preference
 msr.ENERGY_PERF_BIAS.4_63          equ (         1 shl 4 ) ; Reserved

IA32_PACKAGE_THERM_STATUS           equ 1B1_H ; 433
 msr.PACKAGE_THERM_STATUS           equ 1B1_H ; 433
 msr.PACKAGE_THERM_STATUS.0         equ (         1        ) ; Pkg Thermal Status (RO)
 msr.PACKAGE_THERM_STATUS.1         equ (         1 shl  1 ) ; Pkg Thermal Status Log (R/W)
 msr.PACKAGE_THERM_STATUS.2         equ (         1 shl  2 ) ; Pkg PROCHOT # event (RO)
 msr.PACKAGE_THERM_STATUS.3         equ (         1 shl  3 ) ; Pkg PROCHOT # log (R/WC0)
 msr.PACKAGE_THERM_STATUS.4         equ (         1 shl  4 ) ; Pkg Critical Temperature Status (RO)
 msr.PACKAGE_THERM_STATUS.5         equ (         1 shl  5 ) ; Pkg Critical Temperature Status Log (R/WC0)
 msr.PACKAGE_THERM_STATUS.6         equ (         1 shl  6 ) ; Pkg Thermal Threshold #1 Status (RO)
 msr.PACKAGE_THERM_STATUS.7         equ (         1 shl  7 ) ; Pkg Thermal Threshold #1 log (R/WC0)
 msr.PACKAGE_THERM_STATUS.8         equ (         1 shl  8 ) ; Pkg Thermal Threshold #2 Status (RO)
 msr.PACKAGE_THERM_STATUS.9         equ (         1 shl  9 ) ; Pkg Thermal Threshold #1 log (R/WC0)
 msr.PACKAGE_THERM_STATUS.10        equ (         1 shl 10 ) ; Pkg Power Limitation Status (RO)
 msr.PACKAGE_THERM_STATUS.11        equ (         1 shl 11 ) ; Pkg Power Limitation log (R/WC0)
 msr.PACKAGE_THERM_STATUS.12_15     equ (    1111_B shl 12 ) ; Reserved
 msr.PACKAGE_THERM_STATUS.16_22     equ ( 1111111_B shl 16 ) ; Pkg Digital Readout (RO)
 msr.PACKAGE_THERM_STATUS.23_63     equ (         1 shl 23 ) ; Reserved

IA32_PACKAGE_THERM_INTERRUPT        equ 1B2_H ; 434
 msr.PACKAGE_THERM_INTERRUPT        equ 1B2_H ; 434
 msr.PACKAGE_THERM_INTERRUPT.0      equ (         1        ) ; Pkg High-Temperature Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.1      equ (         1 shl  1 ) ; Pkg Low-Temperature Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.2      equ (         1 shl  2 ) ; Pkg PROCHOT# Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.3      equ (         1 shl  3 ) ; Reserved
 msr.PACKAGE_THERM_INTERRUPT.4      equ (         1 shl  4 ) ; Pkg Overheat Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.5_7    equ (     111_B shl  5 ) ; Reserved
 msr.PACKAGE_THERM_INTERRUPT.8_14   equ ( 1111111_B shl 14 ) ; Pkg Threshold #1 Value
 msr.PACKAGE_THERM_INTERRUPT.15     equ (         1 shl 15 ) ; Pkg Threshold #1 Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.22_16  equ ( 1111111_B shl 15 ) ; Pkg Threshold #2 Value
 msr.PACKAGE_THERM_INTERRUPT.23     equ (         1 shl 23 ) ; Pkg Threshold #2 Interrupt Enable
 msr.PACKAGE_THERM_INTERRUPT.25_63  equ (         1 shl 25 ) ; Reserved

IA32_DEBUGCTL                       equ 1D9_H ; 473
 msr.DEBUGCTL                       equ 1D9_H ; 473
 msr.DEBUGCTL.0                     equ (         1        ) ; LBR: Setting this bit to 1 enables the processor to record a running trace of the most recent branches taken by the processor in the LBR stack.
 msr.DEBUGCTL.LBR                   equ (         1        ) ; LBR: Setting this bit to 1 enables the processor to record a running trace of the most recent branches taken by the processor in the LBR stack.
 msr.DEBUGCTL.1                     equ (         1 shl  1 ) ; BTF: Setting this bit to 1 enables the processor to treat EFLAGS.TF as single-step on branches instead of single-step on instructions.
 msr.DEBUGCTL.BTF                   equ (         1 shl  1 ) ; BTF: Setting this bit to 1 enables the processor to treat EFLAGS.TF as single-step on branches instead of single-step on instructions.
 msr.DEBUGCTL.2_5                   equ (    1111_B shl  2 ) ; Reserved
 msr.DEBUGCTL.6                     equ (         1 shl  6 ) ; TR: Setting this bit to 1 enables branch trace messages to be sent.
 msr.DEBUGCTL.TR                    equ (         1 shl  6 ) ; TR: Setting this bit to 1 enables branch trace messages to be sent.
 msr.DEBUGCTL.7                     equ (         1 shl  7 ) ; BTS: Setting this bit enables branch trace messages (BTMs) to be logged in a BTS b ffer.
 msr.DEBUGCTL.BTS                   equ (         1 shl  7 ) ; BTS: Setting this bit enables branch trace messages (BTMs) to be logged in a BTS b ffer.
 msr.DEBUGCTL.8                     equ (         1 shl  8 ) ; BTINT: When clear, BTMs are logged in a BTS buffer in circular fashion. When this bit is set, an interrupt is generated by the BTS facility when the BTS buffer is full.
 msr.DEBUGCTL.BTINT                 equ (         1 shl  8 ) ; BTINT: When clear, BTMs are logged in a BTS buffer in circular fashion. When this bit is set, an interrupt is generated by the BTS facility when the BTS buffer is full.
 msr.DEBUGCTL.9                     equ (         1 shl  9 ) ; 1: BTS_OFF_OS: When set, BTS or BTM is skipped if CPL = 0.
 msr.DEBUGCTL.BTS_OFF_OS            equ (         1 shl  9 ) ; 1: BTS_OFF_OS: When set, BTS or BTM is skipped if CPL = 0.
 msr.DEBUGCTL.10                    equ (         1 shl 10 ) ; BTS_OFF_USR: When set, BTS or BTM is skipped if CPL > 0.
 msr.DEBUGCTL.BTS_OFF_USR           equ (         1 shl 10 ) ; BTS_OFF_USR: When set, BTS or BTM is skipped if CPL > 0.
 msr.DEBUGCTL.11                    equ (         1 shl 11 ) ; FREEZE_LBRS_ON_PMI: When set, the LBR stack is frozen on a PMI request.
 msr.DEBUGCTL.FREEZE_LBRS_ON_PMI    equ (         1 shl 11 ) ; FREEZE_LBRS_ON_PMI: When set, the LBR stack is frozen on a PMI request.
 msr.DEBUGCTL.12                    equ (         1 shl 12 ) ; FREEZE_PERFMON_ON_PMI: When set, each ENABLE bit of the global counter control MSR are frozen (address 38FH) on a PMI request.
 msr.DEBUGCTL.FREEZE_PERFMON_ON_PMI equ (        1 shl 12 ) ; FREEZE_PERFMON_ON_PMI: When set, each ENABLE bit of the global counter control MSR are frozen (address 38FH) on a PMI request.
 msr.DEBUGCTL.13                    equ (         1 shl 13 ) ; ENABLE_UNCORE_PMI: When set, enables the logical processor to receive and generate PMI on behalf of the uncore.
 msr.DEBUGCTL.ENABLE_UNCORE_PMI     equ (         1 shl 13 ) ; ENABLE_UNCORE_PMI: When set, enables the logical processor to receive and generate PMI on behalf of the uncore.
 msr.DEBUGCTL.14                    equ (         1 shl 14 ) ; FREEZE_WHILE_SMM: When set, freezes perfmon and trace messages while in SMM.
 msr.DEBUGCTL.FREEZE_WHILE_SMM      equ (         1 shl 14 ) ; FREEZE_WHILE_SMM: When set, freezes perfmon and trace messages while in SMM.
 msr.DEBUGCTL.15                    equ (         1 shl 15 ) ; RTM_DEBUG: When set, enables DR7 debug bit on XBEGIN.
 msr.DEBUGCTL.RTM_DEBUG             equ (         1 shl 15 ) ; RTM_DEBUG: When set, enables DR7 debug bit on XBEGIN.
 msr.DEBUGCTL.16_63                 equ (         1 shl 16 ) ; Reserved.

IA32_SMRR_PHYSBASE                  equ 1F2_H ; 498 ; SMRR Range Mask (Writeable only in SMM) Range Mask of SMM memory range.
 msr.SMRR_PHYSBASE                  equ 1F2_H ; 498
 msr.SMRR_PHYSBASE.0_7              equ (11111111_B        ) ; Type. Specifies memory type of the range.
 msr.SMRR_PHYSBASE.8_11             equ (    1111_B shl  8 ) ; Reserved
 msr.SMRR_PHYSBASE.12_31            equ (11111111_11111111_11111_B shl 12 ) ; PhysMask SMRR address range mask.
 msr.SMRR_PHYSBASE.32_63            equ (         1 shl 32 ) ; Reserved

IA32_PLATFORM_DCA_CAP               equ 1F8_H ; 504 ; DCA Capability (R)
 msr.PLATFORM_DCA_CAP               equ 1F8_H ; 504

IA32_CPU_DCA_CAP                    equ 1F9_H ; 505 ; If set, CPU supports Prefetch-Hint type.
 msr.CPU_DCA_CAP                    equ 1F9_H ; 505

IA32_DCA_0_CAP                      equ 1FA_H ; 506 ; DCA type 0 Status and Control register.
 msr.DCA_0_CAP                      equ 1FA_H ; 506
 msr.DCA_0_CAP.0                    equ (         1        ) ; DCA_ACTIVE: Set by HW when DCA is fuse- enabled and no defeatures are set.
 msr.DCA_0_CAP.DCA_ACTIVE           equ (         1        ) ; DCA_ACTIVE: Set by HW when DCA is fuse- enabled and no defeatures are set.
 msr.DCA_0_CAP.1_2                  equ (      11_B shl  1 ) ; TRANSACTION
 msr.DCA_0_CAP.TRANSACTION          equ (      11_B shl  1 ) ; TRANSACTION
 msr.DCA_0_CAP.3_6                  equ (    1111_B shl  3 ) ; DCA_TYPE
 msr.DCA_0_CAP.DCA_TYPE             equ (    1111_B shl  3 ) ; DCA_TYPE
 msr.DCA_0_CAP.7_10                 equ (    1111_B shl  7 ) ; DCA_QUEUE_SIZE
 msr.DCA_0_CAP.DCA_QUEUE_SIZE       equ (    1111_B shl  7 ) ; DCA_QUEUE_SIZE
 msr.DCA_0_CAP.11_12                equ (      11_B shl 11 ) ; Reserved
 msr.DCA_0_CAP.13_16                equ (    1111_B shl 13 ) ; DCA_DELAY: Writes will update the register but have no HW side-effect.
 msr.DCA_0_CAP.DCA_DELAY            equ (    1111_B shl 13 ) ; DCA_DELAY: Writes will update the register but have no HW side-effect.
 msr.DCA_0_CAP.17_23                equ ( 1111111_B shl 17 ) ; Reserved
 msr.DCA_0_CAP.24                   equ (         1 shl 24 ) ; SW_BLOCK: SW can request DCA block by setting this bit.
 msr.DCA_0_CAP.SW_BLOCK             equ (         1 shl 24 ) ; SW_BLOCK: SW can request DCA block by setting this bit.
 msr.DCA_0_CAP.25                   equ (         1 shl 25 ) ; Reserved
 msr.DCA_0_CAP.26                   equ (         1 shl 26 ) ; HW_BLOCK: Set when DCA is blocked by HW (e.g. CR0.CD = 1).
 msr.DCA_0_CAP.HW_BLOCK             equ (         1 shl 26 ) ; HW_BLOCK: Set when DCA is blocked by HW (e.g. CR0.CD = 1).
 msr.DCA_0_CAP.27_31                equ (         1 shl 27 ) ; Reserved

IA32_MTRR_PHYSBASE0                 equ 200_H ; 512
 msr.MTRR_PHYSBASE0                 equ 200_H ; 512

IA32_MTRR_PHYSMASK0                 equ 201_H ; 513
 msr.MTRR_PHYSMASK0                 equ 201_H ; 513

IA32_MTRR_PHYSBASE1                 equ 202_H ; 514
 msr.MTRR_PHYSBASE1                 equ 202_H ; 514

IA32_MTRR_PHYSMASK1                 equ 203_H ; 515
 msr.MTRR_PHYSMASK1                 equ 203_H ; 515

IA32_MTRR_PHYSBASE2                 equ 204_H ; 516
 msr.MTRR_PHYSBASE2                 equ 204_H ; 516

IA32_MTRR_PHYSMASK2                 equ 205_H ; 517
 msr.MTRR_PHYSMASK2                 equ 205_H ; 517

IA32_MTRR_PHYSBASE3                 equ 206_H ; 518
 msr.MTRR_PHYSBASE3                 equ 206_H ; 518

IA32_MTRR_PHYSMASK3                 equ 207_H ; 519
 msr.MTRR_PHYSMASK3                 equ 207_H ; 519

IA32_MTRR_PHYSBASE4                 equ 208_H ; 520
 msr.MTRR_PHYSBASE4                 equ 208_H ; 520

IA32_MTRR_PHYSMASK4                 equ 209_H ; 521
 msr.MTRR_PHYSMASK4                 equ 209_H ; 521

IA32_MTRR_PHYSBASE5                 equ 20A_H ; 522
 msr.MTRR_PHYSBASE5                 equ 20A_H ; 522

IA32_MTRR_PHYSMASK5                 equ 20B_H ; 523
 msr.MTRR_PHYSMASK5                 equ 20B_H ; 523

IA32_MTRR_PHYSBASE6                 equ 20C_H ; 524
 msr.MTRR_PHYSBASE6                 equ 20C_H ; 524

IA32_MTRR_PHYSMASK6                 equ 20D_H ; 525
 msr.MTRR_PHYSMASK6                 equ 20D_H ; 525

IA32_MTRR_PHYSBASE7                 equ 20E_H ; 526
 msr.MTRR_PHYSBASE7                 equ 20E_H ; 526

IA32_MTRR_PHYSMASK7                 equ 20F_H ; 527
 msr.MTRR_PHYSMASK7                 equ 20F_H ; 527

IA32_MTRR_PHYSBASE8                 equ 210_H ; 528
 msr.MTRR_PHYSBASE8                 equ 210_H ; 528

IA32_MTRR_PHYSMASK8                 equ 211_H ; 529
 msr.MTRR_PHYSMASK8                 equ 211_H ; 529

IA32_MTRR_PHYSBASE9                 equ 212_H ; 530
 msr.MTRR_PHYSBASE9                 equ 212_H ; 530

IA32_MTRR_PHYSMASK9                 equ 213_H ; 531
 msr.MTRR_PHYSMASK9                 equ 213_H ; 531

IA32_MTRR_FIX64K_00000              equ 250_H ; 592
 msr.MTRR_FIX64K_00000              equ 250_H ; 592

IA32_MTRR_FIX16K_80000              equ 258_H ; 600
 msr.MTRR_FIX16K_80000              equ 258_H ; 600

IA32_MTRR_FIX16K_A0000              equ 259_H ; 601
 msr.MTRR_FIX16K_A0000              equ 259_H ; 601

IA32_MTRR_FIX4K_C0000               equ 268_H ; 616
 msr.MTRR_FIX4K_C0000               equ 268_H ; 616

IA32_MTRR_FIX4K_C8000               equ 269_H ; 617
 msr.MTRR_FIX4K_C8000               equ 269_H ; 617

IA32_MTRR_FIX4K_D0000               equ 26A_H ; 618
 msr.MTRR_FIX4K_D0000               equ 26A_H ; 618

IA32_MTRR_FIX4K_D8000               equ 26B_H ; 619
 msr.MTRR_FIX4K_D8000               equ 26B_H ; 619

IA32_MTRR_FIX4K_E0000               equ 26C_H ; 620
 msr.MTRR_FIX4K_E0000               equ 26C_H ; 620

IA32_MTRR_FIX4K_E8000               equ 26D_H ; 621
 msr.MTRR_FIX4K_E8000               equ 26D_H ; 621

IA32_MTRR_FIX4K_F0000               equ 26E_H ; 622
 msr.MTRR_FIX4K_F0000               equ 26E_H ; 622

IA32_MTRR_FIX4K_F8000               equ 26F_H ; 623
 msr.MTRR_FIX4K_F8000               equ 26F_H ; 623

IA32_PAT                            equ 277_H ; 631
 msr.PAT                            equ 277_H ; 631
 msr.PAT.0_2                        equ (     111_B        ) ; PA0
 msr.PAT.PA0                        equ (     111_B        ) ; PA0
 msr.PAT.7_3                        equ (   11111_B shl  3 ) ; Reserved
 msr.PAT.8_10                       equ (     111_B shl  8 ) ; PA1
 msr.PAT.PA1                        equ (     111_B shl  8 ) ; PA1
 msr.PAT.11_15                      equ (   11111_B shl 11 ) ; Reserved
 msr.PAT.16_18                      equ (     111_B shl 16 ) ; PA2
 msr.PAT.PA2                        equ (     111_B shl 16 ) ; PA2
 msr.PAT.19_23                      equ (   11111_B shl 19 ) ; Reserved
 msr.PAT.24_26                      equ (     111_B shl 24 ) ; PA3
 msr.PAT.PA3                        equ (     111_B shl 24 ) ; PA3
 msr.PAT.27_31                      equ (   11111_B shl 27 ) ; Reserved
 msr.PAT.32_34                      equ (     111_B shl 32 ) ; PA4
 msr.PAT.PA4                        equ (     111_B shl 32 ) ; PA4
 msr.PAT.35_39                      equ (   11111_B shl 35 ) ; Reserved
 msr.PAT.40_42                      equ (     111_B shl 40 ) ; PA5
 msr.PAT.PA5                        equ (     111_B shl 40 ) ; PA5
 msr.PAT.43_47                      equ (   11111_B shl 43 ) ; Reserved
 msr.PAT.48_50                      equ (     111_B shl 48 ) ; PA6
 msr.PAT.PA6                        equ (     111_B shl 48 ) ; PA6
 msr.PAT.51_55                      equ (   11111_B shl 51 ) ; Reserved
 msr.PAT.56_58                      equ (     111_B shl 56 ) ; PA7
 msr.PAT.PA7                        equ (     111_B shl 56 ) ; PA7
 msr.PAT.59_63                      equ (   11111_B shl 59 ) ; Reserved

IA32_MC0_CTL2                       equ 280_H ; 640
 msr.MC0_CTL2                       equ 280_H ; 640
 msr.MC0_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC0_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC0_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC0_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC0_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC1_CTL2                       equ 281_H ; 641
 msr.MC1_CTL2                       equ 281_H ; 641
 msr.MC1_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC1_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC1_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC1_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC1_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC2_CTL2                       equ 282_H ; 642
 msr.MC2_CTL2                       equ 282_H ; 642
 msr.MC2_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC2_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC2_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC2_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC2_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC3_CTL2                       equ 283_H ; 643
 msr.MC3_CTL2                       equ 283_H ; 643
 msr.MC3_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC3_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC3_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC3_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC3_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC4_CTL2                       equ 284_H ; 644
 msr.MC4_CTL2                       equ 284_H ; 644
 msr.MC4_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC4_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC4_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC4_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC4_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC5_CTL2                       equ 285_H ; 645
 msr.MC5_CTL2                       equ 285_H ; 645
 msr.MC5_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC5_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC5_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC5_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC5_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC6_CTL2                       equ 286_H ; 646
 msr.MC6_CTL2                       equ 286_H ; 646
 msr.MC6_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC6_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC6_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC6_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC6_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC7_CTL2                       equ 287_H ; 647
 msr.MC7_CTL2                       equ 287_H ; 647
 msr.MC7_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC7_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC7_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC7_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC7_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC8_CTL2                       equ 288_H ; 648
 msr.MC8_CTL2                       equ 288_H ; 648
 msr.MC8_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC8_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC8_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC8_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC8_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC9_CTL2                       equ 289_H ; 649
 msr.MC9_CTL2                       equ 289_H ; 649
 msr.MC9_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC9_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC9_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC9_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC9_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC10_CTL2                       equ 28A_H ; 650
 msr.MC10_CTL2                       equ 28A_H ; 650
 msr.MC10_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC10_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC10_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC10_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC10_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC11_CTL2                       equ 28B_H ; 651
 msr.MC11_CTL2                       equ 28B_H ; 651
 msr.MC11_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC11_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC11_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC11_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC11_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC12_CTL2                       equ 28C_H ; 652
 msr.MC12_CTL2                       equ 28C_H ; 652
 msr.MC12_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC12_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC12_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC12_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC12_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC13_CTL2                       equ 28D_H ; 653
 msr.MC13_CTL2                       equ 28D_H ; 653
 msr.MC13_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC13_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC13_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC13_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC13_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC14_CTL2                       equ 28E_H ; 654
 msr.MC14_CTL2                       equ 28E_H ; 654
 msr.MC14_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC14_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC14_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC14_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC14_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC15_CTL2                       equ 28F_H ; 655
 msr.MC15_CTL2                       equ 28F_H ; 655
 msr.MC15_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC15_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC15_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC15_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC15_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC16_CTL2                       equ 290_H ; 656
 msr.MC16_CTL2                       equ 290_H ; 656
 msr.MC16_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC16_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC16_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC16_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC16_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC17_CTL2                       equ 291_H ; 657
 msr.MC17_CTL2                       equ 291_H ; 657
 msr.MC17_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC17_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC17_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC17_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC17_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC18_CTL2                       equ 292_H ; 658
 msr.MC18_CTL2                       equ 292_H ; 658
 msr.MC18_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC18_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC18_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC18_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC18_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC19_CTL2                       equ 293_H ; 659
 msr.MC19_CTL2                       equ 293_H ; 659
 msr.MC19_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC19_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC19_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC19_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC19_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC20_CTL2                       equ 294_H ; 660
 msr.MC20_CTL2                       equ 294_H ; 660
 msr.MC20_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC20_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC20_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC20_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC20_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC21_CTL2                       equ 295_H ; 661
 msr.MC21_CTL2                       equ 295_H ; 661
 msr.MC21_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC21_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC21_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC21_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC21_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC22_CTL2                       equ 296_H ; 662
 msr.MC22_CTL2                       equ 296_H ; 662
 msr.MC22_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC22_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC22_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC22_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC22_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC23_CTL2                       equ 297_H ; 663
 msr.MC23_CTL2                       equ 297_H ; 663
 msr.MC23_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC23_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC23_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC23_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC23_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC24_CTL2                       equ 298_H ; 664
 msr.MC24_CTL2                       equ 298_H ; 664
 msr.MC24_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC24_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC24_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC24_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC24_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC25_CTL2                       equ 299_H ; 665
 msr.MC25_CTL2                       equ 299_H ; 665
 msr.MC25_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC25_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC25_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC25_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC25_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC26_CTL2                       equ 29A_H ; 666
 msr.MC26_CTL2                       equ 29A_H ; 666
 msr.MC26_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC26_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC26_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC26_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC26_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC27_CTL2                       equ 29B_H ; 667
 msr.MC27_CTL2                       equ 29B_H ; 667
 msr.MC27_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC27_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC27_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC27_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC27_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC28_CTL2                       equ 29C_H ; 668
 msr.MC28_CTL2                       equ 29C_H ; 668
 msr.MC28_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC28_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC28_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC28_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC28_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC29_CTL2                       equ 29D_H ; 669
 msr.MC29_CTL2                       equ 29D_H ; 669
 msr.MC29_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC29_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC29_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC29_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC29_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC30_CTL2                       equ 29E_H ; 670
 msr.MC30_CTL2                       equ 29E_H ; 670
 msr.MC30_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC30_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC30_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC30_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC30_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MC31_CTL2                       equ 29F_H ; 671
 msr.MC31_CTL2                       equ 29F_H ; 671
 msr.MC31_CTL2.0_14                  equ (111111_11111111_B ) ; Corrected error count threshold.
 msr.MC31_CTL2.15_29                 equ (1111111_11111111_B shl 15 ) ; Reserved
 msr.MC31_CTL2.30                    equ (         1 shl 15 ) ; CMCI_EN
 msr.MC31_CTL2.CMCI_EN               equ (         1 shl 15 ) ; CMCI_EN
 msr.MC31_CTL2.31_63                 equ (         1 shl 31 ) ; Reserved

IA32_MTRR_DEF_TYPE                   equ 2FF_H ; 767
 msr.MTRR_DEF_TYPE                   equ 2FF_H ; 767
 msr.MTRR_DEF_TYPE.0_2               equ (     111_B        ) ; Default Memory Type
 msr.MTRR_DEF_TYPE.3_9               equ ( 1111111_B shl  3 ) ; Reserved
 msr.MTRR_DEF_TYPE.10                equ (         1 shl 10 ) ; Fixed Range MTRR Enable
 msr.MTRR_DEF_TYPE.11                equ (         1 shl 11 ) ; MTRR Enable
 msr.MTRR_DEF_TYPE.12_63             equ (         1 shl 12 ) ; Reserved
  
IA32_FIXED_CTR0                      equ 309_H ; 777 ; Fixed-Function Performance Counter 0 (R/W): Counts Instr_Retired.Any
 msr.FIXED_CTR0                      equ 309_H ; 777
 msr.FIXED_CTR.Instr_Retired.Any     equ 309_H ; 777

IA32_FIXED_CTR1                      equ 30A_H ; 778 ; Fixed-Function Performance Counter 1 (R/W): Counts CPU_CLK_Unhalted.Core.
 msr.FIXED_CTR1                      equ 30A_H ; 778
 msr.FIXED_CTR.CPU_CLK_Unhalted.Core equ 30A_H ; 778

IA32_FIXED_CTR2                      equ 30B_H ; 779 ; Fixed-Function Performance Counter 2 (R/W): Counts CPU_CLK_Unhalted.Ref.
 msr.FIXED_CTR2                      equ 30B_H ; 779
 msr.FIXED_CTR.CPU_CLK_Unhalted.Ref  equ 30B_H ; 779

IA32_PERF_CAPABILITIES               equ 345_H ; 837
 msr.PERF_CAPABILITIES               equ 345_H ; 837
 msr.PERF_CAPABILITIES.0_5           equ (  111111_B        ) ; LBR format
 msr.PERF_CAPABILITIES.LBR_format    equ (  111111_B        ) ; LBR format
 msr.PERF_CAPABILITIES.6             equ (         1 shl  6 ) ; PEBS Trap
 msr.PERF_CAPABILITIES.PEBS_Trap     equ (         1 shl  6 ) ; PEBS Trap
 msr.PERF_CAPABILITIES.7             equ (         1 shl  7 ) ; PEBSSaveArchRegs
 msr.PERF_CAPABILITIES.PEBSSaveArchRegs equ (      1 shl  7 ) ; PEBSSaveArchRegs
 msr.PERF_CAPABILITIES.8_11          equ (    1111_B shl  8 ) ; PEBS Record Format
 msr.PERF_CAPABILITIES.PEBS_Record_Format equ (1111_B shl 8 ) ; PEBS Record Format
 msr.PERF_CAPABILITIES.12            equ (         1 shl 12 ) ; 1: Freeze while SMM is supported.
 msr.PERF_CAPABILITIES.13            equ (         1 shl 13 ) ; 1: Full width of counter writable via IA32_A_PMCx.
 msr.PERF_CAPABILITIES.14            equ (         1 shl 14 ) ; Reserved
 msr.PERF_CAPABILITIES.15            equ (         1 shl 15 ) ; 1: Performance metrics available.
 msr.PERF_CAPABILITIES.16            equ (         1 shl 16 ) ; 1: PEBS output will be written into the Intel PT trace stream.
 msr.PERF_CAPABILITIES.17_63         equ (         1 shl 17 ) ; Reserved

; IA32_FIXED_CTR_CTRL ; p.40


; msr.1BH
msr.1BH.APIC_BASE.11        equ ( 1 shl 11 )
msr.1BH.11                  equ ( 1 shl 11 )
IA32_APIC_BASE.11           equ ( 1 shl 11 )

; optimizations
include 'optimized/msr.bmi2.asm'
