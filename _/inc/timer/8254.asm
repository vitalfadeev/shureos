;
; timer/8254
;
; Programmable Interval Timer (PIT)
;
; Intel 8253/8254
;
; Uses a clock input of 1.19318MHz to decrement a 16-bit counter. 
; An interrupt is generated whenever the counter wraps around after 216 = 65536 increments.
; frequency of 1.19318MHz / 65536 ~= 18.2 Hz.
;
; 3 channel:
;   Channel 0 - connected to the PIC chip, so that it generates an "IRQ 0"
;   Channel 1 - to refresh RAM, but no longer usable
;   Channel 2 - connected to the PC speaker
;
; I/O port     Usage
; 0x40         Channel 0 data port (read/write)
; 0x41         Channel 1 data port (read/write)
; 0x42         Channel 2 data port (read/write)
; 0x43         Mode/Command register (write only, a read is ignored)

;
;Command register format:
;            ---------------------------------
;           |  7 | 6 | 5 | 4 | 3 | 2 | 1 | 0  |
;            ---------------------------------
;              |   |   |   |   |   |   |   |__ Count format (0=binary)
;              |   |   |   |   |___|___|_______ Mode of operation 
;              |   |   |   |                    (3 = 011B = square wave)
;              |   |   |__ |_______ How to access latch (11B = LSB then MSB)
;              |___|_______________ Timer/oscillator channel

; Bits         Usage
; 6 and 7      Select channel :
;                 0 0 = Channel 0
;                 0 1 = Channel 1
;                 1 0 = Channel 2
;                 1 1 = Read-back command (8254 only)
; 4 and 5      Access mode :
;                 0 0 = Latch count value command
;                 0 1 = Access mode: lobyte only
;                 1 0 = Access mode: hibyte only
;                 1 1 = Access mode: lobyte/hibyte
; 1 to 3       Operating mode :
;                 0 0 0 = Mode 0 (interrupt on terminal count)
;                 0 0 1 = Mode 1 (hardware re-triggerable one-shot)
;                 0 1 0 = Mode 2 (rate generator)
;                 0 1 1 = Mode 3 (square wave generator)
;                 1 0 0 = Mode 4 (software triggered strobe)
;                 1 0 1 = Mode 5 (hardware triggered strobe)
;                 1 1 0 = Mode 2 (rate generator, same as 010b)
;                 1 1 1 = Mode 3 (square wave generator, same as 011b)
; 0            BCD/Binary mode: 0 = 16-bit binary, 1 = four-digit BCD

; RTC timer ( 1 Hz                        > 1989 year, Real Time Clock)
; PIT timer ( 3 timers, 1_193_181,8 Hz, 8254. 16 bit. Programmable Interval Timer
;                                         > 1981 year
;   80486           => Intel 420          > 1989 year, 
;   P5              => I430FX 'i82430FX', 
;   P6              => i440, i450         > 1995 year,
;   Pentium M, Core => i800, i900         > 1999 year )
; Local APIC 
; ACPI timer ( 3.579545 MHz, 24/32 bit,   > 1996 year ) (Performance Monitoring Timer (PMTIMER)) (3 timers: PM, GPIO, TCO)
; HPET timer ( > 10 MHz, 32/64 bit,       > 2004 year ) (change old PIT timer)  (до 8 блоков HPET, ) (High Precision Event Timer)
; TSC  timer/ TSC counter ( RDTSC ) ( Read TimeStamp Counter )

; Linux: TSC, HPET, ACPI_PM (current: TDC)

; RDTSC : read TSC
; RDMSR IA32_TIMESTAMP_COUNTER : read TSC
; RDTSCP
 
; 8254 Timer Registers
;   40_h
TIMER.CONTROL   equ 43h ; A1,A0 = 11
TIMER.C0        equ 40h ; A1,A0 = 00, IRQ0
TIMER.C1        equ 41h ; A1,A0 = 01, Memory
TIMER.C2        equ 42h ; A1,A0 = 10, PC Speaker

