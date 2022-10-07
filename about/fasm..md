# fasm

## =
The *=* directive allows to define the numerical constant. It should be preceded by the name for the constant and followed by the numerical expression providing the value. The value of such constants can be a number or an address, but - unlike labels - the numerical constants are not allowed to hold the register-based addresses. Besides this difference, in their basic variant numerical constants behave very much like labels and you can even forward-reference them (access their values before they actually get defined).

There is, however, a second variant of numerical constants, which is recognized by assembler when you try to define the constant of name, under which there already was a numerical constant defined. In such case assembler treats that constant as an assembly-time variable and allows it to be assigned with new value, but forbids forward-referencing it (for obvious reasons). Let's see both the variant of numerical constants in one example:
```asm
    dd sum
    x = 1
    x = x+2
    sum = x
```

Here the **x** is an assembly-time variable, and every time it is accessed, the value that was assigned to it the most recently is used. Thus if we tried to access the x before it gets defined the first time, like if we wrote `dd x` in place of the `dd sum` instruction, it would cause an error. And when it is re-defined with the **x = x+2** directive, the previous value of **x** is used to calculate the new one. So when the **sum** constant gets defined, the x has value of 3, and this value is assigned to the **sum**. Since this one is defined only once in source, it is the standard numerical constant, and can be forward-referenced. So the `dd sum` is assembled as `dd 3`. To read more about how the assembler is able to resolve this, see section 2.2.6.

The value of numerical constant can be preceded by size operator, which can ensure that the value will fit in the range for the specified size, and can affect also how some of the calculations inside the numerical expression are performed. This example:
```asm
    c8 = byte -1
    c32 = dword -1
```
defines two different constants, the first one fits in 8 bits, the second one fits in 32 bits.

When you need to define constant with the value of address, which may be register-based (and thus you cannot employ numerical constant for this purpose), you can use the extended syntax of **label** directive (already described in section 1.2.3), like:
```asm
    label myaddr at ebp+4
```
which declares label placed at `ebp+4` address. However remember that labels, unlike numerical constants, cannot become assembly-time variables.


## if
**if** directive causes come block of instructions to be assembled only under certain condition. It should be followed by logical expression specifying the condition, instructions in next lines will be assembled only when this condition is met, otherwise they will be skipped. The optional **else if** directive followed with logical expression specifying additional condition begins the next block of instructions that will be assembled if previous conditions were not met, and the additional condition is met. The optional **else** directive begins the block of instructions that will be assembled if all the conditions were not met. The **end if** directive ends the last block of instructions.

You should note that **if** directive is processed at assembly stage and therefore it doesn't affect any preprocessor directives, like the definitions of symbolic constants and macroinstructions - when the assembler recognizes the **if** directive, all the preprocessing has been already finished.

## ~ , &, |, =, <, >, <=, >=
The logical expression consist of logical values and logical operators. The logical operators are **~ ** for logical negation, **&** for logical and, **|** for logical or. The negation has the highest priority. Logical value can be a numerical expression, it will be false if it is equal to zero, otherwise it will be true. Two numerical expression can be compared using one of the following operators to make the logical value: **=** (equal), **<** (less), **>** (greater), **<=** (less or equal), **>=** (greater or equal), **<>** (not equal).

## used
The **used** operator followed by a symbol name, is the logical value that checks whether the given symbol is used somewhere (it returns correct result even if symbol is used only after this check). The **defined** operator can be followed by any expression, usually just by a single symbol name; it checks whether the given expression contains only symbols that are defined in the source and accessible from the current position. The **definite** operator does a similar check with restriction to symbols defined before current position in source.

## relativeto
With **relativeto** operator it is possible to check whether values of two expressions differ only by constant amount. The valid syntax is a numerical expression followed by **relativeto** and then another expression (possibly register-based). Labels that have no simple numerical value can be tested this way to determine what kind of operations may be possible with them.

## count
The following simple example uses the **count** constant that should be defined somewhere in source:
```asm
    if count>0
        mov cx,count
        rep movsb
    end if
```

These two assembly instructions will be assembled only if the **count** constant is greater than 0. The next sample shows more complex conditional structure:
```asm
    if count & ~ count mod 4
        mov cx,count/4
        rep movsd
    else if count>4
        mov cx,count/4
        rep movsd
        mov cx,count mod 4
        rep movsb
    else
        mov cx,count
        rep movsb
    end if
```
The first block of instructions gets assembled when the **count** is non zero and divisible by four, if this condition is not met, the second logical expression, which follows the **else if**, is evaluated and if it's true, the second block of instructions get assembled, otherwise the last block of instructions, which follows the line containing only **else**, is assembled.

