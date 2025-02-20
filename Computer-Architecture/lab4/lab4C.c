#include <stdio.h>

int min_abs(int tabl[],unsigned int n);

int main() {
	int arr[] = { 1, -3, 25, -100, 6};
	unsigned int size = 5;
	int wynik;

	wynik = min_abs(arr, size);

	printf("\nW tablicy liczb: ");
	for (int i = 0; i < size; i++) {
		printf("%d ", arr[i]);
	}
	printf("\nNajmniejsza z wartoscia bezwzgledna jest: %d", wynik);

	return 0;
}