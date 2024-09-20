.data
inputPrompt: 	.asciiz "Please enter an integer: "
return1:  	.asciiz "Returning 1\n"
return3:  	.asciiz "Returning 3\n"

.text
main:
    	# Display input prompt
    	li $v0, 4
    	la $a0, inputPrompt
    	syscall
    
    	# Read user input
    	li $v0, 5
    	syscall
    	move $a0, $v0            # Move read integer into $a0 for recursion argument
    
    	jal recursion            # Call recursion(x)
    
    	# Correctly print out returned value
    	move $a0, $v0            # Move returned value to $a0 for printing
    	li $v0, 1                # Syscall for print integer
    	syscall                  # Print the integer stored in $a0
    
    	# End program
    	li $v0, 10               # Exit syscall
    	syscall

# Recursive function
recursion:

	# Creating space on the stack
    	addi $sp, $sp, -24       # Allocate stack space for saved registers
    	sw $ra, 20($sp)          # Save return address
    	sw $a0, 16($sp)          # Save argument

    	# Base case: m == -1
    	addi $t1, $a0, 1
   	beq $t1, $zero, is_minus_one
    
    	# Base case: m == 0
    	beq $a0, $zero, is_zero
    
    	# Recursive case
    	addi $a0, $a0, -2        # Prepare m - 2
    	jal recursion            # Call recursion(m - 2)
    	sw $v0, 12($sp)          # Save result of recursion(m - 2)
    
    	lw $a0, 16($sp)          # Restore original $a0
    	addi $a0, $a0, -1        # Prepare m - 1
    	jal recursion            # Call recursion(m - 1)
    	lw $t0, 12($sp)          # Load result of recursion(m - 2)
    
    	add $v0, $v0, $t0        # Add results of recursion(m - 2) and recursion(m - 1)
    	j end_recursion
    
is_minus_one:
    	# Print "Returning 1"
    	li $v0, 4
    	la $a0, return1
    	syscall
    	li $v0, 1                # Set return value to 1 AFTER printing
    	j end_recursion
    
is_zero:
    	# Print "Returning 3"
    	li $v0, 4
    	la $a0, return3
    	syscall
    	li $v0, 3                # Set return value to 3 AFTER printing
   	j end_recursion

end_recursion:
    	lw $ra, 20($sp)          # Restore return address
    	addi $sp, $sp, 24        # Deallocate stack space
    	jr $ra                   # Return to caller
