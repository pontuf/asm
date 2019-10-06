%include "io.inc"
section .data
a dq -56.0
b dq 11.0
c dq -44.0
two dq 2.0
fmt db "%.3f ", 10,13,0
cf db "%.3f",0
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax, eax
    finit
    
    push dword [a+4]
    push dword [a];-8 | 24
    push dword [b+4]
    push dword [b];-16 | 16
    push dword [c+4]
    push dword [c];-24 | 8
    push dword [two+4]
    push dword [two];-32 | 0 
    
    ;BEGIN
    
    ;4
    fld qword [esp]
    fmul st0
    
    ;4c
    fld qword [esp+8]
    fmul st0,st1
    
    ;4ac
    fld qword [esp+24]
    fmul st0,st1 ;st2
    
    ;b^2
    fld qword [esp+16]
    fmul st0 ;st3
    
    ;b^2-4ac
    fsub st0,st1
    
    ;case
    fldz ;st4
    fcom st0,st1
    fstsw ax
    sahf
    ja COMPLEX
    
    ;DUO
    fstp st0
    fsqrt
    fld qword [esp+24] ; st5
    fld qword [esp+16] ; st6
    fchs
    fld st0 ; 1
    fadd st0,st3
    fxch st4
    fstp st0
    fsub st0,st2
    fxch st4
    fstp st0
    ;2,3
    fxch
    fstp st0
    fld qword [esp]
    ;2,3
    fmul st0,st1
    fxch st4
    fstp st0 ;1,2
    fstp st0 ;0,1
    fdiv st0,st2
    fxch st3
    fstp st0
    fdiv st0,st1
    ;0,2
    fxch
    fstp st0
    ;finish
    add esp,32 ; release stack
    
    fcom st0,st1 ; check for mono case
    fstsw ax
    sahf
    jz MONO
    
    ;output
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push fmt
    call printf
    add esp, 12
MONO:
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push fmt
    call printf
    add esp, 12
    jmp END
    
COMPLEX:
    fstp st0 
    fchs
    fsqrt
    fxch st3 
    fstp st0 ;2
    fstp st0 ;1
    fstp st0 ;0
    
    ;2a
    fld qword [esp+24]
    fld qword [esp]
    fmul st0,st1 ;st2
    
    fld qword [esp+16] ;st3
    fchs
    fdiv st0,st1 ;st1 st3
    fxch st4 ;st1 st3 st4
    fstp st0 ;st0 st2 st3
    fxch st4 ;st2 st3 st4 sqrt(D) -b/2a 2a
    fstp st0 ;st1 st2 st3 sqrt(D) -b/2a 2a
    fstp st0 ;st0 st1 st2 sqrt(D) -b/2a 2a
    
    fld st0 ;st0 st1 st2 st3
    fdiv st0,st3
    fxch st4 ; st1 st2 st3 st4 sqrt(D) -b/2a 2a K
    fstp st0 ; st0 st1 st2 st3 sqrt(D) -b/2a 2a K
    fchs
    fdiv st0,st2
    fxch st4 ; st1 st2 st3 st4 -b/2a 2a K -K
    fstp st0 ; st0 st1 st2 st3 -b/2a 2a K -K
    fxch
    fstp st0 ; st0 st1 st2 -b/2a K -K
    fld st0 ; st0 st1 st2 st3 -b/2a -b/2a K -K
    fxch st3 ; st0 st1 st2 st3 -K -b/2a K -b/2a
    fxch st4
    fstp st0 ; -b/2a K -b/2a -K 
    
    ;output
    add esp,32
    
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push cf
    call printf
    add esp, 12
    
    PRINT_STRING " + j("
    
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push cf
    call printf
    add esp, 12
    
    PRINT_STRING ")"
    NEWLINE
    
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push cf
    call printf
    add esp, 12
    
    PRINT_STRING " + j("
    
    fstp qword [a]
    push dword [a+4]
    push dword [a]
    push cf
    call printf
    add esp, 12
    
    PRINT_STRING ")"
                                              
END:
    ret