	.data	0x10010000

var1:		.word	0x785923ce 	# 2019107790 em hexadecimal

	.text
main:	

	# Armazenamento das variaveis nos registradores
	
	lw	$t7,	var1	# Armazena var1 no registrador $t7. -> $t7 = var1
	
	# Preparing for read nuttons
	lui     $t8 0xffff
	
Loop:	
	# Read the buttons from Digital Lab Sim
	bgt	$t1,	0, 	Translate

        move    $t1 $zero               # scans accumulator
        li      $t0 1                   # 1st row
        sb      $t0 0x12($t8)           # scan
        lb      $t0 0x14($t8)           # get result
        or      $t1 $t1 $t0             # apply it to accumulator
        
        li      $t0 2                   # 1nd row
        sb      $t0 0x12($t8)
        lb      $t0 0x14($t8)
        or      $t1 $t1 $t0
        
        li      $t0 4                   # third row
        sb      $t0 0x12($t8)
        lb      $t0 0x14($t8)
        or      $t1 $t1 $t0
        
        li      $t0 8                   # fourth row
        sb      $t0 0x12($t8)
        lb      $t0 0x14($t8)
        or      $t1 $t1 $t0

	j	Loop

Translate:
	# Traduz o código recebido para hexadecimal
	beq	$t1,	0x21,	T1
	beq	$t1,	0x41,	T2
	beq	$t1,	0x81,	T3
	beq	$t1,	0x12,	T4
	beq	$t1,	0x22,	T5
	beq	$t1,	0x42,	T6
	beq	$t1,	0x82,	T7
	beq	$t1,	0x14,	T8
	beq	$t1,	0x24,	T9
	beq	$t1,	0x44,	Ta
	beq	$t1,	0x84,	Tb
	beq	$t1,	0x18,	Tc
	beq	$t1,	0x28,	Td
	beq	$t1,	0x48,	Te
	beq	$t1,	0x88,	Tf
	
T1:
	li	$t2,	1
	j	Print
T2:
	li	$t2,	2
	j	Print
T3:
	li	$t2,	3
	j	Print
T4:
	li	$t2,	4
	j	Print
T5:
	li	$t2,	5
	j	Print
T6:
	li	$t2,	6
	j	Print
T7:
	li	$t2,	7
	j	Print
T8:
	li	$t2,	8
	j	Print
T9:
	li	$t2,	9
	j	Print
Ta:
	li	$t2,	0xa
	j	Print
Tb:
	li	$t2,	0xb
	j	Print
Tc:
	li	$t2,	0xc
	j	Print
Td:
	li	$t2,	0xd
	j	Print
Te:
	li	$t2,	0xe
	j	Print
Tf:
	li	$t2,	0xf
	j	Print

	
Print:
	div 	$t7,	$t2	# Divide a matrícula pelo int recebido
	mfhi 	$t3 	# Resto da divisão #
	
	# Traduz o hexadecimal para o código de print
	beq	$t3,	0,	T_0
	beq	$t3,	1,	T_1
	beq	$t3,	2,	T_2
	beq	$t3,	3,	T_3
	beq	$t3,	4,	T_4
	beq	$t3,	5,	T_5
	beq	$t3,	6,	T_6
	beq	$t3,	7,	T_7
	beq	$t3,	8,	T_8
	beq	$t3,	9,	T_9
	beq	$t3,	0xa,	T_a
	beq	$t3,	0xb,	T_b
	beq	$t3,	0xc,	T_c
	beq	$t3,	0xd,	T_d
	beq	$t3,	0xe,	T_e

T_0:
	li	$t3,	0x3f
	j	Exit
T_1:
	li	$t3,	0x6
	j	Exit
T_2:
	li	$t3,	0x5b
	j	Exit
T_3:
	li	$t3,	0x4f
	j	Exit
T_4:
	li	$t3,	0x66
	j	Exit
T_5:
	li	$t3,	0x6d
	j	Exit
T_6:
	li	$t3,	0x7d
	j	Exit
T_7:
	li	$t3,	0x7
	j	Exit
T_8:
	li	$t3,	0x7f
	j	Exit
T_9:
	li	$t3,	0x6f
	j	Exit
T_a:
	li	$t3,	119
	j	Exit
T_b:
	li	$t3,	0x7f
	j	Exit
T_c:
	li	$t3,	0xf
	j	Exit
T_d:
	li	$t3,	0xf
	j	Exit
T_e:
	li	$t3,	0xf
	j	Exit
	
Exit:
	# Printar no Painel
    	# letra v = 62 'U'
    	li 	$t4,	62
    	sb 	$t4, 	0xFFFF0011    # Inicial na esquerda
    	sb	$t3, 	0xFFFF0010    # Resto na direita
    	
	# Exit
	li 	$v0, 10		# Print
	syscall
