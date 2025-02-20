.686
.model flat
extern __write : PROC           ; Procedura do wyœwietlania
extern __read : PROC            ; Procedura do wczytywania
extern _ExitProcess@4 : PROC    ; Procedura zakoñczenia programu
public _main

.data
dekoder db '0123456789ABCDEF'   ; Tablica do konwersji na szesnastkowy
obszar db 12 dup (?)            ; Bufor na wczytane znaki
dziesiec dd 10                  ; Sta³a do mno¿enia przez 10

.code

; G³ówna procedura programu
_main PROC
    call wczytaj_do_EAX          ; Wywo³aj procedurê wczytania liczby

    ; Wywo³anie procedury wyœwietlania liczby w formacie szesnastkowym
    call wyswietl_EAX_hex

    ; Zakoñczenie programu
    push 0                       ; Kod zakoñczenia 0
    call _ExitProcess@4          ; Zakoñcz program
_main ENDP

; Podprogram do wczytywania liczby dziesiêtnej z klawiatury i zapisania jej w EAX
wczytaj_do_EAX PROC
    ; Zapisanie rejestrów, które bêd¹ modyfikowane
    push ebx
    push ecx

    ; Maksymalna liczba cyfr do wczytania
    push dword PTR 12
    push dword PTR OFFSET obszar ; Adres bufora
    push dword PTR 0             ; Urz¹dzenie (0 = klawiatura)
    call __read                  ; Odczyt z klawiatury
    add esp, 12                  ; Usuniêcie parametrów ze stosu

    ; Ustawienie wartoœci pocz¹tkowej dla EAX
    mov eax, 0
    mov ebx, OFFSET obszar       ; Adres bufora

pobieraj_znaki:
    mov cl, [ebx]                ; Pobierz kolejny znak ASCII
    inc ebx                      ; Przesuniêcie indeksu
    cmp cl, 0Dh                  ; Sprawdzenie czy naciœniêto Enter
    je byl_enter                 ; Skok, gdy naciœniêto Enter

    sub cl, 30H                  ; Konwersja ASCII -> cyfra
    movzx ecx, cl                ; Przechowanie cyfry w ECX

    ; Mno¿enie poprzedniej wartoœci przez 10 i dodanie cyfry
    imul eax, eax, 10
    add eax, ecx                 ; Dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki           ; Skok na pocz¹tek pêtli

byl_enter:
    ; Przywracanie rejestrów
    pop ecx
    pop ebx

    ret                          ; Powrót, wynik w EAX
wczytaj_do_EAX ENDP

; Podprogram do wyœwietlania zawartoœci rejestru EAX jako liczby szesnastkowej
wyswietl_EAX_hex PROC
    pusha                         ; Zapisanie wszystkich rejestrów

    ; Rezerwacja 12 bajtów na stosie dla cyfr szesnastkowych
    sub esp, 12
    mov edi, esp                 ; Ustawienie adresu zarezerwowanego obszaru

    ; Przygotowanie konwersji
    mov ecx, 8                   ; Liczba cykli pêtli (8 dla 32-bitowego EAX)
    mov esi, 1                   ; Indeks startowy do zapisu cyfr

konwersja_hex:
    mov ebx, eax                 ; Kopiowanie EAX do EBX
    and ebx, 0Fh                 ; Wyodrêbnienie 4 najm³odszych bitów (pojedyncza cyfra szesnastkowa)
    mov dl, dekoder[ebx]         ; Pobranie cyfry z tablicy `dekoder`
    mov [edi + esi], dl          ; Zapis cyfry do zarezerwowanego obszaru
    inc esi                      ; Przejœcie do nastêpnej pozycji

    shr eax, 4                   ; Przesuniêcie o 4 bity w prawo (kolejna cyfra szesnastkowa)
    loop konwersja_hex           ; Pêtla konwersji

    ; Wstawienie znaków nowej linii przed i po cyfrze
    mov byte PTR [edi][0], 10
    mov byte PTR [edi][9], 10

    ; Wyœwietlenie przygotowanych cyfr
    push 10                      ; 8 cyfr + 2 znaki nowej linii
    push edi                     ; Adres obszaru roboczego
    push 1                       ; Numer urz¹dzenia (1 = ekran)
    call __write                 ; Wywo³anie __write do wyœwietlenia
    add esp, 24                  ; Czyszczenie stosu

    popa                         ; Przywracanie rejestrów
    ret                          ; Powrót z podprogramu
wyswietl_EAX_hex ENDP

END
