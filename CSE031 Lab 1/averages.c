#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int main () {

    int totalcount = 0;
    int input;
    int modtotal = 0;
    float sumeven = 0;
    float sumodd = 0;
    float evenavg = 0;
    float oddavg = 0;
    int evencount = 0;
    int oddcount = 0;


    while (input != 0) { 
        totalcount++; 

        if (totalcount % 10 == 2 && totalcount % 100 != 12) {
            printf("Enter the %dnd value: ", totalcount);
            scanf("%d", &input);
        } else if (totalcount % 10 == 1 && totalcount % 100 != 11) {
            printf("Enter the %dst value: ", totalcount);
            scanf("%d", &input);
        } else if (totalcount % 10 == 3 && totalcount % 100 != 13) {
            printf("Enter the %drd value: ", totalcount);
            scanf("%d", &input);
        } else {
            printf("Enter the %dth value: ", totalcount);
            scanf("%d", &input);
        }   

        int rtot = 0;
        int currval = abs(input);
        
        while (currval != 0) {
            rtot += currval % 10;
            currval /= 10;
        }

        if (rtot % 2 == 0) {
            sumeven += input;
            evencount++;
        } else {
            sumodd += input;
            oddcount++;
        }   
    }


    if (evencount != 0) {
        if (evencount == 1) {
            printf("\n");
        } else {
            evenavg =(float)(sumeven / (evencount - 1));
            printf("\nAverage of input values whose digits sum up to an even number: %.2f\n", evenavg);
        } 
    } else {
        printf("There is no average to compute.\n");
    }

    if (oddcount != 0) {
        oddavg =(float)(sumodd / oddcount);
        printf("Average of input values whose digits sum up to an odd number: %.2f\n", oddavg);
    }


return 0;

}