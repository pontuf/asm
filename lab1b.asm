%include "io.inc"
section .data
A times 120 dd 0
sizeA equ $-A

value dd 250
count dd 100
step dd 5
 
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax, eax
    
    ;count definition
    mov eax,sizeA
    mov ecx,4
    div ecx
    mov [count],eax
    xor eax,eax
    
    ;main cycle
    mov ecx,[count]
    CYCLE:
        mov eax,[value]
        add eax,[step]
        mov [value],eax
        
        mov ebx,[count]
        sub ebx,ecx
        lea eax,[A+ebx*4]
        
        mov ebx,[value]
        mov [eax],ebx
        loop CYCLE
        
    mov ecx,0
    OUTPUT:       
        lea eax,[A+ecx*4]
        
        PRINT_STRING "A["
        PRINT_UDEC 4, ecx
        PRINT_STRING "] = "
        PRINT_DEC 4, [eax]
        NEWLINE
        inc ecx
        cmp ecx,[count]
        jnz OUTPUT
    ret