;
; idt_64_vectors
;

;
; номер исключения i386.
;
EXP_DIVIDE_ERROR             equ 0x00 ; Ошибка
EXP_DEBUG                    equ 0x01 ; Ошибка/ловушка
EXP_BREAKPOINT               equ 0x03 ; Ловушка
EXP_OVERFLOW                 equ 0x04 ; Ловушка
EXP_BOUNDS_CHECK             equ 0x05 ; Ошибка
EXP_BAD_CODE                 equ 0x06 ; Ошибка
EXP_NO_CORPROCESSOR          equ 0x07 ; Ошибка
EXP_DOUBLE_FAULT             equ 0x08 ; Прерывание, код ошибки
EXP_CORPROCESSOR_OVERRUN     equ 0x09 ; Прервать
EXP_INVALID_TSS              equ 0x0A ; Ошибка, код ошибки
EXP_SEGMENT_NOT_PRESENT      equ 0x0B ; Ошибка, код ошибки
EXP_STACK_FAULT              equ 0x0C ; Ошибка, код ошибки
EXP_GENERAL_PROTECTION_FAULT equ 0x0D ; Ошибка, код ошибки
EXP_PAGE_FAULT               equ 0x0E ; Ошибка, код ошибки
EXP_CORPROCESSOR_ERROR       equ 0x10 ; Ошибка

;
; Номер прерывания устройства.
;
; define PIC1_VECTOR 0x20
; define PIC2_VECTOR 0x28
INT_TIMER                    equ 0x20   ; Число 32. 8253 Программируемый счетчик таймера.
INT_KEYBOARD                 equ 0x21   ; Число 33. клавиатура.
INT_COM2                     equ 0x23   ; Число 35. Последовательный порт 2.
INT_COM1                     equ 0x24   ; Число 36. Последовательный порт 1.
INT_LPT2                     equ 0x25   ; Число 37. Параллельный порт 2.
INT_FLOPPY                   equ 0x26   ; Число 38. Флоппи-дисковод.
INT_LPT1                     equ 0x27   ; Число 39. Параллельный порт 1.
INT_CLOCK                    equ 0x28   ; Число 40. Часы реального времени.
INT_PS2                      equ 0x2C   ; Число 44. Интерфейс PS2.
INT_FPU                      equ 0x2D   ; Число 45. блок обработки с плавающей запятой.
INT_HD                       equ 0x2E   ; Число 46. жесткий диск.

