%include "io.inc"
section .data
ans dq 0.0
x0 dq -2.0
x1 dq 0.0
c dq -2.0
d dq 1.0 
temp1 dq 0.0
temp2 dq 0.0
delta dq 0.0
accuracy dq 0.000001
fmt db "%.3f ", 10,13,0
fmt2 db "%f", 10,13,0
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    ; atan(x^3-2*x+1)
    ;x1=x1-((f(x1)*(x1-x0))/(f(x1)-f(x0)))
    xor eax, eax
    finit
    
    mov ecx,11
CYCLE:
    ;(f(x0)
    push x0;4
    call polynom
    add esp,4
    fstp qword [temp2]
    finit
    
    ;(f(x1)
    push x1;4
    call polynom
    add esp,4
    fstp qword [temp1]
    ;(f(x1)-f(x0)
    finit
    fld qword [temp2]
    fld qword [temp1]
    fsub st0,st1
    fstp qword [temp2]
    finit
    
    ;f(x1)*(x1-x0)
    fld qword [temp1]
    fld qword [x0]
    fld qword [x1]
    fsub st0,st1
    fmul st0,st2
    fstp qword [temp1]
    finit
    
    ;(f(x1)*(x1-x0))/(f(x1)-f(x0))
    fld qword [temp2]
    fld qword [temp1]
    fdiv st1
    
    ;x1-((f(x1)*(x1-x0))/(f(x1)-f(x0)))
    fld qword [x1]
    fsub st0,st1
    
    ;update x1
    fld qword [x1]
    fsub st0,st1
    fstp qword [delta]
    fstp qword [x1]
   
    ;check delta
    finit
    fld qword [accuracy]
    fld qword [delta]
    fabs
    fucomi st0,st1
    jna ANSWER
    
    ;check limit
    dec ecx
    cmp ecx,0
    jnz CYCLE
    
ANSWER:  
    push dword [x1+4]
    push dword [x1]
    push fmt
    call printf
    add esp, 12
    ret

polynom:
        xor edx,edx
        
        ;2x
        mov edx,[esp+4]
        fld qword [edx]
        fld qword [c]
        fmul st0,st1
        
        ;x^3
        mov edx,[esp+4]
        fld qword [edx]
        fmul st0,st2
        fmul st0,st2
        
        ;d+sum
        fld qword [d]
        fadd st0,st1
        fadd st0,st2
        
        ;for fpatan
        fld qword [d]
        fpatan
        ret