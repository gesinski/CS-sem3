.686
.model flat

public _min_abs

.code
_min_abs PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
	push ebx ; przechowanie zawartoœci rejestru EBX

	mov ebx, [ebp+8] ; adres tablicy tabl
	mov ecx, [ebp+12] ; liczba elementów tablicy
	dec ecx

	; przeniesienie pierwszego elementu do eax i przejscie do kolejnego
	mov eax, [ebx]
	cmp eax, 0
	jl absFirst
	add ebx, 4


; wpisanie kolejnego elementu tablicy do rejestru EAX
ptl: 
	cmp ebx, 0
	jl abs

; porównanie elementu tablicy wpisanego do EAX z nastêpnym
porownanie:
	cmp eax, ebx
	jl gotowe ; skok, gdy nie ma przestawiania

; zamiana jesli jest wiekszy
	mov eax, ebx

gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pêtli
	pop ebx ; odtworzenie zawartoœci rejestrów
	pop ebp
	ret ; powrót do programu g³ównego

abs:
	neg ebx
	jmp porownanie 

absFirst:
	neg eax
	jmp gotowe

_min_abs ENDP
 END