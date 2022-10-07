;
; 8259A
;
; 8259
; 8259A

; Single mode
;      +--------------+      +---------------+
; -----|IRQ0 8259     |------|INTR  CPU      |
; -----|IRQ1          |      |               |
; -----|IRQ2          |      |               |
; -----|IRQ3          |      |               |
; -----|IRQ4          |      |               |
; -----|IRQ5          |      |               |
; -----|IRQ6          |      |               |
; -----|IRQ7          |      |               |
;      +--------------+      +---------------+
; 8 IRQs: IRQ0-IRQ8

; Cascade mode
;  8   +--------------+           0   +--------------+      +---------------+
; -----|IRQ0   8259   |------    -----|IRQ0   8259   |------|INTR  CPU      |
; -----|IRQ1   Slave  |     |    -----|IRQ1  Master  |      |               |
; -----|IRQ2          |     ----------|IRQ2          |      |               |
; -----|IRQ3          |          -----|IRQ3          |      |               |
; -----|IRQ4          |          -----|IRQ4          |      |               |
; -----|IRQ5          |          -----|IRQ5          |      |               |
; -----|IRQ6          |          -----|IRQ6          |      |               |
; -----|IRQ7          |          -----|IRQ7          |      |               |
; 15   +--------------+           7   +--------------+      +---------------+
; 15 IRQs: IRQ0-IRQ8 (on Master), IRQ9-IRQ15 (on Slave)
;
; Example:
;   IRQ  0 — system timer
;   IRQ  1 — keyboard controller
;   IRQ  2 — cascade (interrupt from slave controller)
;   IRQ  3 — serial port COM2
;   IRQ  4 — serial port COM1
;   IRQ  5 — parallel port 2 and 3 or sound card
;   IRQ  6 — floppy controller
;   IRQ  7 — parallel port 1
;   IRQ  8 — RTC timer
;   IRQ  9 — ACPI
;   IRQ 10 — open/SCSI/NIC
;   IRQ 11 — open/SCSI/NIC
;   IRQ 12 — mouse controller
;   IRQ 13 — math co-processor
;   IRQ 14 — ATA channel 1
;   IRQ 15 — ATA channel 2

; 8259 
;   Control Register
;     20_h
;   Data Register
;     A0_h
PIC_MASTER_CMD   equ 0x20
PIC_MASTER_DATA  equ 0x21
PIC_SLAVE_CMD    equ 0xA0
PIC_SLAVE_DATA   equ 0xA1

;
IRQ_SYS_TIMER    equ ( 1        )
IRQ_KEYBOARD     equ ( 1 shl  1 )
IRQ_CASCADE_PIC  equ ( 1 shl  2 )
IRQ_COM1         equ ( 1 shl  3 )
IRQ_COM2         equ ( 1 shl  4 )
IRQ_LPT2         equ ( 1 shl  5 )
IRQ_LPT3         equ ( 1 shl  5 )
IRQ_SOUND_CARD   equ ( 1 shl  5 )
IRQ_FLOPPY       equ ( 1 shl  6 )
IRQ_LPT1         equ ( 1 shl  8 )
IRQ_ACPI         equ ( 1 shl  9 )
IRQ_SCSI         equ ( 1 shl 10 )
IRQ_NIC          equ ( 1 shl 10 )
IRQ_SCSI2        equ ( 1 shl 11 )
IRQ_NIC2         equ ( 1 shl 11 )
IRQ_math         equ ( 1 shl 12 )
IRQ_mouse        equ ( 1 shl 12 )
IRQ_math         equ ( 1 shl 13 )
IRQ_ata1         equ ( 1 shl 14 )
IRQ_ata2         equ ( 1 shl 15 )

; 8259A Initialization Command Words (ICW)
; ICW1
ICW1_ICW4        equ  0001_b   ; ICW4 (not) needed
ICW1_SINGLE      equ  0010_b   ; Single (cascade) mode
ICW1_CASCADE     equ  0000_b   ; Cascade mode
ICW1_INTERVAL4   equ  0100_b   ; Call address interval 4 (8)
ICW1_INTERVAL8   equ  0000_b   ; Call address interval 8
ICW1_LEVEL       equ  1000_b   ; Level triggered (edge) mode
ICW1_EDGE        equ  0000_b   ; Edge triggered mode
ICW1_INIT        equ 10000_b   ; Initialization - required!

; ICW2
;ICW2

