# This program read and print float values.

		.data 0x10000000
	
msg:	.asciiz "Digite um número float (ex: xy.z): "
zero:	.float 0.0		# Save zero value

	.text

main: 	
	li   	$v0, 4		# print_str of msg
	la   	$a0, msg 	# load address of str msg
	syscall 

# read the FLOAT value from keyboard
	li   	$v0, 6 		# read_float
	syscall

# save FLOAT value
	lwc1	$f1, zero	# set $f1 to 32 bits value -> zero
	add.s 	$f12, $f0, $f1	# save float input in $f12 from $f0
		
# print float value
	li   	$v0, 2		# print_float
	syscall
	
# Exit
	li $v0, 10
	syscall

