#include <stdio.h>

int fac(int x) {
	if (x == 0) {
		return 1;
	}
	return x * fac(x - 1);
}

int main() {
	printf("Hello World! Fac of 5 is %d\n", fac(5));

	return 0;
}
