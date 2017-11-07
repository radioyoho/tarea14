.text
#inicializar valores en parametros
addi $a0, $zero, 0x40490fd8
addi $a1, $zero, 0x402df851

#tomar los recursos necesarios (separar)
#exponentes
andi $s0, $a0, 0x7f800000
srl $s0, $s0, 23
andi $s1, $a1, 0x7f800000
srl $s1, $s1, 23

#signo
andi $s2, $a0, 0x80000000
srl $s2, $s2, 31
andi $s3, $a1, 0x80000000
srl $s3, $s3, 31

#mantisa
andi $s4, $a0, 0x007fffff
andi $s5, $a1, 0x007fffff

#mantisa con uno
ori $t2, $s4, 0x00800000
ori $t1, $s5, 0x00800000


#diferencia de exponentes
sub $t0, $s0, $s1

beq $t0, $zero, compararsigno
#si es igual a 0 saltarse shift
#si es diferente de 0 SHIFT

shift: 
	srl $t1, $t1, 1
	addi $t0, $t0, -1
	bne $t0, $zero, shift
	
compararsigno:
	beq $s2, $zero, pos
	#primer num es negativo, suma de negativos con signo negativo
	addi $v1, $zero, 1
	j suma
pos: 
	beq $s3, $zero, suma
	#si es sero, suma de positivos
	#si es uno, resta
	j resta

suma: 
	add $t3, $t2, $t1
	#checar el bit 25, si es 1, aumentar exponente, shift right
	andi $s6, $t3, 0x01000000
	srl $s6, $s6, 24
	beq $s6, $zero, terminar 
	srl $t3, $t3, 1
	addi $s0, $s0, 1
	j terminar
resta:
	sub $t3, $t2, $t1
	#checar bit 24, si es 0, shift left, restar exponente
shiftres:
	andi $s6, $t3, 0x00800000
	srl $s6, $s6, 23
	bne $s6, $zero, terminar
	sll $t3, $t3, 1
	addi $s0, $s0, -1
	j shiftres
	
terminar:
	sll $v1, $v1, 31
	sll $s0, $s0, 23
	andi $t3, $t3, 0x007fffff
	
	or $v0, $v0, $v1
	or $v0, $v0, $s0
	or $v0, $v0, $t3
	
	
	
