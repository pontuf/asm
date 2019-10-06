%include "io.inc"
section .data
a dq 5.0
b dq 9.4
c dq 4.5
d dq 5.6
x dq -1.734
fmt db "%f ", 10,13,0
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging        
    ;write your code here
    xor eax, eax 
    finit  
    
    push a ;20
    push b ;16
    push c ;12
    push d ;8
    push x ;4
    
    call polynomial 
    add esp,20
    
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push fmt
    call printf
    add esp, 12
    ret
    
polynomial:
        ;cx
        mov edx,[esp+4]
        fld qword [edx]
        mov edx,[esp+12]
        fld qword [edx]
        fmul st0,st1
        
        ;bx^2
        mov edx,[esp+16]
        fld qword [edx]
        fmul st0,st2
        fmul st0,st2
        
        ;ax^3
        mov edx,[esp+20]
        fld qword [edx]
        fmul st0,st3
        fmul st0,st3
        fmul st0,st3
        
        ;d+sum
        mov edx,[esp+8]
        fld qword [edx]
        fadd st0,st1
        fadd st0,st2
        fadd st0,st3
        ret
