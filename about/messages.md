# Messages

64-bit data-bus =>
  64-bit register =>
  64-bit memory-block
    opcode  : 32-bit
    xy      : 32-bit : 16-bit + 16-bit
    keycode : 16-bit
    address : 64-bit
    sstruct : 64-bit (small struct <= 64-bit, else pointer)
    sstring : 64-bit (small string <= 64-bit, else pointer)
    long    : 64-bit
    int     : 32-bit
    short   : 16-bit
    byte    :  8-bit
    color   : 32-bit RGBA

## 1st 64-bit (opcode)
```
63                                  31                                 0
+--------+--------+--------+--------+--------+--------+--------+--------+
|        |        |        |        |********|********|********|********| opcode 
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|        |        |        |        |        |        | xy.x
|        |        |********|********|        |        |        |        | xy.y
+--------+--------+--------+--------+--------+--------+--------+--------+
|        |        |********|********|        |        |        |        | keycode
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|********|********|        |        |        |        | int
|        |        |********|********|        |        |        |        | short
|        |        |        |********|        |        |        |        | byte
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|        |        |        |        |        |        |        | color.A
|        |********|        |        |        |        |        |        | color.B
|        |        |********|        |        |        |        |        | color.G
|        |        |        |********|        |        |        |        | color.R
+--------+--------+--------+--------+--------+--------+--------+--------+
```

## 2st 64-bit (arg1)
```
63                                  31                                 0
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|********|********|********|********|********|********| sstruct
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|********|********|********|********|********|********| sstring
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|********|********|********|********|********|********| address
+--------+--------+--------+--------+--------+--------+--------+--------+
|********|********|********|********|********|********|********|********| long
|        |        |        |        |********|********|********|********| int
|        |        |        |        |        |        |********|********| short
|        |        |        |        |        |        |        |********| byte
+--------+--------+--------+--------+--------+--------+--------+--------+
```

```asm
; 1st 64-bit. Message Opcode
struct Message_opcode
{
    struct
    {        
        .opcode  dd ?  ; 32-bit
    }

    union
    {
        .keycode dq ?  ; 16-bit
        .xy      dd ?  ; 32-bit
        .int     dd ?  ; 32-bit
        .short   dw ?  ; 16-bit
        .byte    db ?  ;  8-bit
        .color   dd ?  ; 32-bit
    }
}

; 2nd 64-bit. Message arg1
struct Message_arg1
{
    union
    {
        .sstruct dq ?  ; 64-bit
        .sstring dq ?  ; 64-bit
        .address dq ?  ; 64-bit
        .long    dq ?  ; 64-bit
        .int     dd ?  ; 32-bit
        .short   dw ?  ; 16-bit
        .byte    db ?  ;  8-bit
    }
}

; 128-bit message
struct Message
{
    Message_opcode msg_opcode ; 64-bit
    Message_opcode msg_arg1   ; 64-bit
}
```

## opcode
```
63                                  31                                 0
+--------+--------+--------+--------+--------+--------+--------+--------+
|        |        |        |        |********|        |        |********| user
|        |        |        |        |        |********|        |********| 
|        |        |        |        |        |        |****    |********| soft HL
|        |        |        |        |        |        |   *    |********|   screenshot
|        |        |        |        |        |        |   *    |********|   reboot
|        |        |        |        |        |        |   *    |********|   poweroff
|        |        |        |        |        |        |   *    |********|   install
|        |        |        |        |        |        |   *    |********|   cam image
|        |        |        |        |        |        |   *    |********|   download
|        |        |        |        |        |        |   *    |********|   upload
|        |        |        |        |        |        |   *    |********|   net-msg
|        |        |        |        |        |        |   *    |********|   share
|        |        |        |        |        |        |   *    |********|     image
|        |        |        |        |        |        |   *    |********|     url
|        |        |        |        |        |        |   *    |********|     file
|        |        |        |        |        |        |   *    |********|     contact
|        |        |        |        |        |        |   *    |********|   call-phone
|        |        |        |        |        |        |   *    |********|   sms
|        |        |        |        |        |        |   *    |********|   play-mp3
|        |        |        |        |        |        |   *    |********|   open-dnldr
|        |        |        |        |        |        |   *    |********|   open-url
|        |        |        |        |        |        |   *    |********|   open-map
|        |        |        |        |        |        |    ****|********| os ...
|        |        |        |        |        |        |        |        |   hw
|        |        |        |        |        |        |    1000|********|     usb
|        |        |        |        |        |        |     111|********|     sound
|        |        |        |        |        |        |     110|********|     video
|        |        |        |        |        |        |     101|********|     net
|        |        |        |        |        |        |     100|********|     timer
|        |        |        |        |        |        |      11|********|     mouse
|        |        |        |        |        |        |      10|********|     keyboard
|        |        |        |        |        |        |        |        |   soft
|        |        |        |        |        |        |       1|********|     window
|        |        |        |        |        |        |        |********|   +--------+--------+--------+--------+--------+--------+--------+--------+
```

