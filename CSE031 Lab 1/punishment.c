#include <stdio.h>

void punishment(int repetition, int typopos) {
        for (int i = 1; i <= repetition; i++) {
            if (i == 1 && i == typopos) {
                printf("\nCading wiht is C avesone!\n");
                i +=1;
            } if (i == typopos) {
                printf("Cading wiht is C avesone!\n");
            } else if (i == 1) {
                printf("\nCoding with C is awesome!\n");
            } else {
                printf("Coding with C is awesome!\n");
            }
        }
    }

int main() 
{
	int repetition;
    int typopos;

    printf("Enter the repetition count for the punishment phrase: ");
    while (scanf("%d", &repetition) != 1 || repetition <= 0){
        printf("You entered an invalid value for the repetition count! Please re-enter: ");
    }

    printf("\nEnter the line where you want to insert the typo: ");
    while (scanf("%d", &typopos) != 1 || typopos <= 0 || typopos >= repetition + 1){
        printf("You entered an invalid value for the typo placement! Please re-enter: ");
    }

    punishment(repetition, typopos);

	return 0;
}
