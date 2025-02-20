.686
.model flat
public _srednia_harm

.data
.code
_srednia_harm PROC
    finit                   ; Inicjalizacja FPU
    push ebp
    mov ebp, esp
    mov ecx, [ebp+12]       ; liczba elementów tablicy
    mov ebx, [ebp+8]        ; wskaŸnik do tablicy

    ; Sprawdzenie, czy liczba elementów wynosi 0
    cmp ecx, 0
    je koniec               ; Jeœli 0, zakoñcz dzia³anie

    fldz

    ; Za³aduj pierwszy element i oblicz odwrotnoœæ
    fld dword ptr [ebx]     ; Za³aduj pierwszy element
    fld1
    fdiv st(0), st(1)       ; Dziel 1.0 przez pierwszy element (odwrotnoœæ)

    ; PrzejdŸ do nastêpnego elementu
    add ebx, 4
    dec ecx                 ; Zmniejsz licznik
    jz koniec               ; Jeœli nie ma wiêcej elementów, zakoñcz

ptl:
    fld dword ptr [ebx]     ; Za³aduj kolejny element
    fld1
    fdiv st(0), st(1)
    fstp st(1)            
    fadd st(0), st(1)       ; Dodaj odwrotnoœæ do sumy
    add ebx, 4              ; PrzejdŸ do nastêpnego elementu
    dec ecx                 ; Zmniejsz licznik
    jnz ptl                 ; Jeœli jeszcze s¹ elementy, powtarzaj pêtlê

koniec:
    ; Oblicz œredni¹ harmoniczn¹
    fild dword ptr [ebp+12] ; Za³aduj liczbê elementów n
    fdiv st(0), st(1)       ; Podziel n przez sumê odwrotnoœci

    pop ebp
    ret
_srednia_harm ENDP

end