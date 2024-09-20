.data
prompt: .asciiz "Please enter a number: "
newline: .asciiz "\n"

.text

main:
    	li $v0, 4                  # Print prompt message
    	la $a0, prompt
    	syscall
    
    	li $v0, 5                  # Read integer from user
    	syscall
    	move $a0, $v0              # Move read integer into $a0 for recursion
    
    	jal recursion              # Call the recursion function
    
    	move $a0, $v0              # Move return value of recursion into $a0 for printing
    	li $v0, 1
    	syscall                    # Print the result
    
    	li $v0, 10                 # Exit program
    	syscall

recursion:
    	addi $sp, $sp, -16         # Allocate space on the stack for 4 words
    	sw $ra, 0($sp)             # Save return address
    	sw $a0, 4($sp)             # Save the argument m
    
    	li $t1, -1
    	beq $a0, $t1, is_neg1      # If m == -1, jump to is_neg1
    	li $t2, -2
    	bgt $a0, $t2, is_greater   # If m > -2, process the recursive case
    	li $v0, 2                  # For m < -2, return 2
    	beq $a0, $t2, is_neg2      # If m == -2, set return value to 1
    	j end

is_neg1:
    	li $v0, 3                  # Return 3 for m == -1
    	j end
    
is_neg2:
    	li $v0, 1                  # Return 1 for m == -2
    	j end

is_greater:
    	addi $a0, $a0, -3
    	jal recursion              # recursion(m - 3)
    	sw $v0, 8($sp)             # Store the result of recursion(m - 3)
    
    	lw $a0, 4($sp)             # Restore the original value of m
	addi $a0, $a0, -2
    	jal recursion              # recursion(m - 2)
    	lw $t0, 8($sp)             # Load the result of recursion(m - 3)
    	add $v0, $v0, $t0          # Add the results of recursion(m - 2) and recursion(m - 3)
    
    	lw $t1, 4($sp)             # Load the original value of m
    	add $v0, $v0, $t1          # Add m to the result
    
end:
    	lw $ra, 0($sp)             # Restore the return address
    	addi $sp, $sp, 16          # Deallocate space on the stack
    	jr $ra                     # Return from recursion
