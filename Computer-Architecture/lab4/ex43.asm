.686
.model flat

public _odejmij_jeden

comment |
Poni¿szy program w jêzyku C wczytuje liczbê ca³kowit¹ z klawiatury, nastêpnie
zmniejsza j¹ o 1 i wyœwietla na ekranie wynik obliczenia. Zmniejszenie liczby o 1 wykonuje
podprogram zakodowany w asemblerze, przystosowany do wywo³ywania z poziomu jêzyka C
w trybie 32-bitowym, którego prototyp na poziomie jêzyka C ma postaæ:
void odejmij_jeden (int ** liczba);
Argument liczba jest adresem zmiennej, w której przechowywany jest adres, pod którym
przechowywana jest liczba (adres adresu).
Napisaæ podprogram w asemblerze dokonuj¹cy opisanego obliczenia i uruchomiæ program
sk³adaj¹cy siê z plików Ÿród³owych w jêzyku C i w asemblerze.
|

.code
_odejmij_jeden PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX

	; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
	; w kodzie w jêzyku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ; odczytanie wartoœci zmiennej
	mov ecx, [eax]
	dec ecx ; odjecie 1
	mov [eax], ecx
	; zamiast powyzszych 3 lini mozna uzyc 'dec dword ptr eax'

	pop ebx
	pop ebp
	ret
_odejmij_jeden ENDP
 END
