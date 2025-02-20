#include <stdio.h>
#define size 5

double srednia_wazona(double tablica_dane[], double tablica_wagi[], unsigned int n);

void main() {
	unsigned int n = size;
	double arr[] = { 21.37, 2.0, 3.7, 2.1, 2.37 };
	double wagi[] = { 1.0, 2.0, 3.0, 4.0, 5.0 };
	double mean = srednia_wazona(arr, wagi, n);

	printf("srednia wazona: %lf", mean);
}