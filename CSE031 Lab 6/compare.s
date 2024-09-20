
.data
n:	.word 25
str1:	.asciiz "Less than\n"
str2:	.asciiz "Less than or equal to\n"
str3:	.asciiz "Greater than\n"
str4:	.asciiz "Greater than or equal to\n"
prompt:	.asciiz "Enter a number: "

.text

main: 
	# Print prompt
    	li $v0, 4
   	la $a0, prompt
    	syscall

    	# Read integer from user
    	li $v0, 5
    	syscall

    	# Loading values into registers
    	la $t1, n          		# Load address of n into $t1
    	lw $t1, 0($t1)     		# Load value of n into $t1
    	
    	# Comparisons to n
    	#blt $v0, $t1, Less_Than  	# If input ($v0) is less than n ($t1), jump to Less_Than
    	#bge $v0, $t1, Greater_Equal  	# If input ($v0) is greater than or equal to n ($t1), jump to Greater_Equal
    	bgt $v0, $t1, Greater_Than	# If input ($v0) is greater than n ($t1), jump to Greater_Than	
    	ble $v0, $t1, Less_Equal	# If input ($v0) is less than or equal to n ($t1), jump to Less_Equal	
    	j exit

Less_Than:
    	# Less than message
   	li $v0, 4
    	la $a0, str1
    	syscall
    	j exit
    	
Less_Equal:
	# Less than or equal to message
   	li $v0, 4
    	la $a0, str2
    	syscall
    	j exit
    
Greater_Equal:
    	# Greater than or equal to message
    	li $v0, 4
    	la $a0, str4
    	syscall
    	j exit
    	
Greater_Than:
    	# Greater than message
    	li $v0, 4
    	la $a0, str3
    	syscall
    	j exit

exit:
    	# Exit program
    	li $v0, 10
    	syscall