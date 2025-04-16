# Relatório 1 - INE5411
**Alunas:** Beatriz Reis Repette e Ana Luiza Gobbi

## 1. Exercício 1


### 1.1 Introducao
O exercício proposto consiste em implementar duas equações de alto nível na linguagem de montagem Assembly.
```
a = b + 35
c = d^3 - (a + e)
```
Para realizar esses cálculos, declaramos as variáveis b, c, d e e na memória de dados e atribuímos valores iniciais a elas. Para esta resolução, escolhemos os seguintes valores iniciais:
```
b = 5
c = 0
d = 2
e = 10
```

### 1.2 Características Gerais do Programa
O programa elaborado para resolver o exercício 1 possui 14 linhas na aba *basic* e 10 linhas na aba *source*. Essa diferença ocorre devido à presença de pseudoinstruções, que são traduzidas pelo montador em múltiplas instruções reais que aparecem na aba *basic*, mas aparecem como uma única linha na aba source (com o que nós *de fato* escrevemos como instrução).

Em nosso código, utilizamos a instrução ```la```, que, na verdade, é interpretada como duas instruções: ```lui``` e ```ori```. Além disso, ao utilizarmos a instrução ```lw``` para carregar o valor de uma variável da memória de dados, o MARS insere automaticamente a instrução ```lui``` antes de ```lw``` (como o MARS não é capaz de manipular endereços de 32 bits inteiros de uma só vez, como é o caso dos endereços de memória, é necessário dividi-los em partes superiores e inferiores), o que também contribui para o aumento no número de linhas na aba *basic*.


### 1.3 Declaracao das Variaveis em Memoria de Dados
```assembly
.data  # usa-se data para armazenar as variaveis declaradas a seguir em memoria de dados

b: .word 5  # inicializa a variavel b com o valor 5
d: .word 2
e: .word 10
c: .word 0 #inicializa com 0, depois c vai armazenar a variavel final
```
Observa-se que a variável ```a``` não foi declarada na memória de dados. Como ela será utilizada apenas para armazenar o resultado intermediário da operação ```b + 35```, e logo em seguida será usada em outro cálculo, é possível mantê-la em um registrador. Além disso, é importante destacar que a variável ```c``` é inicializada com zero, mas será utilizada posteriormente para armazenar o resultado da segunda expressão.


### 1.4 Implementação da Resolução
A seguir, detalham-se as etapas de implementação utilizadas para resolver o problema proposto, bem como suas limitações.

#### a = b + 35
No trecho a seguir, o valor de ```b``` é carregado da memória para o registrador ```$t1```. Em seguida, somamos 35 a esse valor utilizando a instrução ```addi```, e o resultado é armazenado em ```$t2```, que é utilizado como registrador temporário para representar ```a```. Como a é usado apenas como intermediário no cálculo de ```c```, não há necessidade de armazená-lo na memória.
```assembly
la $t0, b         # carrega o endereco da variavel b
lw $t1, 0($t0)    # carrega o valor de b no registrador $t1

addi $t2, $t1, 35 # t2 = a = b + 35
```

#### c = d³ - (a + e)
Como o uso de instruções de multiplicação (```mul```) e de salto (como ```jump```) foi proibido, não é possível implementar uma multiplicação genérica como ```d * d * d``` para valores arbitrários de ```d```. Uma implementação genérica exigiria, no mínimo, uma estrutura de repetição, pois não se sabe previamente o número de somas necessárias para substituir a operação de multiplicação em cada caso.
Por essa razão, optamos por implementar diretamente o caso específico em que ```d = 2```, realizando as somas manuais necessárias para obter o valor de ```d³ = 2³ = 8```. Esse tipo de solução atende às restrições impostas e resolve corretamente o problema proposto, desde que d assuma o valor 2.
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


### 1.5 Execução do Programa
Para a apresentação das etapas e dos resultados, foram incluídas capturas de tela das alterações na tabela de registradores e na memória de dados a cada comando executado.


