.686
.model flat

public _liczba_przeciwna

comment | 
Napisac w asemblerze kod funkcji liczba_przeciwna, ktora wyznaczy liczbe przeciwna do znajduj¹cej siê wzmiennej.
Napisac krotki program w jezyku C do testowania opracowanej funkcji. |

.code
_liczba_przeciwna PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX
	
	; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
	; w kodzie w jêzyku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ; odczytanie wartoœci zmiennej
	imul eax, -1 ; uzyskanie liczby przeciwnej
	mov [ebx], eax ; odes³anie wyniku do zmiennej

	pop ebx
	pop ebp
	ret
_liczba_przeciwna ENDP
 END