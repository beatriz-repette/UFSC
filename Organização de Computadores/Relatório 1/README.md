# INE5411 - Relatório 1
**Alunas:** Beatriz Reis Repette & Ana Luiza Gobbi

## 1. Exercício 1


### 1.1 Introdução
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
O programa elaborado para resolver o exercício 1 possui 16 linhas na aba *basic* e 12 linhas na aba *source*. Essa diferença ocorre devido à presença de pseudoinstruções, que são traduzidas pelo montador em múltiplas instruções reais que aparecem na aba *basic*, mas aparecem como uma única linha na aba source (com o que nós *de fato* escrevemos como instrução).

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


**Assemble** - Ao montar o programa, vemos a seguinte tela no MARS:
![Parte 1](https://github.com/user-attachments/assets/1a3cb592-a68e-48c9-b6d8-7b56875d5f3c)

Agora, a seguir observamos as atualizacoes feita na tabela de registradores e na memoria de dados a cada instrucao.


**lw $t0, b** - Carrega o valor armazenado em ```b```, 5, para o registrador ```$t0```.

![lw $t0, b](https://github.com/user-attachments/assets/018a9779-7e74-41f0-83e0-9a4ec7287633)


**addi $t1, $t0, 35** - Adiciona 35 ao valor de ```$t0``` e o armazena em ```$t1```, ou seja, armazena 40 em ```$t1```.

![addi $t1, $t0, 35](https://github.com/user-attachments/assets/c227624e-76ba-4a58-bc43-18afafab7cc5)


**lw $t2, e** - Carrega o valor armazenado em ```e```, 10, para o registrador ```$t2```.

![lw $t2, e](https://github.com/user-attachments/assets/df9fdd08-87ab-42f7-acd1-c30b16100bbb)


**add  $t3, $t1, $t2** - Adiciona os valores de ```$t1``` e ```$t2``` (```40 + 10 = 50```) e armazena o resultado em ```$t3```.

![add  $t3, $t1, $t2](https://github.com/user-attachments/assets/85a264fc-2180-4675-bb3c-0b955fff3f1d)


**lw $t4, d** - Carrega o valor armazenado em ```d```, 2, para o registrador ```$t4```.

![lw $t4, d](https://github.com/user-attachments/assets/fb83eac2-ed99-4e85-989b-21ff02e6957d)


**add $t5, $t4, $t4** - Adiciona o valor de ```$t4``` consigo mesmo (``` 2 + 2```, simulando ```d^2```) e armazena o resultado em ```$t5```.

![add $t5, $t4, $t4](https://github.com/user-attachments/assets/de0632fd-d821-4e24-86fd-0afaa749448c)


**add $t6, $t5, $t5** - Adiciona, mais uma vez, o valor de ```$t5``` consigo mesmo (``` 4 + 4```, simulando ```d^2 * d = d^3```) e armazena o resultado em ```$t6```.

![add $t6, $t5, $t5](https://github.com/user-attachments/assets/b2d9d985-1e73-4ecb-848e-a540e958f28c)


**sub $s0, $t6, $t3** - Subtrai o valor de ```$t3``` de ```$t6``` (```8 - 50 = -42```) e armazena o resultado em ```$s0```.

![sub $s0, $t6, $t3](https://github.com/user-attachments/assets/f23ac1b8-8a58-4ca8-b551-62e394e491bf)


**la $t0, c** - Aqui, salvamos o endereço de ```c``` em ```$t0``` para, na próxima instrução, podermos armazenar o valor de ```$s0``` (resultado do cálculo) no local correto da memória de dados.

![la $t0, c](https://github.com/user-attachments/assets/c39bdcf6-ffc6-4dd5-985c-7ccec7716469)


**sw $s0, 0($t0)** Por fim, armazenamos o resultado final do cálculo em ```c```, na memória de dados.

![sw $s0, 0($t0)](https://github.com/user-attachments/assets/46ab1277-ad90-42f4-97f1-ef5d76c40ea1)


### 1.6 Conclusão
Embora não tenhamos conseguido implementar uma solução para um valor genérico de ```d```, considerando a restrição de que ```d = 2```, o código escrito resolve corretamente as duas equações propostas no problema.

Depois da elaboração do código e da escrita dessa parte do relatório, descobrimos a importância de sempre finalizar o programa com a chamada de sistema correspondente à finalização (syscall com o código 10). Assim, embora as capturas de tela sejam de uma versão anterior do código e não mostrem essa instrução, o seguinte trecho foi posteriormente adicionado:
'''assembly
li $v0, 10
syscall
 '''
Com isso, garantimos que o programa seja finalizado corretamente, evitando erros ou comportamentos inesperados durante a execução.



## 2. Exercício 2


### 2.1 Introdução
Nosso objetivo no exercício 2 é aprimorar o código desenvolvido no exercício 1, implementando entrada de dados via teclado (para os valores que serão armazenados em ```b```, ```d``` e ```e```) e exibindo o valor final do cálculo, armazenado em ```c```, no console.
A lógica de resolução do problema e sua implementação permanecem as mesmas do exercício anterior. As únicas modificações foram a inserção de trechos e comandos para receber os valores das variáveis via teclado e exibir a resposta final.
Por isso, nesta seção abordaremos apenas a parte inédita do código, sem repetir a explicação da implementação e execução da solução, já discutidas no Tópico 1.


### 2.2 Características Gerais do Programa
Com a adição dos mecanismos de entrada e saída (I/O), nosso código passou a ter 33 linhas na aba *basic* e 25 na aba *source*. A razão para essa diferença permanece a mesma do exercício anterior: comandos como ```la``` e ```lw``` (quando envolve endereços de memória) usam mais instruções, resultando em um número maior de linhas em *basic*.

### 2.3 *Syscall*: Métodos de Leitura e Escrita de Inteiros
Para receber valores do teclado e exibir dados no console, utilizamos chamadas de sistema (*syscalls*).
Em Assembly, existem diferentes códigos de operação para syscalls: o código 5 é utilizado para a leitura de inteiros, e o código 1 para a impressão de inteiros.

Para realizar a leitura dos valores, começamos armazenando em ```$v0``` o código da operação desejada. Em seguida, fazemos a chamada de sistema com *syscall* e, por fim, armazenamos o valor agora contido em ```$v0``` na variável correspondente (```b```, ```d``` ou ```e```, respectivamente).
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

Para exibir o resultado no console, iniciamos carregando o endereço da variável ```c``` em ```$t1``` com a instrução ```la```. Em seguida, utilizamos ```lw``` para carregar o valor armazenado nesse endereço (ou seja, o conteúdo de ```c```) para o registrador ```$a0```, que é o registrador responsável por armazenar o valor a ser impresso. Depois disso, colocamos o código da operação de impressão de inteiro (1) em $v0 e, por fim, realizamos a chamada de sistema.
```
# exibindo o resultado
li $v0, 1  # a operacao 1 eh de impressao de inteiro
move $a0, c  # move o valor de c para a0 (pra imprimir)
syscall
```

### 2.4 Execução do Programa
**Assemble** - Ao montar o programa, vemos a seguinte tela no MARS:
![Inicio exercicio 2](https://github.com/user-attachments/assets/20164851-6033-45dc-bf1f-86de383abc74)

**Syscall - Input** - Logo após o início da execução do código, o usuário deve fornecer, por meio do teclado, os valores desejados para as variáveis ```a```, ```d```, e ```e```, respectivamente. Nas imagens abaixo, é possível observar como esses valores são alocados em registradores e armazenados na memória de dados.
![Input 1](https://github.com/user-attachments/assets/2117d4c0-a7e5-41dc-9979-69b8af24349e)
![Input 2](https://github.com/user-attachments/assets/1a42a73e-2dca-4701-89e8-914b14f2e711)
![Input 3](https://github.com/user-attachments/assets/92f17fc6-be5e-48e3-a8c1-29acca366ad2)
Neste exemplo, foram utilizados os valores ```a = 5```, ```d = 2``` e ```e = 20``` para as variáveis. Reforçamos, mais uma vez, que embora os valores de```a``` e ```e``` possam ser escolhidos livremente, ```d``` deve obrigatoriamente assumir o valor 2, conforme a limitação estabelecida anteriormente.

**Lógica de Resolução** - Após receber as entradas e armazená-las na memória de dados, o código segue a mesma lógica de execução apresentada no exercício anterior, até o momento em que a resposta final é exibida no console.

**la $t1, c** - Este comando inicia a inicio da preparação para exibir o valor final no console. Nesse passo, o endereço de ```c``` na memória de dados é carregado para o ```$t1```.
![la $t1, c](https://github.com/user-attachments/assets/22ae62c9-b9b4-4be1-a324-33eb91c9278b)

**lw $a0, 0($t1)** - O valor armazenado na posição de memória de ```c``` é carregado para o registrador ```$a0```, que será utilizado para a impressão.
![lw $a0, 0($t1)](https://github.com/user-attachments/assets/8e83ead9-5448-4758-8047-7ae236c12a27)

**li $v0, 1** - O código de operação para a impressão de inteiro é armazenado em ```$v0```.
![li $v0, 1](https://github.com/user-attachments/assets/58a9b854-7b1b-4ad7-ad66-c7162596612c)

Depois desses comandos, é realizada a chamada de sistema (*syscall*) que exibe no console o valor presente em ```$a0```, ou seja, o resultado final da operação. Por fim, o programa é encerrado, como mostrado na imagem abaixo.
![encerrado](https://github.com/user-attachments/assets/dc887cdc-bb4c-4d11-a26d-ee9c772cd63a)


### 2.5 Conclusão
Após a implementação da lógica principal do código responsável por resolver as equações propostas, a adição dos elementos de entrada e saída (I/O) foi bastante simples.

Entretanto, considerando que, no nosso programa, o valor de ```d``` está restrito a 2, uma possível melhoria seria fixar esse valor diretamente no código, impedindo que o usuário o modifique. Essa abordagem evitaria a inserção de valores inválidos por usuários desavisados, tornando a execução mais segura e controlada. A implementação não seguiu essa abordagem, pois optamos por seguir as orientações propostas no enunciado do exercício. No entanto, essa alternativa deveria ser considerada para uma possível versão futura do programa.

## 3. Exercício 3

### 3.1 Introdução
Para esse exercicio, precisamos montar um codigo em Assembly que exibisse em um display de 7 segmentos de forma sequencial os numeros de 0 a 9. Decidimos resolver esse problema vinculando cada numero a um codigo binario de display correspondente e enviando esses codigos a um endereco de memoria responsavel pela renderizacao do display. Ao final da sequencia, o programa reinicia, formando um loop infinito.

### 3.2 Características Gerais do Programa
Dessa vez, nosso programa teve 16 linhas na aba *basic* e 13 na aba *source*. A disparidade foi causada novamente pelas instruções que usamos no *source*, como o ```la```, que, quando convertidas pelo assembly, geram mais de uma instrução de fato.

### 3.3 Implementação da Resolução
**digits**
```assembly
digits: 
    .word 0x3F   # 0
    .word 0x06   # 1
    .word 0x5B   # 2
    .word 0x4F   # 3
    .word 0x66   # 4
    .word 0x6D   # 5
    .word 0x7D   # 6
    .word 0x07   # 7
    .word 0x7F   # 8
    .word 0x6F   # 9
```
Nessa parte do código, declaramos e armazenamos em 'digits' os códigos binários responsáveis por acender cada um dos dígitos no display. Cada número é armazenado em uma palavra de 4 bytes para padronizar o código, mas somente o byte menos significativo será utilizado para acender os segmentos do display (já que o display espera um valor de 1 byte).

**main**
```assembly
main:
    la $t0, digits # $t0 recebe o endereco de digits na mem (sera usado pra percorrer o vetor)
    li $t1, 0xFFFF0010 # $t1 recebe o endereco do display (carregar nums aqui)
    li $t2, 0  # $t2 sera o contador, inicia em
```
A função main inicializa o programa preparando as variáveis e o ambiente necessário para a execução. Primeiramente, ela armazena o endereço do vetor digits, que contém os códigos binários correspondentes aos números de 0 a 9, em um registrador. Esse vetor será percorrido para acessar os valores que acendem os segmentos do display de 7 segmentos. Em seguida, o endereço do display também é armazenado em outro registrador, para que os valores sejam enviados corretamente para o display. O contador é iniciado em zero, e ele será usado para controlar quantos números já foram exibidos, indo de 0 até 9.

**loop**
```assembly
loop:
    lw $t3, 0($t0) # $t3 recebe a palavra atual do display
    sb $t3, 0($t1) # envia o byte menos significativo pro display (ele determina o num)

    li $v0, 32  # a operacao 32 eh de espera
    li $a0, 500  # espera 500 ms
    syscall

    addi $t0, $t0, 4  # avanca para o proximo num do vetor
    addi $t2, $t2, 1  # incrementa o contador
    
    li $t4, 10
    blt $t2, $t4, loop  # se $t2 < 10 ainda precisamos percorrer o loop

    j main # reinicia caso o loop ja tiver sido percorrido
```
O loop tem a responsabilidade de percorrer os valores do vetor digits, enviando-os para o display de forma sequencial. Para cada iteração, o código carrega o valor correspondente ao número atual do vetor, envia esse valor para o display e então aguarda 500 milissegundos para que o número fique visível. Após isso, o contador é incrementado, e o programa verifica se todos os números de 0 a 9 foram exibidos. Se o contador atingir 10, o ciclo se reinicia e os números começam a ser mostrados novamente, criando um efeito de contagem contínua no display de 7 segmentos. Esse processo se repete indefinidamente, proporcionando uma exibição cíclica dos números no display.

### 3.4 Execução do Programa
Tudo ocorreu conforme o esperado na execução, todos os valores foram exibidos no display corretamente.
![Image](https://github.com/user-attachments/assets/c9bae86f-6725-4939-b015-e240167034c9)

### 3.5 Conclusão
Sentimos que a dificuldade aumentou bastante do exercício anterior para este, pois gastamos muito tempo pensando e testando diferentes implementações. Por fim, chegamos a uma solução que funcionasse, mas foi a um custo muito maior do que nos itens anteriores.