**Assemble** - Ao montar o programa, vemos a seguinte tela no Mars
![Parte 1](https://github.com/user-attachments/assets/1a3cb592-a68e-48c9-b6d8-7b56875d5f3c)

Agora, a seguir observamos as atualizacoes feita na tabela de registradores e na memoria de dados a cada instrucao.


**lw $t0, b**

![lw $t0, b](https://github.com/user-attachments/assets/018a9779-7e74-41f0-83e0-9a4ec7287633)


**addi $t1, $t0, 35**

![addi $t1, $t0, 35](https://github.com/user-attachments/assets/c227624e-76ba-4a58-bc43-18afafab7cc5)


**lw $t2, e**

![lw $t2, e](https://github.com/user-attachments/assets/df9fdd08-87ab-42f7-acd1-c30b16100bbb)


**add  $t3, $t1, $t2**

![add  $t3, $t1, $t2](https://github.com/user-attachments/assets/85a264fc-2180-4675-bb3c-0b955fff3f1d)


**lw $t4, d**

![lw $t4, d](https://github.com/user-attachments/assets/fb83eac2-ed99-4e85-989b-21ff02e6957d)


**add $t5, $t4, $t4**

![add $t5, $t4, $t4](https://github.com/user-attachments/assets/de0632fd-d821-4e24-86fd-0afaa749448c)


**add $t6, $t5, $t5**

![add $t6, $t5, $t5](https://github.com/user-attachments/assets/b2d9d985-1e73-4ecb-848e-a540e958f28c)


**sub $s0, $t6, $t3**

![sub $s0, $t6, $t3](https://github.com/user-attachments/assets/f23ac1b8-8a58-4ca8-b551-62e394e491bf)


**la $t0, c** - Aqui, salvamos o endereco de c em $t0 para na proxima instruacao poder carregar o valor de $s0 (da resposta do calculo) para o lugar certo da memoria de dados.

![la $t0, c](https://github.com/user-attachments/assets/c39bdcf6-ffc6-4dd5-985c-7ccec7716469)


**sw $s0, 0($t0)**

![sw $s0, 0($t0)](https://github.com/user-attachments/assets/46ab1277-ad90-42f4-97f1-ef5d76c40ea1)


### 1.6 Conclusao
Embora nos nao tenhamos conseguido implementar uma solucao para um d generico, dada a restricao onde d = 2, o codigo escrito resolve de forma correta as duas equacoes dadas pelos problema.



## 2. Exercício 2


### 2.1 Introducao
Nosso objetivo no exercicio 2 eh aprimorar o codigo feito para o exercicio 1, implementando input por teclado (para os valores que serao armazenados em 'b', 'd' e 'e') e exibindo o valor final da conta, armazenado em 'c', no console. A logica de resolucao do problema e sua implementacao sao as mesmas do exercicio anterior, as unicas modificacoes foram a insercao de trechos e comandos para receber o valor das variaveis do teclado e exibir a resposta final. Por isso, nessa sessao cobriremos apenas a parte inedita do codigo, nao repetindo a explicacao da implementacao e execucao da solucao, ja vistas no topico 1.


### 2.2 Syscal: Metodos de Leitura e Escrita de Inteiros
Para receber valores do teclado e exibir dados no console precisamos fazer chamadas de sistema. Em assembly, exietsm metodos/funcoes para o syscal, sendo o 5 para leitura de inteiro e 1 para impressao de inteiro. 

Para fazer a leitura de valores, comecamos por armazenar em $v0 o valor da instrucao que deseja-se fazer. Depois, fazemos a chamada de syscal e terminamos armazenando o valor que agora esta em $v0 na variavel correspondente ('b', 'd' e 'e', respectivamente).
```
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
```

Para exibir o resultado no console, comecamos guardando em $v0 a instrucao para impressao de inteiro (nesse caso, 1), move o valor de c para $a0 o valor a ser impresso e, por fim, faz a chamada de sistema.
```
# exibindo o resultado
li $v0, 1  # a operacao 1 eh de impressao de inteiro
move $a0, c  # move o valor de c para a0 (para imprimir)
syscall
```

### 2.3 Execucao do Programa
**Assemble** - Ao montar o programa, vemos a seguinte tela no Mars
![Inicio exercicio 2](https://github.com/user-attachments/assets/6609553a-114c-4075-b482-cbc345d919a6)
