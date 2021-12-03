
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
	
	lui	$1, 0x00001001		# Carrega os 16bits mais significativos da variável de entrada 
					# e preenche os 16 outrs bits com zero.
	lw	$t5, 0x00($at)		# Armazena var1 no registrador $t5. -> $t5 = var1
	lw	$t6, 0x04($at)		# Armazena var2 no registrador $t6. -> $t6 = var2
	lw	$t7, 0x08($at)		# Armazena var3 no registrador $t7. -> $t7 = var3
	lw	$t8, 0x0c($at)		# Armazena var4 no registrador $t8. -> $t8 = var4
	
	# Mudança de memória nos endereços
	
	lui	$t1, 0x00001001		# Carrega os 16bits mais significativos da variável de entrada 
					# e preenche os 16 outrs bits com zero.
	sw	$t5, 0x0c($at)		# Armazena no endereço 0x0c($at) o valor de var1 ($t5).
	sw	$t6, 0x08($at)		# Armazena no endereço 0x08($at) o valor de var2 ($t6).
	sw	$t7, 0x04($at)		# Armazena no endereço 0x04($at) o valor de var3 ($t7).
	sw 	$t8, 0x00($at)		# Armazena no endereço 0x00($at) o valor de var4 ($t8).
 	
	addiu $2, $0, 0xa		# Exit
	syscall

