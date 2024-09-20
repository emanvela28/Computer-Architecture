
#include <stdio.h>
#include <stdlib.h>

int** matMult(int **a, int **b, int size) {
	// (4) Implement your matrix multiplication here. 
	// You will need to create a new matrix to store the product.
	int **result = ((int**)malloc(size*(sizeof(int*))));
	int mult = 0;
	for (int i = 0; i < size; i++) {
		*(result + i) = ((int*)malloc(size*(sizeof(int))));
		for (int j = 0; j < size; j++) {
			mult = 0;
			for (int k = 0; k < size; k++) {
				mult += (*(*(a + i) + k)) * (*(*(b + k) + j));
			}
			*(*(result + i) + j) = mult;
		}
	}
	return result;
}

void printArray(int **arr, int n) {
	// (2) Implement your printArray function here
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
				printf("%d", *(*(arr + i) + j));
		}
	}

}

//test cases
// void AllocMult (int **arr, int n) {
// 	for (int i = 0; i < n; i++) {
// 		*(arr + i) = (int*)malloc(n*sizeof(int));
// 		for (int j = 0; j < n; j++) {
// 			*(*(arr + i) + j) = i;
// 		}
// 	}
// }

int main() {
	int n = 5;
	int **matA, **matB, **matC;
	// (1) Define 2 (n x n) arrays (matrices). 
	matA = ((int**)malloc(n*(sizeof(int*))));
	matB = ((int**)malloc(n*(sizeof(int*))));
	// Implementing test cases
	// AllocMult(matA, n);
	// AllocMult(matB, n);


	// (3) Call printArray to print out the 2 arrays here.
	printArray(matA, n);
	printArray(matB, n);
	
	
	// (5) Call matMult to multiply the 2 arrays here.
	matC = matMult(matA, matB, n);
	
	
	// (6) Call printArray to print out resulting array here.
	printArray(matC, n);


    return 0;
}