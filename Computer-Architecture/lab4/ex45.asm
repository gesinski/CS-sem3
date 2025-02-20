public suma_siedmiu_liczb

.code
suma_siedmiu_liczb PROC
    ; Zerowanie rejestru wynikowego
    mov rax, rcx          ; Pierwszy argument do rax
    add rax, rdx          ; Dodanie drugiego argumentu
    add rax, r8           ; Dodanie trzeciego argumentu
    add rax, r9           ; Dodanie czwartego argumentu

    ; Dodanie argumentów przekazanych przez stos
    mov rbx, [rsp + 40]    ; Pi¹ty argument (pierwszy na stosie)
    add rax, rbx

    mov rbx, [rsp + 48]   ; Szósty argument (drugi na stosie)
    add rax, rbx

    mov rbx, [rsp + 56]   ; Siódmy argument (trzeci na stosie)
    add rax, rbx

    ret                   ; Zwracanie wyniku w rax
suma_siedmiu_liczb ENDP
END
