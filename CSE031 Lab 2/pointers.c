#include <stdio.h>


int main() {

    int x=0, y=0, *px, *py;
    int arr[10] = {0};

    //Print values of variables
    printf("Value of x: %d\n", x);
    printf("Value of y: %d\n", y);
    printf("Value of arr[0]: %d\n", arr[0]);

    // Print Memory locations
    printf("\nMemory location for x: %p\n", &x);
    printf("Memory location for y: %p\n", &y);

    //5. Code to have px point to x and py point to y
    px = &x;
    py = &y;

    printf("\nValue of px: %p\n", px);
    printf("Value of py: %p\n", py);

    //5. Print Memory locations of pointers
    printf("Memory location for px: %p\n", &px);
    printf("Memory location for py: %p\n", &py);

    //6. Using Array as pointer
    printf("\n");
    for (int i = 0; i < 10; i++) {
        printf("Values of arr[%d]: %d\n" , i, *(arr + i));
    }

    // 7. 
    printf("\nAddress of arr[0]: %p\n", arr);
    printf("Address of arr[0]: %p\n", &arr[0]);

    // 8. 
    printf("\nAddress of arr: %p\n", arr);

return 0;
}