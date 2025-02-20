; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main
.data
	tekst_pocz db 10, 'Prosze napisac jakis tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?
	tytul db 'wyswietlanie liczb' 
.code
_main PROC
; wyœwietlenie tekstu informacyjnego
; liczba znaków tekstu
	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	 call __write ; wyœwietlenie tekstu pocz¹tkowego
	 add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zosta³y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbê
; wprowadzonych znaków
	mov liczba_znakow, eax
; rejestr ECX pe³ni rolê licznika obiegów pêtli
	; mov ecx, eax
	 ;mov ebx, 0 ; indeks pocz¹tkowy
;ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
;	 cmp dl, 'a'
;	 jb dalej ; skok, gdy znak nie wymaga zamiany
;	 cmp dl, 'z'
;	 ja dalej ; skok, gdy znak nie wymaga zamiany
;	 sub dl, 20H ; zamiana na wielkie litery
;	; odes³anie znaku do pamiêci
;	 mov magazyn[ebx], dl
	
dalej: 
	;inc ebx ; inkrementacja indeksu
	;dec ecx
	;jnz ptl ; sterowanie pêtl¹ (jnz = jne)
; wyœwietlenie przekszta³conego tekstu
	push 0 
	push OFFSET tytul
	 push OFFSET magazyn
	 push 0
	 call _MessageBoxA@16 ; wyœwietlenie przekszta³conego tekstu
	 add esp, 12 ; usuniecie parametrów ze stosu
	 push 0
	 call _ExitProcess@4 ; zakoñczenie programu
;pl_a:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_c:
;	add dl, 9
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_e:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_l:
;	add dl, 21b
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_n:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_o:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_s:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_x:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej
;pl_z:
;	dec dl
;	mov magazyn[ebx], dl
;	jnz dalej

_main ENDP
END
