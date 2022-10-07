;
; load_sector_1
;

macro load_sector_1
{
   ; Load the next sector

   ; The first sector's already been loaded, so we start with the second sector
   ; of the drive. Note: Only bl will be used
   mov bx, 0x0002

    ; 3 sectors from disk
   mov cx, sectors_to_read

   ; Finally, we want to store the new sector immediately after the first
   ; loaded sector, at adress 0x7E00. This will help a lot with jumping between
   ; different sectors of the bootloader.
   mov dx, 0x7C00 + sector_size ; 0x7E00

   ; Now we're fine to load the new sectors
   call load_bios   
}
