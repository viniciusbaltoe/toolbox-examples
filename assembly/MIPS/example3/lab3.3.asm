	.data	0x10010000

var1:	.word	0x2 	# 2019107790
limit:	.word	100	# 100
	.text
main:	
	# Armazenamento das variáveis 	nos registradores
	
	lw	$t1,	var1	# Armazena var1 no registrador $t1. -> $t1 = var1
	lw	$t2, 	limit	# Armazena limit no registrador $t2. -> $t2 = limit
	
	# Loop
	#move	$t0,	$t1
Loop:	
	ble	$t2,	$t1, 	Exit
	addi 	$t1,	$t1,	1	# t0 = t0 ++
	j	Loop
Exit:
	li 	$v0, 10		# Exit
	syscall
	
