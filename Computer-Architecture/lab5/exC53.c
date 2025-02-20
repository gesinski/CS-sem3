#include <stdio.h>

void dodaj_AB(char*A, char*B);

void main() {
	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };

	dodaj_AB(liczby_A, liczby_B);

	printf("Sumy 16 liczb wynosza: ");
	for (int i = 0; i < 16; i++) {
		printf("%c ", liczby_A[i]);
	}

}