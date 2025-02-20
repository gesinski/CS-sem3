#include <stdio.h>

void przestaw(int tabl[], int n);

int main() {
	int arr[] = { 1, -3, 25, -100, 6};
	int size = 5;

	printf("\nNieposortowana tablica liczb: ");
	for (int i = 0; i < size; i++) {
		printf("%d ", arr[i]);
	}

	for (int i = size; i > 1; i--) {
		przestaw(arr, i);
	}

	printf("\n\nPosortowana tablica liczb: ");
	for (int i = 0; i < size; i++) {
		printf("%d ", arr[i]);
	}

	return 0;
}