## in
There are also operators that allow comparison of values being any chains of symbols. The eq compares whether two such values are exactly the same. The **in** operator checks whether given value is a member of the list of values following this operator, the list should be enclosed between **<** and **>** characters, its members should be separated with commas. The symbols are considered the same when they have the same meaning for the assembler - for example **pword** and **fword** for assembler are the same and thus are not distinguished by the above operators. In the same way `16 eq 10h` is the true condition, however `16 eq 10+4` is not.

## eqtype
The **eqtype** operator checks whether the two compared values have the same structure, and whether the structural elements are of the same type. The distinguished types include numerical expressions, individual quoted strings, floating point numbers, address expressions (the expressions enclosed in square brackets or preceded by **ptr** operator), instruction mnemonics, registers, size operators, jump type and code type operators. And each of the special characters that act as a separators, like comma or colon, is the separate type itself. For example, two values, each one consisting of register name followed by comma and numerical expression, will be regarded as of the same type, no matter what kind of register and how complicated numerical expression is used; with exception for the quoted strings and floating point values, which are the special kinds of numerical expressions and are treated as different types. Thus `eax,16 eqtype fs,3+7` condition is true, but `eax,16 eqtype eax,1.6` is false.


## times
**times** directive repeats one instruction specified number of times. It should be followed by numerical expression specifying number of repeats and the instruction to repeat (optionally colon can be used to separate number and instruction). When special symbol **%** is used inside the instruction, it is equal to the number of current repeat. For example `times 5 db %` will define five bytes with values 1, 2, 3, 4, 5. Recursive use of **times** directive is also allowed, so `times 3 times % db %` will define six bytes with values 1, 1, 2, 1, 2, 3.

## repeat
**repeat** directive repeats the whole block of instructions. It should be followed by numerical expression specifying number of repeats. Instructions to repeat are expected in next lines, ended with the **end repeat** directive, for example:
```asm
    repeat 8
        mov byte [bx],%
        inc bx
    end repeat
```
The generated code will store byte values from one to eight in the memory addressed by BX register.
Number of repeats can be zero, in that case the instructions are not assembled at all.

## break
The **break** directive allows to stop repeating earlier and continue assembly from the first line after the **end repeat**. Combined with the **if** directive it allows to stop repeating under some special condition, like:
```asm
    s = x/2
    repeat 100
        if x/s = s
            break
        end if
        s = (s+x/s)/2
    end repeat
```

## while
The **while** directive repeats the block of instructions as long as the condition specified by the logical expression following it is true. The block of instructions to be repeated should end with the **end while** directive. Before each repetition the logical expression is evaluated and when its value is false, the assembly is continued starting from the first line after the **end while**. Also in this case the **%** symbol holds the number of current repeat. The **break** directive can be used to stop this kind of loop in the same way as with **repeat** directive. The previous sample can be rewritten to use the **while** instead of **repeat** this way:
```asm
    s = x/2
    while x/s <> s
        s = (s+x/s)/2
        if % = 100
            break
        end if
    end while
```
The blocks defined with **if**, **repeat** and **while** can be nested in any order, however they should be closed in the same order in which they were started. The **break** directive always stops processing the block that was started last with either the **repeat** or **while** directive.

## org 
**org** directive sets address at which the following code is expected to appear in memory. It should be followed by numerical expression specifying the address. This directive begins the new addressing space, the following code itself is not moved in any way, but all the labels defined within it and the value of $ symbol are affected as if it was put at the given address. However it's the responsibility of programmer to put the code at correct address at run-time.

## load
The **load** directive allows to define constant with a binary value loaded from the already assembled code. This directive should be followed by the name of the constant, then optionally size operator, then **from** operator and a numerical expression specifying a valid address in current addressing space. The size operator has unusual meaning in this case - it states how many bytes (up to 8) have to be loaded to form the binary value of constant. If no size operator is specified, one byte is loaded (thus value is in range from 0 to 255). The loaded data cannot exceed current offset.

