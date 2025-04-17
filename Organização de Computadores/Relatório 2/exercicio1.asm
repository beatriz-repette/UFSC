.data
	# faremos as matrizes row-major
	
	tamanho:.word 9  # tamanho da matriz

	A:	.word 1, 2, 3
		      0, 1, 4
		      0, 0, 1
	
	B:	.word 1, -2, 5
		      0, 1, -4
		      0, 0, 1
		
		
.text
	main:
	
	# Passo 1: Transpor B
	# para trocar os elementos fora da diagonal principal trocamos 1 com 3, 2 com 6 e 5 com 7
	
	la $t0, B  # carrega o endereco de B para $t0
	
	# indices 1 com 3
	lw $t1, 4($t0)  # carrega o valor no indice 1 para $t1
	lw $t2, 12($t0)  # carrega o valor do indice 3 para $t2
	sw $t2, 4($t0)
	sw $t1, 12($t0)
	
	# indices 2 com 6
	lw $t1, 8($t0)
	lw $t2, 24($t0)
	sw $t2, 8($t0)
	sw $t1, 24($t0)
	
	# indices 5 com 7
	lw $t1, 20($t0)
	lw $t2, 28($t0)
	sw $t2, 20($t0)
	sw $t1, 28($t0)
	
	
	# Passo 2: Multiplicar A com B
	
