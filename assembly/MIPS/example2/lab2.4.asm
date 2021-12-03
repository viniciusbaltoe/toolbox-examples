	.data 0x10010000

var1:	.word 0x00000014 	# 20
var2:	.word 0x00000013 	# 19		
	
	.extern	ext1 4
	.extern	ext2 4
	
	.text
main:	

	# Armazenamento das variáveis nos registradores
	
	lw	$t0,	var1	# Armazena var1 no registrador $t0. -> $t0 = var1
	lw	$t1,	var2	# Armazena var2 no registrador $t1. -> $t1 = var2
	
	# Mudança de memória nos endereços externos
	
	sw	$t0, ext2	# Armazena no endereço de ext2 o valor de var1 ($t0).
	sw	$t1, ext1	# Armazena no endereço de ext1 o valor de var2 ($t1).

	li 	$v0, 10		# Exit
	syscall
	
