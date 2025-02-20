.686
.XMM
.model flat
public _pm_jeden

.data
ALIGN 16
liczby dd 1.0, 1.0, 1.0, 1.0 ;, 1.0, 1.0, 1.0

.code
_pm_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ebx, [ebp+8] ; adres tablicy
	movups xmm3, [ebx]
	movups xmm5, dword ptr [liczby]
	
	ADDSUBPS xmm3, xmm5

	 pop ebx
	 pop ebp
	 ret
_pm_jeden ENDP

end