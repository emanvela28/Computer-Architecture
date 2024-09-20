.data
str: .asciiz "p + q: "       # Define a string for output
str1: .asciiz "\n "          # Define a newline character for formatting output

.text

MAIN:		
    	add $s0, $zero, 2        # Initialize x = 2
    	add $s1, $zero, 4        # Initialize y = 4
    	add $s2, $zero, 6        # Initialize z = 6
    	li $v0, 4                # Set syscall for print string
    	la $a0, str              # Load address of the string "p + q: " into $a0
    	syscall                  # Execute syscall to print "p + q: "
    
    	jal foo                  # Jump and link to foo; this calls foo function
    	move $t4, $a0            # Move result of foo into $t4 for temporary storage


    	move $a0, $t4            # Restore $a0 with the result of foo for printing
    	add $a0, $s0, $s1        # Attempt to recalculate part of foo's logic 
    	add $a1, $s2, $v0        
    	add $v0, $a0, $a1        # Summation of previous operations
    	move $a0, $v0            # Prepare the result for printing
    
    	li $v0, 1                # Set syscall for print integer
    	syscall                  # Execute syscall to print the final result
    	move $v0, $a0            # Move the final result back into $v0 (unnecessary for program logic)
    	j END                    # Jump to END to finish the program

foo: 		
    	addi $sp, $sp, -12       # Allocate space on the stack for 3 words
    	sw $ra, 0($sp)           # Save return address on the stack
    	sw $s0, 4($sp)           # Save register $s0 on the stack
    	sw $s1, 8($sp)           # Save register $s1 on the stack
    
    	# Preparing arguments for the first call to bar within foo
    	add $a0, $s0, $s2        # m + o
    	add $a1, $s1, $s2        # n + o
    	add $a2, $s0, $s1        # m + n
    	jal bar                  # Call bar
    	move $t3, $v0            # Store result of bar in $t3
    
    	# Preparing arguments for the second call to bar within foo
    	sub $a0, $s0, $s2        # m - o
    	sub $a1, $s1, $s0        # n - m
    	add $a2, $s1, $s1        # n + n
    	jal bar                  # Call bar
    	move $t1, $v0            # Store result of bar in $t1
    
    	add $v0, $t3, $t1        # p + q
    	move $a0, $v0            # Prepare the sum (p + q) for printing
    	li $v0, 1                # Set syscall for print integer
    	syscall                  # Print p + q
    	move $v0, $a0            # Restore the print integer syscall result to $v0
    
   	# Print newline after p + q output
    	move $a1, $v0            # Move result into $a1 temporarily
    	li $v0, 4                # Set syscall for print string
    	la $a0, str1             # Load address of newline character
    	syscall                  # Print newline
    	move $v0, $a1            # Restore the original result into $v0
    
    	# Restore registers and return from foo
    	lw $ra, 0($sp)           # Load return address from stack
    	lw $s0, 4($sp)           # Restore $s0 from stack
    	lw $s1, 8($sp)           # Restore $s1 from stack
    	addi $sp, $sp, 12        # Deallocate stack space
    	jr $ra                   # Return to caller

bar:
    	# Implements the bar function logic: (b - a) << c
    	sub $t0, $a1, $a0        # b - a
    	sllv $v0, $t0, $a2       # (b - a) << c, result stored in $v0
   	jr $ra                   # Return to caller
		
END:
    	li $v0, 10               # Set syscall for exit
    	syscall                  # Execute syscall to exit the program