; ICW4 
ICW4_MCS80       equ  0000_b   ; MCS-80/85 mode
ICW4_8086        equ  0001_b   ; 8086/88 (MCS-80/85) mode
ICW4_AUTO        equ  0010_b   ; Auto (normal) EOI
ICW4_BUF_SLAVE   equ  1000_b   ; Buffered mode/slave
ICW4_BUF_MASTER  equ  1100_b   ; Buffered mode/master
ICW4_SFNM        equ 10000_b   ; Special fully nested (not)


; Operation Command Words (OCW)

; OCW1
;   Sets and clears the mask bits in the interrupt Mask Register (IMR).
OCW1             equ 0000_0000_b   ; Interrupt mask. 1 - mask set (channerl disabled), 0 - mask reset (channerl enabled)

; OCW2
;   R, SL, EOIÐThese three bits control the Rotate and 
;   End of Interrupt modes and combinations of the two.
OCW2_R           equ 0100_0000_b ; Rotaote
OCW2_SL          equ 0010_0000_b ; Specific EOI command
OCW2_EOI         equ 0001_0000_b ; Non-Specific EOI command
; END OF INTERRUPT
OCW2_001         equ OCW2_EOI             ; 
OCW2_011         equ (OCW2_EOI or OCW2_SL); 
; AUTOMATIC ROTATION
OCW2_101         equ (OCW2_EOI or OCW2_R) ; Rotate on non-specific EOI command
OCW2_100         equ OCW2_R               ; Rotate in autmatic EOI mode (set)
OCW2_000         equ 0                    ; Rotate in autmatic EOI mode (clear)
; SPECIFIC ROTATION
OCW2_111         equ (OCW2_R or OCW2_SL or OCW2_EOI) ; Rotate on specific EOI command
OCW2_110         equ (OCW2_R or OCW2_SL)             ; Set priority command
OCW2_010         equ OCW2_SL                         ; No operation
; Interrupt level acted upon when the SL bit is active.
OCW2_L0          equ 000_B 
OCW2_L1          equ 001_B 
OCW2_L2          equ 010_B 
OCW2_L3          equ 011_B 
OCW2_L4          equ 100_B 
OCW2_L5          equ 101_B 
OCW2_L6          equ 110_B 
OCW2_L7          equ 111_B 

; OCW3
;   ESMM
;     Enable Special Mask Mode. 
;     When ESMM = 1 it enables the SMM bit to set or reset the Special Mask Mode. 
;     When ESMM = 0 the SMM bit becomes a ‘‘don’t care’’.
;   SMM
;     Special Mask Mode. 
;     If ESMM = 1 and SMM = 1 the 8259A will enter Special Mask Mode. 
;     If ESMM = 1 and SMM = 0 the 8259A will revert to normal mask mode. 
;     If ESMM = 0, SMM has no effect.
; SPECIAL MASK MODE
OCW3_SET_SPECIAL_MASK_COMMAND   equ 0110_1000_B ; Set special mask
OCW3_RESET_SPECIAL_MASK_COMMAND equ 0100_1000_B ; Reset special mask
; POLL COMMAND
OCW3_POLL_COMMAND               equ 0000_1100_B
OCW3_NO_POLL_COMMAND            equ 0000_1000_B
; READ REGISTER COMMANDE
OCW3_READ_IR_COMMAND            equ 0000_1010_B ; read IR register on next RD pulse
OCW3_READ_IS_COMMAND            equ 0000_1011_B ; read IS register on next RD pulse

; Fully Nested Mode
;   This mode is entered after initialization unless another mode is programmed.

; End of Interrupt (EOI)
;   The In Service (IS) bit can be reset either automati-
;   cally following the trailing edge of the last in se-
;   quence INTA pulse (when AEOI bit in ICW1 is set) or
;   by a command word that must be issued to the
;   8259A before returning from a service routine (EOI
;   command). An EOI command must be issued twice
;   if in the Cascade mode, once for the master and
;   once for the corresponding slave.

; Automatic End of Interrupt (AEOI) Mode
;   If AEOI e 1 in ICW4, then the 8259A will operate in
;   AEOI mode continuously until reprogrammed by
;   ICW4. in this mode the 8259A will automatically per-
;   form a non-specific EOI operation at the trailing
;   edge of the last interrupt acknowledge pulse (third
;   pulse in MCS-80/85, second in 8086). Note that
;   from a system standpoint, this mode should be used
;   only when a nested multilevel interrupt structure is
;   not required within a single 8259A.

