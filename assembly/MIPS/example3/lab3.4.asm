	.data	0x10010000
	
meu_vetor:	.space	40 	# Vetor de 10 words

	
	.text
main:	
	# Armazenamento das variáveis 	nos registradores
	li	$a0,	0
	addu	$t1,	$a0,	$0	# j <- 1019107790
	
	la	$t2,	meu_vetor	# Carrega o endereço de meu_vetor em $t2
	
	li	$a0,	0
	addu	$t3,	$a0,	$0	# i = t3 = 0
	li	$a1,	10
	addu	$t4,	$a1,	$0	# t4 = 10
	
	# Loop
Loop:	
	ble	$t4,	$t3, 	Exit	# Se t3 > t4, exit
	sw	$t1,	0($t2)		# Armazena em t2 (meu_vetor) o valor de t1
	addiu	$t2,	$t2,	4	# Acréscimo de word
	addi	$t1,	$t1,	1	# j++
	
	addi 	$t3,	$t3,	1	# i++ para o for
	j	Loop
Exit:
	li 	$v0, 10		# Exit
	syscall
	
