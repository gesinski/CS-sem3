.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreúlenia)
extern _MessageBoxA@16 : PROC
extern __read : PROC ; (dwa znaki podkreúlenia)
public _main
.data
tekst_pocz db 10, 'Prosze napisac jakis tekst '
db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
.code
_main PROC
 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urzπdzenia (tu: ekran - nr 1)
 call __write ; wyúwietlenie tekstu poczπtkowego
 add esp, 12 ; usuniecie parametrÛw ze stosu
; czytanie wiersza z klawiatury
 push 80 ; maksymalna liczba znakÛw
 push OFFSET magazyn
 push 0 ; nr urzπdzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znakÛw z klawiatury
 add esp, 12 ; usuniecie parametrÛw ze stosu
; kody ASCII napisanego tekstu zosta≥y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbÍ
; wprowadzonych znakÛw
 mov liczba_znakow, eax
; rejestr ECX pe≥ni rolÍ licznika obiegÛw pÍtli
 mov ecx, eax
 mov ebx, 0 ; indeks poczπtkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
 cmp dl, 'a'
 jae litera_mala
 cmp dl, 'A'
 jae litera_duza
 
 mov magazyn[ebx], dl
 jnz inny_znak
 mov dl, 2ah
; odes≥anie znaku do pamiÍci
 mov magazyn[ebx], dl
 jnz dalej
litera_mala:
	cmp dl, 'z'
	ja inny_znak
	sub dl, 20h
	mov magazyn[ebx], dl
	jnz dalej
	
litera_duza:
	cmp dl, 'Z'
	ja inny_znak
	add dl, 20h
	mov magazyn[ebx], dl
	jnz dalej

inny_znak:
	cmp dl, 'π'
	je litera_pl_a
	cmp dl, 086H
	je litera_pl_c
	cmp dl, 'Í'
	je litera_pl_e
	cmp dl, '≥'
	je litera_pl_l
	cmp dl, 'Ò'
	je litera_pl_n
	cmp dl, 'Û'
	je litera_pl_o
	cmp dl, 'ú'
	je litera_pl_s
	cmp dl, 'ü'
	je litera_pl_x
	cmp dl, 'ø'
	je litera_pl_z
	cmp dl, '•'
	je litera_pl_A_
	cmp dl, '∆'
	je litera_pl_C_
	cmp dl, ' '
	je litera_pl_E_
	cmp dl, '£'
	je litera_pl_L_
	cmp dl, '—'
	je litera_pl_N_
	cmp dl, '”'
	je litera_pl_O_
	cmp dl, 'å'
	je litera_pl_S_
	cmp dl, 'è'
	je litera_pl_X_
	cmp dl, 'Ø'
	je litera_pl_Z_
	;gdy nie wystepuje
	mov dl, 2ah
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_a:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_c:
	mov dl, 0c6h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_e:
	mov dl, 0cah
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_l:
	mov dl, 0a3h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_n:
	mov dl, 0d1h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_o:
	mov dl, 0d3h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_s:
	mov dl, 8ch
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_x:
	mov dl, 8fh
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_z:
	mov dl, 0afh
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_A_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej
litera_pl_C_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_E_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_L_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_N_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_O_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_S_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_X_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej

litera_pl_Z_:
	mov dl, 0a5h
	mov magazyn[ebx], dl
	jnz dalej
	


dalej: inc ebx ; inkrementacja indeksu
 dec ecx
jnz ptl ; sterowanie pÍtlπ
; wyúwietlenie przekszta≥conego tekstu
 push 0
 push offset magazyn
 push OFFSET magazyn
 push 0
 call _MessageBoxA@16 ; wyúwietlenie przekszta≥conego tekstu
 add esp, 12 ; usuniecie parametrÛw ze stosu
 push 0
 call _ExitProcess@4 ; zakoÒczenie programu
_main ENDP
END