#include <stdio.h>
#include <stdlib.h>

struct Node {
    int iValue;
    float fValue;
    struct Node *next;
};

int main() {

    struct Node *head = (struct Node*) malloc(sizeof(struct Node));
    head->iValue = 5;
    head->fValue = 3.14;
	
	printf("iValue: %d \n", head->iValue);
    printf("fValue: %f \n", head->fValue);
    printf("head: %p \n", head);
    printf("Address of head: %p \n", &head);
    printf("Next in node: %p \n", &(head->next));
    
	
	return 0;
}