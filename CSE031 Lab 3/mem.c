#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

 int main() {
	int num;
	int *ptr;
	int **handle;

	num = 14;
	ptr = (int *) malloc(2 * sizeof(int));
	*ptr = num;
	handle = (int **) malloc(1 * sizeof(int *));
	*handle = ptr;

    printf("num: %p\n", &num);
    printf("ptr: %p\n", &ptr);
    printf("handle: %p\n", &handle);

	// Insert code here

	return 0;
} 

