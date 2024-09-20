#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declarations of the two functions you will implement
// Feel free to declare any helper functions or global variables
void printPuzzle(char** arr);
void searchPuzzle(char** arr, char* word);
int bSize;

// Main function, DO NOT MODIFY 	
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <puzzle file name>\n", argv[0]);
        return 2;
    }
    int i, j;
    FILE *fptr;

    // Open file for reading puzzle
    fptr = fopen(argv[1], "r");
    if (fptr == NULL) {
        printf("Cannot Open Puzzle File!\n");
        return 0;
    }

    // Read the size of the puzzle block
    fscanf(fptr, "%d\n", &bSize);
    
    // Allocate space for the puzzle block and the word to be searched
    char **block = (char**)malloc(bSize * sizeof(char*));
    char *word = (char*)malloc(20 * sizeof(char));

    // Read puzzle block into 2D arrays
    for(i = 0; i < bSize; i++) {
        *(block + i) = (char*)malloc(bSize * sizeof(char));
        for (j = 0; j < bSize - 1; ++j) {
            fscanf(fptr, "%c ", *(block + i) + j);            
        }
        fscanf(fptr, "%c \n", *(block + i) + j);
    }
    fclose(fptr);

    printf("Enter the word to search: ");
    scanf("%s", word);
    
    // Print out original puzzle grid
    printf("\nPrinting puzzle before search:\n");
    printPuzzle(block);
    
    // Call searchPuzzle to the word in the puzzle
    searchPuzzle(block, word);
    
    return 0;
}

// Function to convert the characters to capital letters
char convertCAPS(char c) {
    if (c >= 'a' && c <= 'z') {
        return c - 32;
    }
    return c;
}


// Function to check the surrounding letters
int checkAdjacent (char **arr, int **direction, char *word, int i, int j, int currentpos) {

    // Letter count variable lets us know what letter was found and then is put into the direction path.
    int lettercount;

    // Bound checking, if the current position in the word is null, the word is found
    if (*(word + currentpos) == '\0') {
        return 1;
    // If the indicies i or j are out of bounds, return false
    } else if ( i < 0 || j < 0 || i >= bSize || j >= bSize) {
        return 0;
    // If i and j in the array are not equal to the current position of the word return false, a letter located isnt there
    } else if (*(*(arr + i) + j) != *(word + currentpos)) {
        return 0;
    }

    // If the current position in the given array is equal to the current position of the word, add 1 to count
    if (*(*(arr + i) + j) == *(word + currentpos)) {
        if (*(*(direction + i) + j) == 0) {
            // 
            lettercount = currentpos + 1;
        } else {
            lettercount = (*(*(direction + i) + j) * 10) + currentpos + 1;
        }   

        // Recursively call the check adjacent function in order to check the surrounding indicies
        *(*(direction + i) + j) = lettercount;
        int charfound = checkAdjacent(arr, direction, word, i - 1, j - 1, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i - 1, j, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i - 1, j + 1, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i , j - 1, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i, j + 1, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i + 1, j - 1, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i + 1, j, currentpos + 1) 
                || checkAdjacent(arr, direction, word, i + 1, j + 1, currentpos + 1);

        // After checking the surrounding indicies, if none of the chars match, backtrace to 0.
        if (!charfound) {
            *(*(direction + i) + j) = 0;
        }
        return charfound;
    } else {
        return 0;
    }
}

void printPuzzle(char** arr) {
	// This function will print out the complete puzzle grid (arr). 
    // It must produce the output in the SAME format as the samples 
    // in the instructions.
    // Your implementation here...
    // Nested for loop to iterarte through bSize and print the given array.
    for (int i = 0; i < bSize; i ++) {
        for (int j = 0; j < bSize; j++) {
            printf("%c ", *(*(arr + i) + j));
        }
        printf("\n");
    }

}

void searchPuzzle(char** arr, char* word) {
    // This function checks if arr contains the search word. If the 
    // word appears in arr, it will print out a message and the path 
    // as shown in the sample runs. If not found, it will print a 
    // different message as shown in the sample runs.
    // Your implementation here...


    // Wordcount to prevent multiple outputs, if wordcount is = to 1, then it will not iterate through the block again.
    int wordcount = 0;
    int found = 0;
    int length = strlen(word);

    //Convert the user word to all caps
    for (int i = 0; i < length; i++) {
        *(word + i) = convertCAPS(*(word + i));
    }

    // Declaring dynamic memory for the output array
    int **output = (int**) malloc (bSize * sizeof(int*));
    for (int i = 0; i < bSize; i++) {
        *(output + i) = (int*) malloc (bSize * sizeof(int));
    }

    // Filling the output array with 0's by setting each position = to 0.
    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            *(*(output + i) + j) = 0;
        }
    }

    //Looping through the block and checking to see if checkadjacent and word count are true to the conditions
    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            // if checkAdjacent returns true (the word was found) and wordcount is 0 (it hasnt been found yet) then print the result.
            if (checkAdjacent(arr, output, word, i, j, 0) && wordcount == 0) {
            wordcount++;
            found = 1;
            printf("\nWord found!\n");
            printf("Printing the search path:\n");

            // Using a nested for loop to print the result 
            for (int i = 0; i < bSize; i++) {
                for (int j = 0; j < bSize; j++) {
                    printf("%d\t", *(*(output + i) + j));
                }
                printf("\n");
                }   
            }
        }
    }

    //If the the bool var found returns false, then we know the word was not found and can return the not found statement.
    if (!found) {
        printf("\nWord not found!\n");
    }
}