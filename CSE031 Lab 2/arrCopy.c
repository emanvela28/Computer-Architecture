#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int size; // Variable to record size of original array arr
int evenCount = 0, oddCount = 0; // Variables to record sizes of new arrays arr_even and arr_odd
int *arr; // Dynamically allocated original array with #elements = size
int *arr_even;  // Dynamically allocated array with #elements = #even elements in arr (evenCount)
int *arr_odd;   // Dynamically allocated array with #elements = #odd elements in arr (oddCount)
char *str1 = "Original array's contents: ";
char *str2 = "Contents of new array containing even elements from original: ";
char *str3 = "Contents of new array containing odd elements from original: ";


void printArr(int *a, int size, char *prompt){
	printf("\n");
    printf("%s", prompt);
    if (size == 0) {
        printf("empty");
    }
    for (int i = 0; i < size; i++) {
        printf("%d", *(a + i));
        printf(" ");
    }
}

void arrCopy(){
    int *ptr = arr;

    for (int i = 0; i < size; i++) {
        if (*ptr % 2 == 0) {
            evenCount++;
        } else {
            oddCount++;
        }
        ptr++;
    }

    arr_even = (int*)malloc(evenCount * sizeof(int));
    arr_odd = (int*)malloc(oddCount * sizeof(int));

    int evenind = 0;
    int oddind = 0;

    ptr = arr;
    for (int i = 0; i < size; i++) {
        if (*ptr % 2 == 0) {
            *(arr_even + evenind) = *ptr;
            evenind++;
        } else {
             *(arr_odd + oddind) = *ptr;
             oddind++;
        }
        ptr++;
    }

}

int main(){
    int i;
    printf("Enter the size of array you wish to create: ");
    scanf("%d", &size);

    arr = (int*)malloc(size * sizeof(int));

    int counter = 1;
    int *ptr = arr;
    for (int j = 0; j < size; j++) {
        printf("Enter array element #%d: ", counter);
        scanf("%d", ptr);
        counter++;
        ptr++;
    }

	
/*************** YOU MUST NOT MAKE CHANGES BEYOND THIS LINE! ***********/
	
	// Print original array
    printArr(arr, size, str1);

	/// Copy even elements of arr into arr_even and odd elements into arr_odd
    arrCopy();

    // Print new array containing even elements from arr
    printArr(arr_even, evenCount, str2);

    // Print new array containing odd elements from arr
    printArr(arr_odd, oddCount, str3);

    printf("\n");

    return 0;
}