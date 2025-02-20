#include <stdio.h>

int szukaj4_max(int a, int b, int c, int d);

int main()
{
	int x, y, z, v, wynik;
	printf("\nProsze podac trzy liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &x, &y, &z, &v, 32);
	wynik = szukaj4_max(x, y, z, v);
	printf("\nSposrod podanych liczb %d, %d, %d, %d, liczba %d jest najwieksza\n", x, y, z, v, wynik);
	return 0;
}