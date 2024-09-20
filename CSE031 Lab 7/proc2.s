.data
# Data segment where we declare and initialize variables
x:		.word 5          	# Initialize x with value 5
y:		.word 10         	# Initialize y with value 10
m:		.word 15         	# Initialize m with value 15
b:		.word 2          	# Initialize b with value 2

.text

MAIN:		la $t0, x          	# Load the address of x into $t0
		lw $s0, 0($t0)	    	# Load the value of x into $s0
		la $t0, y          	# Load the address of y into $t0
		lw $s1, 0($t0) 	    	# Load the value of y into $s1
		
		# Prepare to call sum(x)
		add $a0, $zero, $s0	# Move the value of x into $a0 to use as argument for SUM
		jal SUM             	# Jump and link to SUM function, $ra stores return address
		add $t0, $s1, $s0   	# Add y and x, store result in $t0
		add $s1, $t0, $v0   	# Add the result of SUM to the previous sum, update y in $s1
		addi $a0, $s1, 0    	# Prepare the updated y for printing by moving it to $a0
		li $v0, 1          	# Load syscall number for print_int into $v0
		syscall             	# Make syscall to print integer in $a0
		j END               	# Jump to END to finish program
		
# Function to calculate sum as per the given C function
SUM:    	addi $sp, $sp, -4      	# Allocate space on stack to save $s0
		sw $s0, 0($sp)		# Save $s0 on the stack
        	la $t0, m             	# Load address of m
		lw $s0, 0($t0)		# Load value of m into $s0
        	addi $sp, $sp, -4     	# Allocate space on stack to save $a0
        	sw $a0, 0($sp)        	# Save $a0 on the stack
		add $a0, $s0, $a0	# Add m and x, update $a0 for SUB
        	addi $sp, $sp, -4     	# Allocate space on stack to save $ra
        	sw $ra, 0($sp)        	# Save $ra on the stack
		jal SUB               	# Call SUB function
		lw $a0, 4($sp)       	# Restore $a0 from stack
		lw $s0, 8($sp)       	# Restore $s0 from stack
		add $v0, $a0, $v0    	# Add return value from SUB to $a0, store in $v0
        	lw $ra, 0($sp)        	# Restore $ra from stack
        	addi $sp, $sp, 12     	# Deallocate stack space used for $s0, $a0, and $ra
		jr $ra               	# Return to caller
		
# Function to subtract b from a as per the given C function
SUB:		la $t0, b             	# Load address of b
		addi $sp, $sp, -4    	# Allocate space on stack to save $s0
		sw $s0, 0($sp)		# Save $s0 on the stack
		lw $s0, 0($t0)		# Load value of b into $s0
		sub $v0, $a0, $s0    	# Subtract b from a, store result in $v0
		lw $s0, 0($sp)		# Restore $s0 from stack
		addi $sp, $sp, 4     	# Deallocate stack space used for $s0
		jr $ra               	# Return to caller
		
END: