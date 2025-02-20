.686
.model flat

public _szukaj4_max

comment |
Napisaæ podprogram szukaj4_max. Prototyp podprogramu ma postaæ: int szukaj4_max (int a, int b, int c, int d);
Podprogram powinien wyznaczyæ najwiêksz¹ liczbê spoœród podanych jako parametrypodprogramu.
Napisaæ tak¿e krótki program w jêzyku C ilustruj¹cy sposób wywo³ywania podprogramu.
|

.code
_szukaj4_max PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP
	mov eax, [ebp+8] ; liczba x
	cmp eax, [ebp+12] ; porownanie liczb x i y
	jge x_wieksza ; skok, gdy x >= y
	
	; przypadek x < y
	mov eax, [ebp+12] ; liczba y
	cmp eax, [ebp+16] ; porownanie liczb y i z
	jge y_wieksza ; skok, gdy y >= z
	
	; przypadek y < z
	mov eax, [ebp+16] ; liczba z
	cmp eax, [ebp+20] ; porownanie liczb z i v
	jge z_wieksza ; skok, gdy z >= v
	; zatem v jest liczb¹ najwieksz¹
wpisz_v: 
	mov eax, [ebp+20] ; liczba v

zakoncz:
	pop ebp
	ret
x_wieksza:
	cmp eax, [ebp+16] ; porownanie x i z
	jle z_wieksza ; skok, gdy x <= z
	cmp eax, [ebp+20] ; porowanie x i v
	jge zakoncz ; skok, gdy x >= v
	jmp wpisz_v
y_wieksza:
	mov eax, [ebp+12] ; liczba y
	cmp eax, [ebp+20] ; porownanie liczb y i v
	jge zakoncz ; skok, gdy y >= v
	jmp wpisz_v
z_wieksza:
	mov eax, [ebp+16] ; liczba z
	jmp zakoncz
	
_szukaj4_max ENDP
END