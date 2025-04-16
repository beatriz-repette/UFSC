# Relatório 1 - INE5411
**Alunas:** Beatriz Reis Repette e Ana Luiza Gobbi

## 1. Exercício 1
Nesse exercicio, nos implementamos duas equacoes de alto nivel na linguagem de montagem Assembly, podendo escolher os valores para as variaveis.


### 1.1 Introducao
O exercico proposto consiste em implementar duas equacoes de alto nivel na linguagem de montagem Assembly. 
$$
a = b + 35
c = d^3 - (a + e)
$$
Para realizar esses calculos, declaramos as variaveis b, c, d e e na memoria de dados e atribuimos valores iniciais a essas variaveis. Para essa resolucao escolhemos os seguintes valores de inicio:
$$
b = 5
c = 0
d = 2
e = 10
$$
Observamos que a variavel 'a' nao foi declarada em memoria de dados. Como essa variavel sera usada apenas para armazenar o valor do resultado inicial da operacao "b + 35" e logo depois sera usado em outro calculo, podemos mante-lo em um registrador. Alem disso, eh importante destacar que a variavel 'c' eh inicializada em zero, mas servira mais tarde para armazenar o resultado da segunda expressao.

### 1.2 Caracteristicas Gerais do Programa
O programa elaborado para resolver esse exercicio tem 33 linhas de codigo. *Adicionar mais infos conforme necessario!*

### 1.3 Declaracao das Variaveis em Memoria de Dados
```assembly
.data  # usa-se data para armazenar as variaveis declaradas a seguir em memoria de dados

b: .word 5  # inicializa a variavel b com o valor 5
d: .word 2
e: .word 10
c: .word 0 #inicializa com 0, depois c vai armazenar a variavel final
```

Percebe-se que "a" nao foi declarada na memoria de dados. Como "a" eh um avariavel temporarea que eh usada para pegar o resultado da primeira equacao e ja eh usado para calcular o valor da segunda, nao faz sentido declarar esse valor em memoria, ele eh temporareo

### Implementacao da Resolucao
A seguir, exemplifica-se cada etapa de implementacao para bem resolver o problema proposto, e suas limitacioes.

#### a = b + 35
No trecho a seguir, o valor 'b' é carregado da memória para o registrador $t1. Em seguida, somamos 35 a esse valor utilizando a instrução addi, e o resultado é armazenado em $t2, que usamos como registrador temporário para representar 'a'. Como a é usado apenas como intermediário no cálculo de c, não ha necessidade em armazená-lo em memória.
```assembly
la $t0, b         # carrega o endereco da variavel b
lw $t1, 0($t0)    # carrega o valor de b no registrador $t1

addi $t2, $t1, 35 # t2 = a = b + 35
```

#### c = d^3 - (a + e)
Como o uso de instrucoes de multiplicacao (mul) e de salto (jump, por exemplo) foi proibido, nao eh possivel implementar uma multiplicacao generica como d * d * d para valores arbitrarios d. Uma implementacao gnerica exigiria uma estrutura de repeticao, no minimo, pois nao temos como saber de antemao o numero de somas que teriamos que fazer para substituir a funcao mul para cada numero.
Por isso, optamos por implementar diretamente o caso especifico em que d = 2, realizando as somas manuais necessarias para chegar ao valor de d^3 = 2^3 = 8. Esse tipo de solucao atende as restricoes impostas e resolve corretamente o problema proposto, dado que d assuma o valor de 2.
```assembly
# a + e
lw $t2, e  # t2 = 10
add $t3, $t1, $t2  # t3 = a + e = 40 + 10 = 50
	
# calculando d^3 manualmente para d = 2
lw $t4, d

# Passo 1: fazendo d^2 = d + d para d = 2
add $t5, $t4, $t4

#Passo 2: fazendo d^2 * d = (d + d) + (d + d)
add $t6, $t5, $t5
	
# c = $t6 - $t3 = d^3 - (a + e)
sub $s0, $t6, $t3
```

#### Armazenando o valor 'c' na memoria
```assembly
la $t0, c  # o endereco de 'c' é carregado para t0
sw $s0, 0($t0)  # o valor em s0 é armazenado no endereco de memoria indicado em t0, ou seja, no c
```

### 1.2 Execucao do Programa
Para a apresentacao das etapas e resultados, exibiremos fotos do programa sendo executado, passo a passo.


![Memoria de dados ao final da execucao](https://github.com/user-attachments/assets/43a084a3-4d7f-4584-9156-5f2f4762bf9e)

![Registradores ao final da execucao](https://github.com/user-attachments/assets/5c201bdc-a1f3-4d7d-af1e-bdca0aec3efa)
