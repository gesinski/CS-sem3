.686
.model flat
.XMM
public _dodaj_AB

.data

.code
_dodaj_AB PROC
	push ebp
	mov ebp, esp
	push esi
	 push edi
	 mov esi, [ebp+8] ; adres pierwszej tablicy
	 mov edi, [ebp+12] ; adres drugiej tablicy

	movups xmm5, [esi]
	movups xmm6, [edi]
; sumowanie czterech liczb zmiennoprzecinkowych zawartych
; w rejestrach xmm5 i xmm6
 
	paddsb xmm5, xmm6

 pop edi
 pop esi
 pop ebp
 ret


_dodaj_AB ENDP

end