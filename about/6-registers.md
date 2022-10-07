# Registers
## Registers

+--------+                  + 
| R AX   | - return value   | General purpose (64 bit)
| R BX   |                  |
| R CX   |                  |
| R DX   |                  |
| R SI   |                  |
| R DI   |                  |
| R BP   |                  |
| R SP   |                  |
+--------+                  + 
| R 8    | - opcode         | Ext registers (64 bit)
| R 9    | - arg1           |
| R 10   |                  |
| R 11   | - focused object | - | may be FS segment register
| R 12   | - ops base       | - |
| R 13   | - ops limit      |
| R 14   | - ops start      |
| R 15   | - ops end        |
+--------+                  +
| MM 0   |                  | MMX registers (64 bit)
| MM 1   |                  |
| MM 2   |                  |
| MM 3   |                  |
| MM 4   |                  |
| MM 5   |                  |
| MM 6   |                  |
| MM 7   |                  |
+--------+--------+         + SSE registers (128 bit)
| XMM 0           | - opcode, arg1
| XMM 1           |         |
| XMM 2           |         |
| XMM 3           |         |
| XMM 4           |         |
| XMM 5           |         |
| XMM 6           |         |
| XMM 7           |         |
| XMM 8           |         | 
| XMM 9           |         |
| XMM 10          |         |
| XMM 11          |         |
| XMM 12          |         |
| XMM 13          |         |
| XMM 14          |         |
| XMM 15          |         |
+--+--------------+         +
|CS| - code  segment        | Segment registers (16 bit)
|DS| - data  segment        | 
|SS| - stack segment        | 
|ES|                        |
|FS|                        |
|GS| - ops base segment     |
+--+-----+                  +
| RFLAGS |                  | Flags register (64 bit)
+--------+                  +
| CR0    |                  | Control registers (64 bit)
| CR2    |                  |
| CR3    |                  |
| CR4    |                  |
+--------+                  +
| RIP    |                  | Instruction pointer (64 bit)
+--------+-+                +
| GDTR     |                | System table pointer registers 
| IDTR     |                | 80 bit. Limit + Base. 16 bit + 64 bit
+--+-------+                +
|..| LDTR                   | LDTR. 16 bit. Segment selector
|TR| TR                     | TR.   16 bit. Segment selector
+--+                        +

  MXCSR    MSR registers
  ***      MSR registers
  ST0-ST7  x87 FPU registers (80 bit)

- ***                 Task register
- DR0-DR3, DR6, DR7   Debug registers


All of these registers can be accessed at the byte, word, dword, and qword level. REX prefixes are used to generate 64-bit operand sizes or to reference registers R8-R15.

Registers only available in 64-bit mode (R8-R15 and XMM8-XMM15) are preserved across transitions from 64-bit mode into compatibility mode then back into 64-bit mode. However, values of R8-R15 and XMM8-XMM15 are undefined after transitions from 64-bit mode through compatibility mode to legacy or real mode and then back through compatibility mode to 64-bit mode

### Segment register
The segment registers 
- CS
- DS
- SS
- ES
- FS
- GS
hold 16-bit segment selectors.

In 64-bit mode: CS, DS, ES, SS are treated as if each segment base is 0, regardless of the value of the associated segment descriptor base. This creates a flat address space for code, data, and stack.

### FLAGS Register
```
31                               0                                                 XSC
+----------------+----------------+                                               +---+
|0000000000      |                |                                               |   |
|          *     |                | 21       ID  ID Flag                          |X  |
|           *    |                | 20      VIP  Virtual Interrupt Pending        |X  |
|            *   |                | 19      VIF  Virtual Interrupt Flag           |X  |
|             *  |                | 18       AC  Alignment Check / Access Control |X  |
|              * |                | 17       VM  Virtual-8086 Mode                |X  |
|               *|                | 16       RF  Resume Flag                      |X  |
+----------------+----------------+                                               +---+
|                |0               | 15                                            |   |
|                | *              | 14       NT  Nested Task                      |X  |
|                |  **            | 12-13  IOPL  I/O Privilege Level              |X  |
|                |    *           | 11       OF  Overflow Flag                    | S |
|                |     *          | 10       DF  Direction Flag                   |  C|
|                |      *         |  9       IF  Interrupt Enable Flag            |X  |
|                |       *        |  8       TF  Trap Flag                        |X  |
|                |        *       |  7       SF  Sign Flag                        | S |
|                |         *      |  6       ZF  Zero Flag                        | S |
|                |          0     |  5                                            |   |
|                |           *    |  4       AF  Auxiliary Carry Flag             | S |
|                |            0   |  3                                            |   |
|                |             *  |  2       PF  Parity Flag                      | S |
|                |              1 |  1                                            |   |
|                |               *|  0       CF  Carry Flag                       | S |
+----------------+----------------+                                               +---+
X - System Flag
S - Status Flag (results of arithmetic instructions: ADD, SUB, MUL, DIV)
C - Control Flag

DF - Direction Flag (controls string instructions: MOVS, CMPS, SCAS, LODS, STOS)
```

### Instruction pointer (EIP)
- EIP - instruction pointer

This register holds the 64-bit offset of the next
instruction to be executed.


## x86-64
Архитектура x86-64 имеет:

- 16 целочисленных 64-битных регистров общего назначения (RAX, RBX, RCX, RDX, RBP, RSI, RDI, RSP, R8 — R15);
- 8 80-битных регистров с плавающей точкой (ST0 — ST7);
- 8 64-битных регистров Multimedia Extensions (MM0 — MM7, имеют общее пространство с регистрами ST0 — ST7);
- 16 128-битных регистров SSE (XMM0 — XMM15);
- 64-битный указатель RIP и 64-битный регистр флагов RFLAGS.

