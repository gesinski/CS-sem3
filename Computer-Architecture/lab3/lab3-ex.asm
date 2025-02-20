;lab3
;data: 4.10.24
.686
.model flat
extern __write : PROC           ; Procedura do wyœwietlania
extern __read : PROC            ; Procedura do wczytywania
extern _ExitProcess@4 : PROC    ; Procedura zakoñczenia programu
public _main

.data
znaki db 12 dup (0)             ; Bufor na tekst do wyœwietlenia
obszar db 12 dup (?)            ; Bufor na wczytane znaki
dziesiec dd 10                  ; Sta³a do mno¿enia przez 10

.code

; G³ówna procedura programu
_main PROC
    call wczytaj_do_EAX          ; Wywo³aj procedurê wczytania liczby



    call wyswietl_EAX            ; Wywo³anie procedury wyœwietlania

koniec:
    push 0                       ; Kod zakoñczenia 0
    call _ExitProcess@4          ; Zakoñcz program
_main ENDP

; Podprogram do wczytywania liczby dziesiêtnej z klawiatury i zapisania jej w EAX
wczytaj_do_EAX PROC
    ; Zapisanie rejestrów, które bêd¹ modyfikowane
    push ebx
    push ecx

    push dword PTR 12
    push dword PTR OFFSET obszar ; adres obszaru pamiêci
    push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
    call __read ; odczytywanie znaków z klawiatury; (dwa znaki podkreœlenia przed read)
    
    add esp, 12 ; usuniêcie parametrów ze stosu
    ; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
    ; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
    
    mov eax, 0
    mov ebx, OFFSET obszar ; adres obszaru ze znakami
   
   pobieraj_znaki:
    
    mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
    ; ASCII
    inc ebx ; zwiêkszenie indeksu
    cmp cl,10 ; sprawdzenie czy naciœniêto Enter
    je byl_enter ; skok, gdy naciœniêto Enter
    sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
    movzx ecx, cl ; przechowanie wartoœci cyfry w
    ; rejestrze ECX
    ; mno¿enie wczeœniej obliczonej wartoœci razy 10
    
    mul dword PTR dziesiec
    add eax, ecx ; dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki ; skok na pocz¹tek pêtli
   
   byl_enter:
    
    ; wartoœæ b
    ; Przywracanie rejestrów
    pop ecx
    pop ebx

    ret                          ; Powrót, wynik w EAX
wczytaj_do_EAX ENDP

; Podprogram do wyœwietlenia liczby z EAX
wyswietl_EAX PROC
    pusha                         ; Zachowaj wszystkie rejestry

    mov esi, 10                  ; Indeks koñca bufora `znaki`
    mov ebx, 8                  ; Dzielnik 8 do konwersji na osemkowy
konwersja:
    mov edx, 0                   ; Zerowanie górnej czêœci dla dzielenia
    div ebx                      ; Podzielenie EAX przez 8 -> wynik w EAX, reszta w EDX
    add dl, '0'                  ; Konwersja reszty na ASCII
    mov znaki[esi], dl           ; Przechowanie cyfry ASCII w buforze
    dec esi                      ; Przesuniêcie na poprzednie miejsce w buforze
    cmp eax, 0                   ; Sprawdzenie, czy wynik to zero
    jne konwersja                ; Pêtla, jeœli s¹ kolejne cyfry do konwersji

    ; Wype³nienie bufora spacjami, jeœli s¹ nieu¿ywane miejsca
wypeln:
    cmp esi, 1                   ; Upewniamy siê, ¿e nie przekroczymy zakresu
    jl wyswietl                  ; Skok, jeœli osi¹gniêto pocz¹tek
    mov byte ptr znaki[esi], ' ' ; Wype³nienie spacj¹
    dec esi                      ; Przesuniêcie na poprzednie miejsce
    jmp wypeln                   ; Pêtla wype³niania

wyswietl:
    mov byte PTR znaki[0], 0Ah    ; Nowa linia na pocz¹tku
    mov byte PTR znaki[11], 0Ah   ; Nowa linia na koñcu

    push dword PTR 12             ; D³ugoœæ bufora (12 bajtów)
    push dword PTR OFFSET znaki   ; Adres bufora `znaki`
    push dword PTR 1              ; Numer urz¹dzenia (1 = ekran)
    call __write                  ; Wywo³anie __write do wyœwietlenia
    add esp, 12                   ; Czyszczenie stosu

    popa                          ; Przywrócenie wszystkich rejestrów
    ret
wyswietl_EAX ENDP

END
