#include <stdio.h>

int pow_func(int base, int exp) {
	int total = 1;
	for (int n = 0; n < exp; n++) {
		total *= base;
	}
	return total;
}

int main(void) {
	printf("Hello World!\n");
	int power = pow_func(3, 4);
	printf("Power of 3 and 4 is: %d\n", power);
	return 0;
}
