.686
.XMM
.model flat
public _int2float

.data

.code
_int2float PROC
	push ebp
	 mov ebp, esp
	 push ebx
	 push esi
	 mov esi, [ebp+12] ; adres pierwszej tablicy
	 mov ebx, [ebp+8] ; adres tablicy wynikowej
	 movups xmm5, [ebx]

	 cvtpi2ps xmm5, qword PTR [esi]

	 pop esi
	 pop ebx
	 pop ebp
	 ret

_int2float ENDP

end