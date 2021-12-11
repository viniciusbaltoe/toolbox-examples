	.data	0x10010000

var1:	.word	0x2 	# 2019107790
var2:	.word 	0x0 	# 0
var3:	.word 	-0x7e5	# 2021	
	
	.text
main:	

	# Armazenamento das variáveis nos registradores
	
	lw	$t1,	var1	# Armazena var1 no registrador $t1. -> $t1 = var1
	lw	$t2,	var2	# Armazena var2 no registrador $t2. -> $t2 = var2
	lw	$t3, 	var3	# Armazena var3 no registrador $t3. -> $t3 = var3
	
	# Comparações IF e Else
	
	bne 	$t1,	$t2,	Else	# Se t1 != t2, chama Else
	sw	$t3,	var1
	sw	$t3,	var2
	
Else:	
	lw 	$t4,	var1
	sw	$t2, 	var1
	sw	$t4,	var2
	beq	$0,	$0,	Exit
	
Exit:
	li 	$v0, 10		# Exit
	syscall
	
