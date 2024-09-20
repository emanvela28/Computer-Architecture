

.data
prompt: 	.asciiz "Please enter a number: "
even_msg:	.asciiz "\nSum of even numbers is: "
odd_msg:	.asciiz "\nSum of odd numbers is: "

.word

.text

main: 

	# Even and Odd sums = 0
	li $s0, 0	# Even sum
	li $s1, 0	# Odd sum
	
loop:
	# Print prompt
    	li $v0, 4
   	la $a0, prompt
    	syscall
    	
    	# Read integer from user
    	li $v0, 5
    	syscall
    	
    	# Store users number in $t0
    	move $t0, $v0
    	
    	# Check to see if the value is 0
    	beq $t0, $zero, end
    	
    	# Move value over to manipulate and go to pos or neg if neg
    	move $t1, $t0
    	bltz $t1, pos_or_neg
    	
# Loop to check if a positive number is even or odd by subtracting 2
checkevenodd: 
	sub $t1, $t1, 2
    	bgtz $t1, checkevenodd
    	beq $t1, $zero, even
    	j odd
    	
# Handle negative numbers by adding 2 until we reach 0 or -1
pos_or_neg:
	add $t1, $t1, 2
    	bltz $t1, pos_or_neg
    	beq $t1, $zero, even
    	j odd
	

even:
	# Add number to sum
	add $s0, $s0, $t0
	j loop

odd: 
	# Add number to sum
	add $s1, $s1, $t0
	j loop
    	
 end:
 	# Print sum of even
 	li $v0, 4
   	la $a0, even_msg
    	syscall
    	# Prepare to print integer
    	li $v0, 1
    	move $a0, $s0
    	syscall
    	
    	# Print sum of odd
 	li $v0, 4
   	la $a0, odd_msg
    	syscall
    	# Prepare to print integer
    	li $v0, 1
    	move $a0, $s1
    	syscall
    	
 
