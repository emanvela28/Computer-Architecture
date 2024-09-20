#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Declarations of the two functions you will implement
// Feel free to declare any helper functions or global variables
void printPuzzle(char** arr);
void searchPuzzle(char** arr, char* word);
void printResult();
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

void printPuzzle(char** arr) {
	// This function will print out the complete puzzle grid (arr). 
    // It must produce the output in the SAME format as the samples 
    // in the instructions.
    // Your implementation here...
    for (int i = 0; i < bSize; i++){
        for(int j=0; j < bSize; j++){
            printf("%c ", *(*(arr+i)+j));

            }
        printf("\n");

    }

}

// bool function to check neighbors and recursively check if the path of neighbors is valid and finds the word
// x and y are coordinates, int** path is the search path that gets printed out and index is the index of each character in the word we are looking for.
bool checkWord(char** arr, int x, int y, char* word, int** path, int index) {
    // If word is found, return true
    if (*(word+index) == '\0') {
        return true;
    }
    // check to see if x or y coordinates are out of bounds if they are return false.
    if(x < 0 || y < 0 || x >= strlen(*(arr)) || y >= strlen(*(arr))) {
        return false;
    }

    // If current cell is not equal to current character in word, return false
    if (*(*(arr+x)+y) != *(word+index)) {
        return false;
    }

    // If current cell is equal to current character in word, Mark current cell as visited in path
   if(*(*(arr + x) + y) == *(word + index)) {
    // sets count = to the condition that checks if *(*(path + x) + y) == 0. if the condition is true then the value would be index + 1 or if the condition is false the value is (*(*(path + x) + y) * 10) + index + 1 
        int count = *(*(path + x) + y) == 0 ? index + 1 : (*(*(path + x) + y) * 10) + index + 1;
        //set path coordinates (x,y) to whatever count equals. 
        //if the neighbor hasnt been visited and is 0 then we increment it by index + 1.
        // if the neighbor has been visited before then we multiply it by 10 and add index + 1.
        *(*(path + x) + y) = count;

//     {-1, -1}, {-1, 0}, {-1, 1}, all 8 direction we need to look for
//     {0, -1},           {0, 1},
//     {1, -1},  {1, 0},  {1, 1}

        // recursively check all 8 directions to see which nearby neighbor we can use.
        bool found = 
            checkWord(arr, x-1, y, word,path, index+1) ||
            checkWord(arr, x+1, y, word, path, index+1) ||
            checkWord(arr, x, y-1, word, path, index+1) ||
            checkWord(arr, x, y+1, word, path, index+1) ||
            checkWord(arr, x-1, y-1, word, path, index+1) ||
            checkWord(arr, x-1, y+1, word, path, index+1) ||
            checkWord(arr, x+1, y-1, word, path, index+1) ||
            checkWord(arr, x+1, y+1, word, path, index+1);

    // if found == 0 or found = false then unmark current cell as visited in path
   if(!found) {
            *(*(path + x) + y) = 0;
        }
        //returns the true or false from bool found searching for nearby neighbors in all 8 directions.
        return found;
    }
    else {
        return false;
    }

}

char Upper(char c) {
    if (c >= 'a' && c <= 'z') {
        //'a' - 'A' = 32
        return c - 32;
    }
    return c;
}

void searchPuzzle(char** arr, char* word) {
    // This function checks if arr contains the search word. If the 
    // word appears in arr, it will print out a message and the path 
    // as shown in the sample runs. If not found, it will print a 
    // different message as shown in the sample runs.
    // Your implementation here...
    int count = 0;

    //converts lower case letters in char* word to uppercase.
    for (int p = 0; p < strlen(word); p++){
        *(word+p) = Upper(*(word+p));
    }
  
    //initialize and fill arr1 with 0's
    int **arr1 = (int**)malloc(bSize * sizeof(int*));
    for (int i = 0; i < bSize; i++){
    arr1[i] = (int *)malloc(bSize * sizeof(int*));
    }
    for (int i = 0; i < bSize; i++){
        for(int j=0; j < bSize; j++){
            *(*(arr1+i)+j) = 0;
        }
    }

// Set bool found initially to false.
    bool found = false;

    // Search for the word in the puzzle
    for (int i = 0; i < bSize; i++) {
        for (int j = 0; j < bSize; j++) {
            // check to see if the word is found starting at index 0 for char* word
            if (checkWord(arr, i, j, word, arr1, 0) && count == 0) {
                count++;
                found = true;
                printf("\n");
                printf("Word found!\n");
                printf("Printing the search path:\n");

                // Print search path for arr1
                for (int x = 0; x < bSize; x++) {
                    for (int y = 0; y < bSize; y++) {
                        printf("%d\t", *(*(arr1+x)+y));
                    }
                    printf("\n");
                }
            }
    }
}
    if (!found) {
        printf("\n");
        printf("Word not found!\n");
    }
    // Free memory allocated for arr1 
    for (int i = 0; i < bSize; i++) {
        free(*(arr1+i));
    }
    free(arr1);
}