## store
The **store** directive can modify the already generated code by replacing some of the previously generated data with the value defined by given numerical expression, which follows. The expression can be preceded by the optional size operator to specify how large value the expression defines, and therefore how much bytes will be stored, if there is no size operator, the size of one byte is assumed. Then the **at** operator and the numerical expression defining the valid address in current addressing code space, at which the given value have to be stored should follow. This is a directive for advanced appliances and should be used carefully.

## load, store
Both **load** and **store** directives in their basic variant (defined above) are limited to operate on places in current addressing space. 

## $
The **$** symbol is the address of current position in that addressing space.

## $$
The **$$** symbol is always equal to the base address of current addressing space.

```asm
    repeat $-$$
        load a byte from $$+%-1
        store byte a xor c at $$+%-1
    end repeat
```

## virtual
**virtual** defines virtual data at specified address. This data will not be included in the output file, but labels defined there can be used in other parts of source. This directive can be followed by at operator and the numerical expression specifying the address for virtual data, otherwise is uses current address, the same as **virtual at $**. Instructions defining data are expected in next lines, ended with **end virtual** directive. The block of virtual instructions itself is an independent addressing space, after it's ended, the context of previous addressing space is restored.
```
    GDTR dp ?
    virtual at GDTR
        GDT_limit dw ?
        GDT_address dd ?
    end virtual
```
It defines two labels for parts of the 48-bit variable at GDTR address.

It can be also used to define labels for some structures addressed by a register, for example:
```asm
    virtual at bx
        LDT_limit dw ?
        LDT_address dd ?
    end virtual
```
With such definition instruction `mov ax,[LDT_limit]` will be assembled to the same instruction as `mov ax,[bx]`.

Declaring defined data values or instructions inside the virtual block could also be useful, because the **load** directive may be used to load the values from the virtually generated code into a constants. This directive in its basic version should be used after the code it loads but before the virtual block ends, because it can only load the values from the same addressing space. For example:
```asm
    virtual at 0
        xor eax,eax
        and edx,eax
        load zeroq dword from 0
    end virtual
```

The above piece of code will define the **zeroq** constant containing four bytes of the machine code of the instructions defined inside the virtual block. This method can be also used to load some binary value from external file. For example this code:
```asm
    virtual at 0
        file 'a.txt':10h,1
        load char from 0
    end virtual
```
loads the single byte from offset 10h in file **a.txt** into the **char** constant.

Instead of or in addition to an **at** argument, **virtual** can also be followed by an **as** keyword and a string defining an extension of additional file where the initialized content of the addressing space started by **virtual** is going to be stored at the end of a successful assembly.
```asm
    virtual at 0 as 'asc'
        times 256 db %-1
    end virtual
```

## align
**align** directive aligns code or data to the specified boundary. It should be followed by a numerical expression specifying the number of bytes, to the multiply of which the current address has to be aligned. The boundary value has to be the power of two.

The **align** directive fills the bytes that had to be skipped to perform the alignment with the **nop** instructions and at the same time marks this area as uninitialized data, so if it is placed among other uninitialized data that wouldn't take space in the output file, the alignment bytes will act the same way. If you need to fill the alignment area with some other values, you can combine **align** with **virtual** to get the size of alignment needed and then create the alignment yourself, like:

```asm
    virtual
        align 16
        a = $ - $$
    end virtual
    db a dup 0
```

## display
**display** directive displays the message at the assembly time. It should be followed by the quoted strings or byte values, separated with commas. It can be used to display values of some constants, for example:

```asm
    bits = 16
    display 'Current offset is 0x'
    repeat bits/4
        d = '0' + $ shr (bits-%*4) and 0Fh
        if d > '9'
            d = d + 'A'-'9'-1
        end if
        display d
    end repeat
    display 13,10
```
This block of directives calculates the four hexadecimal digits of 16-bit value and converts them into characters for displaying. Note that this will not work if the adresses in current addressing space are relocatable (as it might happen with PE or object output formats), since only absolute values can be used this way. The absolute value may be obtained by calculating the relative address, like `$-$$`, or `rva $` in case of PE format.

## err
The **err** directive immediately terminates the assembly process when it is encountered by assembler.

## assert
The **assert** directive tests whether the logical expression that follows it is true, and if not, it signalizes the error.

## include
**include** directive includes the specified source file at the position where it is used. It should be followed by the quoted name of file that should be included, for example:
```asm
    include 'macros.inc'
```
The whole included file is preprocessed before preprocessing the lines next to the line containing the **include** directive. There are no limits to the number of included files as long as they fit in memory.

