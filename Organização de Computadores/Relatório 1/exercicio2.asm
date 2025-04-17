# Questao 1

.data  # usa-se data para armazenar as variaveis declaradas a seguir em memoria de dados

b: .word 5  # inicializa a variavel b com o valor 5
d: .word 2
e: .word 10
c: .word 0  # inicializa com 0, depois c vai armazenar o valor final


.text  # indica sessao do programa
main:
	# entrada de dados
	li $v0, 5  # a operacao 5 eh ler um inteiro
	syscall
	sw $v0, b  # armazena em b

	li $v0, 5  # input de d
	syscall
	sw $v0, d

	li $v0, 5  # input de e
	syscall
	sw $v0, e
	
	# a = b + 35
	# comecamos carregando os valores da memoria para regs
	lw $t0, b #t0 = 5
	addi $t1, $t0, 35  # t1 = b + 35
	# como o valor de 'a' nao vai para a memoria de dados, nao precisamos de sw e a mantemos em t1
	
	# a + e
	lw $t2, e  # t2 = 10
	add $t3, $t1, $t2  # t3 = a + e = 40 + 10 = 50
	
	# calculando d^3 manualmente para d = 2
	lw $t4, d
	# Passo 1: fazendo d^2 para d = 2
	add $t5, $t4, $t4
	#Passo 2: fazendo d^2 * 2
	add $t6, $t5, $t5
	
	# c = $t6 - $t3 = d^3 - (a + e)
	sub $s0, $t6, $t3
	la $t0, c  # o endereco de 'c' é carregado para t0
	sw $s0, 0($t0)  # o valor em s0 é armazenado no endereco de memoria indicado em t0, ou seja, no c
	
	# exibindo o resultado armazenado em c
	la $t1, c  # carrega o endereço de c em $t1
	lw $a0, 0($t1)  # carrega o valor de c da memória para $a0
	li $v0, 1  # operacao pra imprimir inteiro
	syscall
	
	# encerrar o programa
	li $v0, 10
	syscall