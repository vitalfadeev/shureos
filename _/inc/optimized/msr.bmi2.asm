;
; BMI2 optimized version
;   AVX, VEX opcode prefix
config.target_cpu.has_bmi2 equ 0 ; for Intel Haswell processors and newer

;
if config.target_cpu.has_bmi2

;
macro msr.read_bits  msr_number, bit_start, bit_limit
{
    mov ecx, msr_number
    rdmsr

    if bit_start < 32
        if bit_limit < 32
            pext r8, eax, mask

        else
            ...

        end if

    else
        ...

    end if
}

end if
