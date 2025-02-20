.686
.model flat
public _srednia_wazona

.data
.code
_srednia_wazona PROC
    finit                   ; Inicjalizacja FPU
    push ebp
    mov ebp, esp
    ;ebp+16 - tablica_dane
    mov ebx, [ebp+8]
    ;ebp+12 - tablica_wagi
    mov edx, [ebp+12]
    ;ebp+8 - liczba  elementow
    mov ecx, [ebp+16]

    fld qword ptr [edx] ; inicjalizacja sumy wag

    ; Za³aduj pierwszy element
    fld qword ptr [ebx]     ; Za³aduj element
    fld qword ptr [edx]        ; zaladuj wage
    fmulp st(1), st(0)       ; mnozy wage przez liczbe

    add ebx, 8              ; PrzejdŸ do nastêpnego elementu
    add edx, 8
    dec ecx

ptl:
    fld qword ptr [ebx]     ; Za³aduj element
    fld qword ptr [edx]        ; zaladuj wage
    fadd st(3), st(0)       ; dodaj wage do sumy wag
    fmulp st(1), st(0)       ; mnozy wage przez liczbe      
    faddp st(1), st(0)       ; Dodaj liczbe do sumy
    add ebx, 8              ; PrzejdŸ do nastêpnego elementu
    add edx, 8
    dec ecx                 ; Zmniejsz licznik
    jnz ptl                 ; Jeœli jeszcze s¹ elementy, powtarzaj pêtlê

koniec:
    ; Oblicz œredni¹
    fdiv st(0), st(1)       ; Podziel sume 
    pop ebp
    ret
_srednia_wazona ENDP

end