The quoted path can contain environment variables enclosed within % characters, they will be replaced with their values inside the path, both the \ and / characters are allowed as a path separators. The file is first searched for in the directory containing file which included it and when it is not found there, the search is continued in the directories specified in the environment variable called INCLUDE (the multiple paths separated with semicolons can be defined there, they will be searched in the same order as specified). If file was not found in any of these places, preprocessor looks for it in the directory containing the main source file (the one specified in command line). These rules concern also paths given with the **file** directive.

## equ
The symbolic constants are different from the numerical constants, before the assembly process they are replaced with their values everywhere in source lines after their definitions, and anything can become their values.

The definition of symbolic constant consists of name of the constant followed by the equ directive. Everything that follows this directive will become the value of constant. If the value of symbolic constant contains other symbolic constants, they are replaced with their values before assigning this value to the new constant. For example:
```asm
    d equ dword
    NULL equ d 0
    d equ edx
```
After these three definitions the value of `NULL` constant is `dword 0`and the value of `d` is `edx`. So, for example, `push NULL` will be assembled as `push dword 0` and `push d` will be assembled as `push edx`. And if then the following line was put:
```asm
    d equ d,eax
```
the `d` constant would get the new value of `edx,eax`. This way the growing lists of symbols can be defined.

## restore
**restore** directive allows to get back previous value of redefined symbolic constant. It should be followed by one more names of symbolic constants, separated with commas. So `restore d` after the above definitions will give d constant back the value `edx`, the second one will restore it to value `dword`, and one more will revert `d` to original meaning as if no such constant was defined. If there was no constant defined of given name, **restore** will not cause an error, it will be just ignored.

## define
The **define** directive followed by the name of constant and then the value, is the alternative way of defining symbolic constant. The only difference between **define** and **equ** is that **define** assigns the value as it is, it does not replace the symbolic constants with their values inside it.

## fix
Symbolic constants can also be defined with the **fix** directive, which has the same syntax as **equ**, but defines constants of high priority - they are replaced with their symbolic values even before processing the preprocessor directives and macroinstructions, the only exception is **fix** directive itself, which has the highest possible priority, so it allows redefinition of constants defined this way.

The **fix** directive can be used for syntax adjustments related to directives of preprocessor, what cannot be done with **equ** directive. For example:
```asm
    incl fix include
```
defines a short name for **include** directive, while the similar definition done with **equ** directive wouldn't give such result, as standard symbolic constants are replaced with their values after searching the line for preprocessor directives.

## macro
**macro** directive allows you to define your own complex instructions, called macroinstructions, using which can greatly simplify the process of programming. In its simplest form it's similar to symbolic constant definition. For example the following definition defines a shortcut for the `test al,0xFF` instruction:
```asm
    macro tst {test al,0xFF}
```

## struc
**struc** directive is a special variant of **macro** directive that is used to define data structures. Macroinstruction defined using the **struc** directive must be preceded by a label (like the data definition directive) when it's used. This label will be also attached at the beginning of every name starting with dot in the contents of macroinstruction. The macroinstruction defined using the **struc** directive can have the same name as some other macroinstruction defined using the **macro** directive, structure macroinstruction will not prevent the standard macroinstruction from being processed when there is no label before it and vice versa. All the rules and features concerning standard macroinstructions apply to structure macroinstructions.

Here is the sample of structure macroinstruction:
```asm
    struc point x,y
     {
        .x dw x
        .y dw y
     }
 ```

For example `my point 7,11` will define structure labeled `my`, consisting of two variables: `my.x` with value 7 and `my.y` with value 11.

## rept
The **rept** directive is a special kind of macroinstruction, which makes given amount of duplicates of the block enclosed with braces. The basic syntax is **rept** directive followed by number. and then block of source enclosed between the { and } characters. The simplest example:
```asm
    rept 5 { in al,dx }
```
will make five duplicates of the `in al,dx` line. The block of instructions is defined in the same way as for the standard macroinstruction and any special operators and directives which can be used only inside macroinstructions are also allowed here. When the given count is zero, the block is simply skipped, as if you defined macroinstruction but never used it. The number of repetitions can be followed by the name of counter symbol, which will get replaced symbolically with the number of duplicate currently generated. So this:
```asm
    rept 3 counter
     {
        byte#counter db counter
     }
```
will generate lines:
```asm
    byte1 db 1
    byte2 db 2
    byte3 db 3
```