+-------------------------------------------------------------------+
|                                RAX                                | 64 bit
+-------------------------------------------------------------------+
|                                 |               EAX               | 32 bit
+-------------------------------------------------------------------+
|                                 |                |       AX       | 16 bit
+-------------------------------------------------------------------+
|                                 |                |   AH   |   AL  |  8 bit
+-------------------------------------------------------------------+

Операции над младшими 32-битными половинами регистров обнуляют старшие 32 бита. Например,
```
    mov eax, ebx    ; автоматически занулит старшие биты в rax.
```

### FS, GS
FS, GS - сегментные регистры. в x86-64 можно использовать операционной системой
Ядро Linux использует GS-сегмент для хранения данных per-CPU.
Microsoft Windows на x86-64 использует GS для указания на Thread Environment Block, маленькую структурку для каждого потока, которая содержит информацию об обработке исключений, thread-local-переменных и прочих per-thread-сведений.

### bcd, aam
В x86-64 по сравнению с x86 удалили некоторые устаревшие инструкции. Это двоично-десятичная арифметика BCD и инструкции типа aam (ASCII adjust for multiplication). 

### registers example
```
(gdb) i r
rax            0x5555555ea924      93824992848164
rbx            0x0                 0
rcx            0x5555556802d0      93824993460944
rdx            0x7fffffffe578      140737488348536
rsi            0x7fffffffe568      140737488348520
rdi            0x1                 1
rbp            0x7fffffffe450      0x7fffffffe450
rsp            0x7fffffffe450      0x7fffffffe450
r8             0x5555556a1380      93824993596288
r9             0x5555556a1380      93824993596288
r10            0x7ffff7fc3908      140737353890056
r11            0x7ffff7fde680      140737354000000
r12            0x7fffffffe568      140737488348520
r13            0x5555555ea924      93824992848164
r14            0x5555556802d0      93824993460944
r15            0x7ffff7ffd040      140737354125376
rip            0x5555555ea928      0x5555555ea928 <main+4>
eflags         0x246               [ PF ZF IF ]
cs             0x33                51
ss             0x2b                43
ds             0x0                 0
es             0x0                 0
fs             0x0                 0
gs             0x0                 0
```

## Stack
RSP - вершина стека

+------------------+ high address
|                  |
|                  |
|                  |
+------------------+ 
| var_x            |
+------------------+ top of stack ( RSP )
|         |        |
|         V        |
|    stack grows   |
+------------------+ low address

### call ABI
#### Linux
В Linux и других ОС используется соглашение System V AMD64 ABI.
Первые шесть аргументов передаются через регистры:
- rdi
- rsi
- rdx
- rcx
- r8
- r9
Если этого не хватает, то седьмой аргумент уже передаётся через стек.

Если функция хочет использовать регистры rbx, rbp и r12–r15, она перед выходом обязана их вернуть в первоначальное состояние.

Возвращаемое значение до 64 бит сохраняется в rax, до 128 бит — в rax и rdx.

#### Windows
Первые четыре аргумента передаются через регистры: 
- rcx
- rdx
- r8
- r9

Регистры rbx, rbp, rdi, rsi, rsp, r12, r13, r14 и r15 функция обязана вернуть в исходное состояние.



### Фрейм стека

Для такой функции
```C
long myfunc(long a, long b, long c, long d,
            long e, long f, long g, long h)
{
    long xx = a * b * c * d * e * f * g * h;
    long yy = a + b + c + d + e + f + g + h;
    long zz = utilfunc(xx, yy, xx % yy);
    return zz + 20;
}
```

```
+------------------+ 
|        a         | RDI
+------------------+
|        b         | RSI
+------------------+
|        c         | RDX
+------------------+
|        d         | RCX
+------------------+
|        e         | R8
+------------------+
|        f         | R9
+------------------+

+------------------+ high address
|                  | 
+------------------+ 
|        h         | RBP + 24
+------------------+ 
|        g         | RBP + 16
+------------------+
|  return address  | RBP + 8
+------------------+
|    saved RBP     | RBP
+------------------+
|        xx        | RBP - 8
+------------------+
|        yy        | RBP - 16
+------------------+
|        zz        | RBP - 24
+------------------+
|                  |
|                  | red zone (128 Bytes)
|                  |
|                  |
|                  |
+------------------+
```

Красная зона (red zone)
128-байтовая область за пределами места, на которое указывает rsp, считается зарезервированной и не должна изменяться обработчиками сигналов или прерываний. Функции могут использовать эту область для временных данных, которые не нужны для вызовов функций. В частности, листовые функции (из которых не вызываются другие функции) могут использовать эту область для всего кадра стека, а не изменять указатель стека rsp в начале и конце выполнения.

```C
long utilfunc(long a, long b, long c)
{
    long xx = a + 2;
    long yy = b + 3;
    long zz = c + 4;
    long sum = xx + yy + zz;
 
    return xx * yy * zz + sum;
}
```

```
+------------------+ 
|        a         | RDI
+------------------+
|        b         | RSI
+------------------+
|        c         | RDX
+------------------+

+------------------+ high address
|                  | 
+------------------+
|  return address  | RBP + 8
+------------------+
|    saved RBP     | RBP, RSP
+------------------+-------------
|        xx        | RBP - 8   |
+------------------+           |
|        yy        | RBP - 16  |
+------------------+           |
|        zz        | RBP - 24  |
+------------------+           |
|       sum        | RBP - 32  |
+------------------+           |
|                  |           |
|                  |           | red zone (128 Bytes)
|                  |           |
|                  |           |
|                  |           |
+------------------+-------------
```

