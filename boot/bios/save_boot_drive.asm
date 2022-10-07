;
; save_boot_drive
;
; requires: 
;   boot_drive

macro save_boot_drive
{
   ; Before we do anything else, we want to save the ID of the boot
   ; drive, which the BIOS stores in register dl. We can offload this
   ; to a specific location in memory
   mov byte[boot_drive], dl
}