; Automatic Rotation (Equal Priority Devices)
;   In some applications there are a number of interrupt-
;   ing devices of equal priority. In this mode a device,
;   after being serviced, receives the lowest priority, so
;   a device requesting an interrupt will have to wait, in
;   the worst case until each of 7 other devices are
;   serviced at most once . For example, if the priority
;   and ‘‘in service’’ status is:

; Specific Rotation (Specific Priority)
;   The programmer can change priorities by program-
;   ming the bottom priority and thus fixing all other pri-
;   orities; i.e., if IR5 is programmed as the bottom prior-
;   ity device, then IR6 will have the highest one.

; Poll Command
;   In Poll mode the INT output functions as it normally
;   does. The microprocessor should ignore this output.
;   This can be accomplished either by not connecting
;   the INT output or by masking interrupts within the
;   microprocessor, thereby disabling its interrupt input.
;   Service to devices is achieved by software using a
;   Poll command.

; Special Mask Mode
;   Some applications may require an interrupt service
;   routine to dynamically alter the system priority struc-
;   ture during its execution under software control. For
;   example, the routine may wish to inhibit lower priori-
;   ty requests for a portion of its execution but enable
;   some of them for another portion.

; Reading the 8259A Status
;   The input status of several internal registers can be
;   read to update the user information on the system.
;   For reading the IMR, no OCW3 is needed. The out-
;   put data bus will contain the IMR whenever RD is
;   active and A0 e 1 (OCW1).
; Result
;   AL : mask
macro pic.read_master_mask
{
    in  al, PIC_MASTER_DATA
}

; Result
;   AL : mask
macro pic.read_slave_mask
{
    in  al, PIC_SLAVE_DATA
}

; Edge and Level Triggered Modes
;   This mode is programmed using bit 3 in ICW1.

; The Special Fully Nest Mode
;   This mode will be used in the case of a big system
;   where cascading is used, and the priority has to be
;   conserved within each slave. In this case the fully
;   nested mode will be programmed to the master (us-
;   ing ICW4). This mode is similar to the normal nested
;   mode with the following exceptions:
;   a. When an interrupt request from a certain slave is
;      in service this slave is not locked out from the
;      master’s priority logic and further interrupt re-
;      quests from higher priority IR’s within the slave
;      will be recognized by the master and will initiate
;      interrupts to the processor. (In the normal nested
;      mode a slave is masked out when its request is in
;      service and no higher requests from the same
;      slave can be serviced.)
;   b. When exiting the Interrupt Service routine the
;      software has to check whether the interrupt serv-
;      iced was the only one from that slave. This is
;      done by sending a non-specific End of Interrupt
;      (EOI) command to the slave and then reading its
;      In-Service register and checking for zero. If it is
;      empty, a non-specific EOI can be sent to the
;      master too. If not, no EOI should be sent.

; Buffered Mode
;   When the 8259A is used in a large system where
;   bus driving buffers are required on the data bus and
;   the cascading mode is used, there exists the prob-
;   lem of enabling buffers.

; CASCADE MODE
;   The 8259A can be easily interconnected in a system
;   of one master with up to eight slaves to handle up to
;   64 priority levels.


; 
; Interrupt Request Register (IRR)
; In-Service Register (ISR)
;   OCW3 ( bit 3 set )
PIC_READ_IRR     equ 0A_H    ; OCW3 irq ready next CMD read
PIC_READ_ISR     equ 0B_H    ; OCW3 irq service next CMD read


macro io_wait
{
    xor  al, al
    out  80_h, al ; send byte into unused port
}

; Initialisation