; Control Word Format
; +-----+-----+-----+-----+-----+-----+-----+-----+
; | D7  | D6  | D5  | D4  | D3  | D2  | D1  | D0  |
; +-----+-----+-----+-----+-----+-----+-----+-----+
; | SC1 | SC0 | RW1 | RW0 | M2  | M1  | M0  | BCD |
; +-----+-----+-----+-----+-----+-----+-----+-----+
; SC0, SC1   - Select counter
; RW0, RW1   - Read / Write
; M0, M1, M2 - Mode
; BCD        - Binary Counter (16-bit) / Binary Coded Decimal (BCD) Counter (4 Decades)

; SC - Select Counter
; SC1 SC0
; 16-bit presettable synchronous down counter
SELECT_COUNTER_0                equ (  00_b shl 6 ) ; Select Counter 0
SELECT_COUNTER_1                equ (  01_b shl 6 ) ; Select Counter 1
SELECT_COUNTER_2                equ (  10_b shl 6 ) ; Select Counter 2
READ_BACK_COMMAND               equ (  11_b shl 6 ) ; Read-Back Command (see Read Operations)

; RW - Read/Write
; RW1 RW0
Counter_Latch_Command           equ (  00_b shl 4 ) ; Counter Latch Command
RW_least_significant_byte_only  equ (  01_b shl 4 ) ; Read/Write least significant byte only
RW_most_significant_byte_only   equ (  10_b shl 4 ) ; Read/Write most significant byte only
RW_least_first_then_most        equ (  11_b shl 4 ) ; Read/Write least significant byte first, then most significant byte

; M - Mode
; M2 M1 M0
Mode_0_INTERRUPT_ON_TERMINAL_COUNT              equ ( 000_b shl 1 ) ; Mode 0. INTERRUPT ON TERMINAL COUNT
Mode_1_HARDWARE_RETRIGGERABLE_ONE_SHOT          equ ( 001_b shl 1 ) ; Mode 1. HARDWARE RETRIGGERABLE ONE-SHOT
Mode_2_RATE_GENERATOR                           equ ( 010_b shl 1 ) ; Mode 2. RATE GENERATOR
Mode_3_SQUARE_WAVE_MODE                         equ ( 011_b shl 1 ) ; Mode 3. SQUARE WAVE MODE
Mode_4_SOFTWARE_TRIGGERED_STROBE                equ ( 100_b shl 1 ) ; Mode 4. SOFTWARE TRIGGERED STROBE
Mode_5_HARDWARE_TRIGGERED_STROBE_RETRIGGERABLE  equ ( 101_b shl 1 ) ; Mode 5. HARDWARE TRIGGERED STROBE (RETRIGGERABLE)
; Mode_6                          equ ( 110_b shl 1 ) ; Mode 6 unused
; Mode_7                          equ ( 111_b shl 1 ) ; Mode 7 unused

; BCD
Binary_Counter                  equ 0 ; Binary Counter 16-bits
Binary_Coded_Decimal_Counter    equ 1 ; Binary Coded Decimal (BCD) Counter (4 Decades)


;
macro timer.beep freq, duration
{
    ;
}

;
macro Timer.sleep msecs
{
    ; 1 ms = 1/1000 Hz
    ; 2 ms = 2 * 1/1000 Hz
    ; 1_193_182     / 1 sec 
    ;     1_193.182 / 1 msec
    ; 1 ms = 1_193.182 timer-ticks
    _SB equ ( 1_193_182 / 1000 * msecs )
    ; LSB equ ( ( _SB and 0x00FF ) )
    ; MSB equ ( ( _SB and 0xFF00 ) shr 8 )

    mov  al, ( \
        SELECT_COUNTER_0 or \
        RW_least_first_then_most or \
        Mode_2_RATE_GENERATOR or \
        Binary_Counter \
    )
    out  TIMER.CONTROL, al

    mov  ax, _SB
    out  TIMER.C0, al
    
    mov  al, ah
    out  TIMER.C0, al
}

; 1 sec
;   1000 ms
;
; IRQ0_ISR:
;   loop_sstart:
;     mov Timer.Long_Counter, 1000
;
;   loop_body:
;     dec Timer.Long_Counter
;     jnz loop_body
;   
;   loop_end:
;     ; emit timer event
;     mov Timer.Long_Counter, 1000
;

;
Timer.Long_Counter: dw 0
