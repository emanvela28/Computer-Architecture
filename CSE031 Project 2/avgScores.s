.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "

.text 

main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5		# Read the number of scores from user
	syscall
	move $s0, $v0		# $s0 = numScores
	move $t0, $0
	la $s1, orig		# $s1 = orig
	la $s2, sorted		# $s2 = sorted
loop:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5		# Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop
	
	
	move $a0, $s0
	jal selSort		# Call selSort to perform selection sort in original array
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1		# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray		# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2		# More efficient than la $a0, sorted
	jal printArray		# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5		# Read the number of (lowest) scores to drop
	syscall
	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum		# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	
	# Your code here to compute average and print it
	move $s4, $v0
	
	div $s4, $s4, $s5
	
	li $v0, 4 
	la $a0, str5
	syscall 
	
	li 	$v0, 1
	move $a0, $s4
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
# printArray: Prints all elements of an integer array to the console.

# Arguments:
#   $a0: Base address of the array
#   $a1: Number of elements in the array
printArray:
    move $t5, $a0          # Initialize $t5 with the base address of the array to iterate through elements
    move $t6, $0           # Temporary register $t6 used to store current array element's value
    move $t7, $0           # $t7 serves as a loop counter to track the number of elements processed

    # Loop to iterate through each element of the array
inloop:
    lw $t6, 0($t5)         # Load the current array element pointed by $t5 into $t6
    li $v0, 1              # Prepare for syscall to print integer
    move $a0, $t6          # Move the integer to be printed into $a0 (argument for syscall)
    syscall                # Execute syscall to print the integer

    li $a0, 32             # Load ASCII value of space (32) into $a0 for printing
    li $v0, 11             # Prepare for syscall to print character (space)
    syscall                # Execute syscall to print the space

    addi $t5, $t5, 4       # Increment the array pointer by 4 to move to the next integer element
    addi $t7, $t7, 1       # Increment the loop counter
    bne $t7, $a1, inloop   # Continue looping until all elements have been processed

    li $a0, 10             # Load ASCII value of newline (10) into $a0
    li $v0, 11             # Prepare for syscall to print character (newline)
    syscall                # Execute syscall to print the newline

    jr $ra                 # Return to the calling function

	
	
# selSort takes in the number of scores as argument. 
selSort:
    				  # Assume $a0 has the number of elements n, and $s1 has the base address of the array
	move $t0, $a0             # Copy n to $t0
    	li $t1, 4
    	mult $t0, $t1             # Multiply n by 4 to iterate through the array
   	mflo $s3                  # Move the result to $s3 (n * 4)
    	sub $sp, $sp, $s3         # Allocate stack space for n elements

    	move $s5, $zero           # Initialize i = 0
    	move $a1, $s1             # $a1 = original array base address

# Copying elements of the original array into the temporary array on the stack
copy_elements_to_stack:
    	bge $s5, $a0, exit    	  # Bound checking for sorting the array, if i >= n exit loop

    	move $t0, $s5		  # Move i = 0 to $t0
    	li $t1, 4		  # $t1 = 4
    	mult $t0, $t1             # $t0 = i * 4
    	mflo $t2                  # $t2 = i * 4 (address offset)

    	add $t1, $sp, $t2         # $t1 = base of the array on stack + offset

    	lw $t6, 0($a1)            # Load word from original array
    	sw $t6, 0($t1)            # Store it on the stack array
    	addi $a1, $a1, 4          # Move to the next element in original array
    	addi $s5, $s5, 1          # Increment i
    	j copy_elements_to_stack  # Jump back to the start of the loop

exit:
   	move $a1, $a0             # $a1 = size of the array
    	move $a0, $sp             # $a0 now has base address of array on the stack
    	subi $sp, $sp, 4          # Allocate space on the stack to save space for the return value
    	sw $ra, 0($sp)            # Save return address on stack before it is overwritten by jal sort call

    	jal sort                  # Call sort function

    	lw $ra, 0($sp)            # Restore $ra
    	addi $sp, $sp, 4          # Adjust $sp back after $ra restore

    	move $s2, $sp             # Restore original stack pointer
    	jr $ra                    # Return from selSort


# sort: Implements a selection sort algorithm to sort an array in descending order.
sort:       
    addi $sp, $sp, -20   # Allocate 20 bytes on the stack to save registers that will be used in this function.
    sw $ra, 0($sp)       # Save the return address to ensure we can return to the caller.
    sw $s0, 4($sp)       # Save $s0, which contains the size of the array.
    sw $s3, 8($sp)       # Save $s3, used for index and offset calculations.
    sw $s4, 12($sp)      # Save $s4, if used in future expansion of this function.
    sw $s5, 16($sp)      # Save $s5, which is used as the loop counter.

    add $s3, $s0, $0     # Store the size of the array in $s3.
    li $t0, 4            # Load the immediate value 4 into $t0 to prepare for address offset calculation.
    mult $s3, $t0        # Multiply the array length by 4 to convert element index to byte offset.
    mflo $s3             # Store the multiplication result from LO to $s3 for use in addressing.

    move $s3, $a0        # Set $s3 to the base address of the array, received in $a0.
    move $s5, $zero      # Initialize the loop counter $s5 to 0.

    subi $s0, $a1, 1     # Calculate length - 1 and store in $s0 for loop condition.

