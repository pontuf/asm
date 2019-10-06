%include "io.inc"
section .bss
a resd 1 
b resd 1
section .data
msg db "НОД равно ",0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    ;write your code here
    GET_DEC 4,[a]
    GET_DEC 4,[b]
    xor eax, eax
    CYCLE:
        mov eax,[a]
        cmp eax,[b]
        jz END
        jl REVERSE
        sub eax,[b]
        mov [a],eax
        jmp CYCLE
    REVERSE:
        mov eax,[b]
        sub eax,[a]
        mov [b],eax
        jmp CYCLE
    END:
        PRINT_STRING msg
        PRINT_DEC 4,eax
    ret