### os window
window create
window created
window destroy
window destroed
window activate
window activated
window deactivate
window deactivated
window focuse
window focused
window move
window moved
window resize
window resized
#### os window control buttons
window close
window closed
window minimize
window minimized
window maximize
window maximized
window pin
window pined

### os keyboard
key pressed
key released

### os mouse
mouse moved
mouse key pressed
mouse key released
mouse wheel up
mouse wheel down
mouse wheel pressed

### os timer
timer timeout

### os usb
device plug
device pluged
device remove
device removed

### jmp table ( small version: 4096 bytes )

```asm
    mov  ax, opcode ; |    ****|********|
    and  ah, 1111_B ; |    ****|

    ; goto [opcode]
    lea rbx, [opcode_jump_table_start + ah * 8]
    jmp [rbx]

    align 8
    opcode_jump_table_start:
        dq  os_window__table
        dq  os_keyboard__table
        dq  os_mouse__table
        dq  os_timer__table
        dq  os_new__table
        dq  os_video__table
        dq  os_sound__table
        dq  os_usb__table
        ...
        dq  opcode_jump_table_os_1111_B
    opcode_jump_table_end: ;
```

```asm
os_window__table:
    ; goto [opcode.os.window]
    lea rbx, [opcode_jump_table_os_window_start + al * 8]
    jmp [rbx]

    align 8
    opcode_jump_table_os_window_start:
        dq  os_window_create__handler
        dq  os_window_created__handler
        ...
        dq  os_window_pin__handler
        dq  os_window_pined__handler
    opcode_jump_table_os_window_end: ;
```

```asm
; on OS Window create
;   R8 : opcode
;   R9 : arg1
os_window_create__handler:
    ;
ret
```

### jmp table ( large version, but fast: 32768 bytes )

```asm
    ; movdqu xmm0, XMMWORD PTR [rsi]
    ;
    mov  ax, opcode           ; |    ****|********|
    and  ax, 1111_11111111_B  ; |    ****|********|

    lea  rbx, [opcode_jump_table_os_window_start + ax * 8]
    jmp  [rbx]
```

## Message procedure

```asm
; R8 : opcode
; R9 : arg1
msg_proc:
    cmp  R8, MSG_OS_WINDOW_CREATED;
    je   on_window_created
    cmp  R8, MSG_OS_WINDOW_CLOSED;
    je   on_window_closed
    jmp  default_msg_proc

    ; je  R8, MSG_OS_WINDOW_CREATED, on_window_created
    ; je  R8, MSG_OS_WINDOW_CLOSED,  on_window_closed
    ; jmp  default_msg_proc
ret

on_window_created:
    ; take screenshot
    mov params.callback, screenshot_callback
    mov params.format, SCREENSHOT_FORMAT_JPG

    mov  R8, OP_SCREENSHOT
    lea  R9, [params]
    call  move_op_to_storage

    ; mov  op_storage, OP_SCREENSHOT, params
    ret

    ;
    screenshot_callback:
        ;
    ret

    screenshot_params: params
ret

on_window_closed:
    ;
ret
```
