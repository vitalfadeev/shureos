;
; Clear screen
;
macro clear_screen
{    
    mov al, 02h ; here you set the 80x25 graphical mode (text)
    mov ah, 00h ; this is the code of the function that allows us to change the video mode
    int 10h     ; here you call the interrupt It was originally published on https://www.apriorit.com/
}
