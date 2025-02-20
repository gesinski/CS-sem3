.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC

public _main

.data
	tytul dw 'Z', 'n', 'a', 'k', 'i', 0
	tekst dw 'T', 'o', ' ', 'j', 'e', 's', 't', ' '
		  dw 'm', 'a', 0142h, 'p', 'a', ' ', 0d83eh, 0dd17h, ' '
		  dw 'i', ' ', 'k', 'o', 't', ' ', 0d83dh, 0de3fh, 0
.code
_main PROC
	push 0
	push OFFSET tytul
	push OFFSET tekst
	push 0
	call _MessageBoxW@16
	call _ExitProcess@4

_main ENDP

end