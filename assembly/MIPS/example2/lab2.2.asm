
	.data	0x10010000
var1: 	.word	0x12		# dia*mes = 18
var2:	.word	0x785923CE	# 2019107790
var3:	.word	0x112D760	# 18012000
var4: 	.word	0x56		# ascii(V) = 86

primeiro:	.ascii 	"v"	# Firstname
ultimo: 	.ascii	"b"	# Lastname

	.text
main:	
	
	# Armazenamento das variáveis nos registradores
	
	lw	$t5, var1	# Armazena var1 no registrador $t5. -> $t5 = var1
	lw	$t6, var2	# Armazena var2 no registrador $t6. -> $t6 = var2
	lw	$t7, var3	# Armazena var3 no registrador $t7. -> $t7 = var3
	lw	$t8, var4	# Armazena var4 no registrador $t8. -> $t8 = var4
	
	# Mudança de memória nos endereços
	
	sw	$t5, var4	# Armazena no endereço de var4 o valor de var1 ($t5).
	sw	$t6, var3	# Armazena no endereço de var3 o valor de var2 ($t6).
	sw	$t7, var2	# Armazena no endereço de var2 o valor de var3 ($t7).
	sw 	$t8, var1	# Armazena no endereço de var1 o valor de var4 ($t8).
 	
	li 	$v0, 10		# Exit
	syscall