# Loop to implement the selection sort algorithm.
sort_forloop:
    beq $s5, $s0, sort_exit  # If the loop counter equals length-1, exit the loop (sorting complete).

    move $a1, $s5        # Pass current index $s5 to $a1 for use in max function.
    move $a2, $s0        # Pass end index of the array to $a2 for use in max function.

    jal max              # Call the max function to find the maximum element's index.

    move $a2, $v0        # Store the result from max (index of maximum) in $a2.

    jal swap             # Call swap to swap the current element with the maximum found.

    addi $s5, $s5, 1     # Increment the loop counter.
    j sort_forloop       # Jump back to the start of the loop.

# Exiting the sort loop, begin cleanup and return.
sort_exit:
    lw $ra, 0($sp)       # Restore the original return address.
    lw $s0, 4($sp)       # Restore $s0.
    lw $s3, 8($sp)       # Restore $s3.
    lw $s4, 12($sp)      # Restore $s4.
    lw $s5, 16($sp)      # Restore $s5.
    addi $sp, $sp, 20    # Deallocate 20 bytes used for saving registers.
    jr $ra               # Return to the calling function.


# max: Finds the index of the maximum element in a portion of the array.
# Arguments:
#   $a0: base address of the array
#   $a1: starting index for search
#   $a2: ending index for search
max:
    move $t0, $a0       # Store the base address of the array in $t0 for easy access.
    move $t1, $a1       # Store the starting index in $t1.
    move $t2, $a2       # Store the ending index in $t2.

    sll $t3, $t1, 2     # Multiply the starting index by 4 to calculate the byte offset.
    add $t3, $t3, $t0   # Calculate the memory address of the starting index element.
    lw $t4, 0($t3)      # Load the element at the starting index into $t4; initially assume this is the max.

    addi $t5, $t1, 1    # Initialize $t5 to the next index after $t1 to start comparisons.

# Loop to compare each element with the current max and update if a larger element is found.
max_forloop:
    bgt $t5, $t2, max_end  # If $t5 exceeds $t2, exit loop; all elements have been compared.

    sll $t6, $t5, 2    # Calculate the byte offset for the current index $t5.
    add $t6, $t6, $t0  # Calculate the memory address for the current index element.
    lw $t7, 0($t6)     # Load the element at the current index into $t7.

    ble $t7, $t4, max_if_exit # If the current element is less than or equal to max, skip the update.

    move $t1, $t5      # Update max index to the current index as a new max has been found.
    move $t4, $t7      # Update max value to the current element value.

max_if_exit:
    addi $t5, $t5, 1   # Increment the index $t5 to compare the next element.
    j max_forloop      # Jump back to the start of the loop for the next iteration.

# Return the index of the maximum element found.
max_end:
    move $v0, $t1      # Place the index of the maximum element into $v0 as the return value.
    jr $ra             # Return to the caller.



# swap function
# swap: Swaps two elements in an array.
# Arguments:
#   $a0: base address of the array
#   $a1: index of the first element to swap
#   $a2: index of the second element to swap
swap:
    sll $t1, $a1, 2    # Calculate the byte offset for the first element.
    add $t1, $a0, $t1  # Calculate the memory address for the first element.

    sll $t2, $a2, 2    # Calculate the byte offset for the second element.
    add $t2, $a0, $t2  # Calculate the memory address for the second element.

    lw $t0, 0($t1)     # Load the first element into $t0.
    lw $t3, 0($t2)     # Load the second element into $t3.

    sw $t3, 0($t1)     # Store the second element at the first element's position.
    sw $t0, 0($t2)     # Store the first element at the second element's position.

    jr $ra             # Return to the caller.

	
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
# calcSum function: Recursively calculates the sum of elements in an array.
# Arguments:
#   $a0: base address of the array
#   $a1: number of elements in the array
calcSum:
    move $s5, $a1         # Store the original length of the array in $s5 for safekeeping
    move $v0, $0          # Initialize sum counter to 0
    
    # Begin the recursive summation process
recur:   
    subi $sp, $sp, 4      # Allocate space on the stack for the return address
    sw $ra, 0($sp)        # Save the return address on the stack to preserve it across recursive calls
    
    # Conditional to check if we need to continue recursion
    bgtz $a1, else        # If the number of elements ($a1) is greater than 0, proceed to 'else' block
    j end_recur           # Otherwise, jump to end_recur to finalize and return
    
    # Recursive case: calculate sum of the array excluding the last element
else:
    subi $a1, $a1, 1      # Decrement the count of elements to consider the next element
    sll $t0, $a1, 2       # Calculate the byte offset for the current last element (n-1) by shifting left (multiply by 4)
    add $t0, $t0, $a0     # Add the base address of the array to the offset to get the actual address of the current element
    
    lw $t2, 0($t0)        # Load the value of the current element into $t2
    add $v0, $v0, $t2     # Add the value of the current element to the running total in $v0
    
    j recur               # Jump back to the beginning of recur to continue the recursion with the next element
    
    # End of recursion: restore the return address and adjust the stack pointer
end_recur:
    lw $ra, 0($sp)        # Restore the return address from the stack
    addi $sp, $sp, 4      # Deallocate the space on the stack used for the return address
    
    jr $ra                # Return to the caller of calcSum

