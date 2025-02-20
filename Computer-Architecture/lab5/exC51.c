#include <stdio.h>
#define size 5

float srednia_harm(float* tablica, unsigned int n);

void main() {
	unsigned int n = size;
	float arr[] = { 21.37f, 21.0f, 3.7f, 2.1f, 0.37f };

	float harm_mean = srednia_harm(arr, n);

	printf("srednia harmoniczna: %f", harm_mean);
}