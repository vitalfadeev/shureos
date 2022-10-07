# BIOS interrupts
BIOS interrupts and screen cleaners

Before our bootloader can display the message, the screen must be cleared. Let’s use a BIOS interrupt for this task.

The BIOS provides various interrupts that allow for interacting with computer hardware: input devices, disk storage, audio adapters, and so on. An interrupt looks like this:

```
int [number_of_interrupt];
```

Here, the number_of_interrupts is the interrupt number. In this tutorial, you’ll need the following interrupts:

* int 10h, function 00h – This function changes the video mode and thus clears the screen
* int 10h, function 01h – This function sets the type of the cursor
* int 10h, function 13h – This function concludes the whole routine by displaying a string of text on the screen

Before you call an interrupt, you must first define its parameters. The ah processor register contains the function number for an interrupt, while the rest of the registers store other parameters of the current operation. For example, let’s see how the int 10h interrupt works in an assembler. You need the 00h function to change the video mode, which will result in a clear screen:

```
mov al, 02h ; here we set the 80x25 graphical mode (text)
mov ah, 00h ; this is the code of the function that allows us to change the video mode
int 10h   ; here we call the interrupt
```