The repetition mechanism applied to **rept** blocks is the same as the one used to process multiple groups of arguments for macroinstructions, so directives like **forward**, **common** and **reverse** can be used in their usual meaning. Thus such macroinstruction:
```asm
    rept 7 num { reverse display `num }
```
will display digits from 7 to 1 as text. The **local** directive behaves in the same way as inside macroinstruction with multiple groups of arguments, so:
```asm
    rept 21
     {
       local label
       label: loop label
     }
```
will generate unique label for each duplicate.

## match
**match** directive causes some block of source to be preprocessed and passed to assembler only when the given sequence of symbols matches the specified pattern. The pattern comes first, ended with comma, then the symbols that have to be matched with the pattern, and finally the block of source, enclosed within braces as macroinstruction. There are the few rules for building the expression for matching, first is that any of symbol characters and any quoted string should be matched exactly as is. In this example:
```asm
    match +,+ { include 'first.inc' }
    match +,- { include 'second.inc' }
```
the first file will get included, since + after comma matches the + in pattern, and the second file will not be included, since there is no match.

## format
**format** directive followed by the format identifier allows to select the output format. This directive should be put at the beginning of the source. It can always be followed in the same line by the as keyword and the quoted string specifying the default file extension for the output file. Unless the output file name was specified from the command line, assembler will use this extension when generating the output file.

Default output format is a flat binary file, it can also be selected by using `format binary` directive. 

## use16, use32, use64
**use16** and **use32** directives force the assembler to generate 16-bit or 32-bit code, omitting the default setting for selected output format. use64 enables generating the code for the long mode of x86-64 processors.

## section
**section** directive defines a new section, it should be followed by quoted string defining the name of section, then one or more section flags can follow. Available flags are: **code**, **data**, **readable**, **writeable**, **executable**, **shareable**, **discardable**, **notpageable**. The origin of section is aligned to page (4096 bytes). Example declaration of PE section:
```asm
    section '.text' code readable executable
```
Among with flags also one of the special PE data identifiers can be specified to mark the whole section as a special data, possible identifiers are **export**, **import**, **resource** and **fixups**. If the section is marked to contain fixups, they are generated automatically and no more data needs to be defined in this section. Also resource data can be generated automatically from the resource file, it can be achieved by writing the **from** operator and quoted file name after the `resource` identifier. Below are the examples of sections containing some special PE data:
```asm
    section '.reloc' data readable discardable fixups
    section '.rsrc' data readable resource from 'my.res'
```

## section
**entry** directive sets the entry point for Portable Executable, the value of entry point should follow.

## stack
**stack** directive sets up the size of stack for Portable Executable, value of stack reserve size should follow, optionally value of stack commit separated with comma can follow. When stack is not defined, it's set by default to size of 4096 bytes.

## heap
**heap** directive chooses the size of heap for Portable Executable, value of heap reserve size should follow, optionally value of heap commit separated with comma can follow. When no heap is defined, it is set by default to size of 65536 bytes, when size of heap commit is unspecified, it is by default set to zero.

## data
**data** directive begins the definition of special PE data, it should be followed by one of the data identifiers (**export**, **import**, **resource** or **fixups**) or by the number of data entry in PE header. The data should be defined in next lines, ended with **end data** directive. When fixups data definition is chosen, they are generated automatically and no more data needs to be defined there. The same applies to the resource data when the **resource** identifier is followed by **from** operator and quoted file name - in such case data is taken from the given resource file.

## rva
The **rva** operator can be used inside the numerical expressions to obtain the RVA of the item addressed by the value it is applied to, that is the offset relative to the base of PE image.

## extrn
**extrn** directive defines the external symbol, it should be followed by the name of symbol and optionally the size operator specifying the size of data labeled by this symbol. The name of symbol can be also preceded by quoted string containing name of the external symbol and the **as** operator. Some example declarations of external symbols:
```asm
    extrn exit
    extrn '__imp__MessageBoxA@16' as MessageBox:dword
```

## public
**public** directive declares the existing symbol as public, it should be followed by the name of symbol, optionally it can be followed by the as operator and the quoted string containing name under which symbol should be available as public. Some examples of public symbols declarations:
```asm
    public main
    public start as '_start'
```

Additionally, with COFF format it's possible to specify exported symbol as static, it's done by preceding the name of symbol with the **static** keyword.

When using the Microsoft's COFF format, the **rva** operator can be used inside the numerical expressions to obtain the RVA of the item addressed by the value it is applied to.

