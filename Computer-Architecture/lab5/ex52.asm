.686
.model flat
public _nowy_exp

.data

.code
_nowy_exp PROC
	finit                   ; Inicjalizacja FPU
    push ebp
    mov ebp, esp
    fld dword ptr [ebp+8]
    mov ecx, 18
    mov ebx, 1
    mov eax, 1
    fld1
    fadd st(0), st(1) ; 1 + x/1
    inc ebx
    mul ebx
ptl:
    push eax
    fild dword ptr [esp] ; n!
    fld dword ptr [ebp+8] ; st(0) = x
    fmul st(0), st(3) ; x*x^(n-1)
    fstp st(3) ; usuniecie x
    fld st(2) ; st(0) = x^n
    fdiv st(0), st(1) ; x^n/n!
    faddp st(2), st(0) ; dodanie do sumy
    fstp st(0)
    inc ebx
    mul ebx
    loop ptl
koniec:
    add esp, 72
    pop ebp
    ret
_nowy_exp ENDP

end