		.data 0x10000000
		
msg:		.asciiz "Digite um n�mero inteiro: 1- "
msg2:		.asciiz "Digite um n�mero inteiro: 2- "
msg_longe:	.asciiz "Estou longe."
msg_perto:	.asciiz "Estou por perto."
		
		.text
main: 		
	# Envio de msg1
	li	$v0, 	4		# print_str
	la  	$a0,	msg 		# endere�o da string msg
	syscall 
	li  	$v0,	5 		# read_int
	syscall
	addu	$t0,	$v0,	$0	# t0 = primeiro numero

	# Envio de msg2
	li  	$v0,	4		# print_str
	la   	$a0, 	msg2 		# endere�o da string msg2
	syscall 
	li   	$v0, 	5 		# read_int
	syscall
	addu 	$t1, 	$v0, 	$0	# t1 = segundo numero
	
	# --------- Verifica��o das vari�veis ------------- #
	
	beq 	$t0,	$t1	longe	# Se t0 == t1, chama longe
	
	li   	$v0, 	4		# print_str
	la  	$a0, 	msg_perto 	# endere�o da string msg_perto
	syscall
	beq	$0,	$0,	Exit
longe:
	li  	$v0, 	4		# print_str
	la  	$a0, 	msg_longe 	# endere�o da string msg_longe
	syscall

Exit:
	li 	$v0, 10			# Exit
	syscall