; PIC initializations.
;   Sends 4 words: ICW1, ICW2, ICW3, ICW4.
;   After the Initialization Command Words (ICWs) are
;   programmed into the 8259A, the chip is ready to ac-
;   cept interrupt requests at its input lines.
;
; m_vectors_offset : vector offset for master PIC
;                    vectors on the master become offset1..offset1+7
; s_vectors_offset : same for slave PIC: offset2..offset2+7
; 
; Uses;
;   AX
macro pic.init  mode, m_vectors_offset, s_vectors_offset, master_line_with_slave, slave_io, submode
{
    ; ICW1. init + mode + single/cascade + interval 4/8 + level triggered/edge triggered
    mov  al, mode
    out  PIC_MASTER_CMD,  al ; starts the initialization sequence (in cascade mode)
    io_wait
    mov  al, mode
    out  PIC_SLAVE_CMD,   al
    io_wait

    ; ICW2. interrupt offset
    mov  al, m_vectors_offset
    out  PIC_MASTER_DATA, al  ; ICW2: Master PIC vector offset
    io_wait
    mov  al, s_vectors_offset
    out  PIC_SLAVE_DATA,  al  ; ICW2: Slave PIC vector offset
    io_wait

    if ( mode and ICW1_CASCADE )
        ; ICW3. master device
        mov  al, master_line_with_slave
        out  PIC_MASTER_DATA, al  ; ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
        io_wait
        mov  al, slave_io
        out  PIC_SLAVE_DATA,  al  ; ICW3: tell Slave PIC its cascade identity (0000 0010)
        io_wait
    end if

    ; ICW4. mode
    if ( mode and ICW1_ICW4 )
        if ( submode and ICW4_8086 )
            mov  al, ICW4_8086
            out  PIC_MASTER_DATA, al
            io_wait
            mov  al, ICW4_8086
            out  PIC_SLAVE_DATA,  al
            io_wait
        end if
    end if
}


; Set mode.
;   During the 8259A operation, a selection of algo-
;   rithms can command the 8259A to operate in vari-
;   ous modes through the Operation Command Words (OCWs).
macro pic.set_mode
{
    ;
}



; Disabling

; Disable PIC
;   before using Local APIC
; Uses;
;   AL
macro pic.disable
{
    mov al, 11111111_B
    out PIC_SLAVE_DATA,  al
    out PIC_MASTER_DATA, al
}


; Masking

;
macro pic.set_mask master_irq_mask, slave_irq_mask
{
    mov al, master_irq_mask
    out PIC_MASTER_DATA, al

    mov al, slave_irq_mask
    out PIC_SLAVE_DATA, al
}

;
; Interrupt Mask Register (IMR)
;
macro pic.enable_irq irq_line
{
    local port

    if ( irq_line < 8)
        port = PIC_MASTER_DATA
    else
        port = PIC_SLAVE_DATA
        irq_line = irq_line - 8
    end if 

    ;
    in  al, port
    and al, ( 1 shl irq_line )
    inv al
    out port, al
}


macro pic.clear_mask irq_line
{
    local port

    if ( irq_line < 8)
        port = PIC_MASTER_DATA
    else
        port = PIC_SLAVE_DATA
        irq_line = irq_line - 8
    end if 

    ;
    in  al, port
    and al, ( ~( 1 shl irq_line ) )
    out port, al
}


; ISR and IRR

; Helper func
;   OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
;   represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain
macro pic.get_irq_reg  ocw3
{
    mov  al, ocw3
    out  PIC_MASTER_CMD,  al
    io_wait
    mov  al, ocw3
    out  PIC_SLAVE_CMD,   al
    io_wait
    in   al, PIC_SLAVE_DATA
    mov  ah, al
    in   al, PIC_MASTER_DATA
}

; Returns the combined value of the cascaded PICs irq request register
macro pic.get_irr
{
    pic.get_irq_reg  PIC_READ_IRR
}

; Returns the combined value of the cascaded PICs in-service register
macro pic.get_isr
{
    pic.get_irq_reg  PIC_READ_ISR
}


; Remapping
macro pic.remap pic1_start_num, pic2_start_num
{
    mov al, 11_H
    out PIC_MASTER_CMD, al    ; restart PIC1
    out PIC_SLAVE_CMD, al     ; restart PIC2

    mov al, pic1_start_num    ; (example: 20_H)
    out PIC_MASTER_DATA, al   ; PIC1 now starts at pic1 (example: 32)
    mov al, pic2_start_num    ; (example: 28_H)
    out PIC_SLAVE_DATA, al    ; PIC2 now starts at pic2 (ecample: 40)

    mov al, 04_H
    out PIC_MASTER_DATA, al   ; setup cascading
    mov al, 02_H
    out PIC_SLAVE_DATA, al

    mov al, 01_H
    out PIC_MASTER_DATA, al
    out PIC_SLAVE_DATA, al     ; done!    
}


; Spurious IRQs


; ;
; pic.setup:
; setup.pic:
; setup_pic:
;     pic.init        80h, 88h
;     pic.set_mask    11111100_B, 11111100_B
; ret


; src
;   pic.asm
;     setop
;
;     code:
;       setop.pic
;     doc:
;       pic.setop

; setop.pic
;   src/pic.asm : setop


