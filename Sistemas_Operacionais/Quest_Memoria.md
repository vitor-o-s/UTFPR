Cap 14 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. Explique em que consiste a resolução de endereços nos seguintes momentos:
codificação, compilação, ligação, carga e execução.

R:
* Codificação: Definida pelo progreamador (usual em assembly)
* Compilação: Compilador define as posições durante a tradução do código fonte
* Ligação: Durante a compilação o compilador gera um arquivo objeto, partindo disto o linker pega a tabela de símbolo e define os endereços de memória
* Carga: Definição dos endereços durante a carga do código para o lançamento do novo processo
* Execução:  Endereços criados durante a execução do processo que são convertidos.

2. Como é organizado o espaço de memória de um processo?

R: De forma geral as principais seções de memória de um processo são:
* Text: código binário do programa (tam fixo) (0-x) (Mode r-x--)
* Data: variáveis inicializadas (tam fixo) (x-y) (Mode rw---)
* BSS: variáveis não inicializadas  (tam fixo) (y-z) (Mode rw---)
* Heap: variáveis dinâmicas (malloc/free) (z-z1) (Mode rw---)
*  Stack: dados usados por funções (parâmetros, variáveis locais, endereços de retorno) (z2-z3) (Mode rw---)
Entre  z1-z2 há um espaço livre para que o Heap e o Stack possam crescer

Cap 15 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. Explique a diferença entre endereços lógicos e endereços físicos e as razões que
justificam o uso de endereços lógicos.

R: 

2. O que é uma MMU – Memory Management Unit?

R:

3. Seria possível e/ou viável implementar as conversões de endereços realizadas
pela MMU em software, ao invés de usar um hardware dedicado? Por que?

R:

4. Sobre as afirmações a seguir, relativas ao uso da memória RAM pelos processos,
indique quais são incorretas, justificando sua resposta:
(a) Os endereços físicos gerados pelo processador são convertidos em endereços
lógicos através da MMU - Memory Management Unit.
(b) O acesso a endereços de memória inválidos é notificado ao processador
através de interrupções geradas pela MMU.
(c) A área de memória TEXT contém o código-fonte a ser compilado e executado
pelo processo.
(d) A área de memória DATA é usada para armazenar todas as variáveis e
constantes usadas pelo processo.
(e) A área de memória HEAP é usada para as alocações dinâmicas de memória,
sendo usada através de funções como malloc e free.
(f) A área de memória STACK contém as pilhas do programa principal e das
demais threads do processo.

5. Explique as principais formas de alocação de memória.

R:

6. Por que os tamanhos de páginas e quadros são sempre potências de 2?

R:

7. Considerando a tabela de segmentos a seguir (com valores em decimal), calcule
os endereços físicos correspondentes aos endereços lógicos 0:45, 1:100, 2:90, 3:1.900 e 4:200.
Segmento 	| 	0 		|	1 	|	2 		|	3 		|	4
Base 		|	44 		|	200 |	0 		|	2.000 	|	1.200
Limite 		|	810		| 	200 | 	1.000	|	1.000 	|	410

R: 

8. Considerando a tabela de páginas a seguir, com páginas de 500 bytes 5 , informe
os endereços físicos correspondentes aos endereços lógicos 414, 741, 1.995, 4.000
e 6.633, indicados em decimal.

página 	|  0 |1   |2|3|4|5|6|7|8|9|10|11|12|13|14|15
quadro	|  3 |12 |6|–|9|–|2|–|0| 5|  –|   –|  –|   7| –  |  1
Um tamanho de página de 500 bytes permite fazer os cálculos mentalmente, sem a necessidade de
converter os endereços para binário e vice-versa, bastando usar divisões inteiras (com resto) entre os
endereços e o tamanho de página

R: 

9. Considere um sistema com endereços físicos e lógicos de 32 bits, que usa tabelas
de páginas com três níveis. Cada nível de tabela de páginas usa 7 bits do
endereço lógico, sendo os restantes usados para o offset. Cada entrada das
tabelas de páginas ocupa 32 bits. Calcule, indicando seu raciocínio:
(a) O tamanho das páginas e quadros, em bytes.
(b) O tamanho máximo de memória que um processo pode ter, em bytes e
páginas.
(c) O espaço ocupado pela tabela de páginas para um processo com apenas uma
página de código, uma página de dados e uma página de pilha. As páginas
de código e de dados se encontram no inicio do espaço de endereçamento
lógico, enquanto a pilha se encontra no final do mesmo.
(d) Idem, caso todas as páginas do processo estejam mapeadas na memória.

10. Explique o que é TLB, qual a sua finalidade e como é seu funcionamento.

R:

11. Sobre as afirmações a seguir, relativas à alocação por páginas, indique quais são
incorretas, justificando sua resposta:
(a) Um endereço lógico com N bits é dividido em P bits para o número de
página e N − P bits para o deslocamento em cada página.
(b) As tabelas de páginas multiníveis permitem mais rapidez na conversão de
endereços lógicos em físicos.
(c) O bit de referência R associado a cada página é “ligado” pela MMU sempre
que a página é acessada.
(d) O cache TLB é usado para manter páginas frequentemente usadas na
memória.
(e) O bit de modificação M associado a cada página é “ligado” pelo núcleo
sempre que um processo modificar o conteúdo da mesma.
(f) O cache TLB deve ser esvaziado a cada troca de contexto entre processos.

R:

12. Por que é necessário limpar o cache TLB após cada troca de contexto entre
processos? Por que isso não é necessário nas trocas de contexto entre threads?

R:

13. Um sistema de memória virtual paginada possui tabelas de página com três
níveis e tempo de acesso à memória RAM de 100 ns. O sistema usa um cache
TLB de 64 entradas, com taxa estimada de acerto de 98%, custo de acerto de 10
ns e penalidade de erro de 50 ns. Qual o tempo médio estimado de acesso à
memória pelo processador? Apresente e explique seu raciocínio.

R:

14. Considerando um sistema de 32 bits com páginas de 4 KBytes e um TLB com 64
entradas, calcule quantos erros de cache TLB são gerados pela execução de cada
um dos laços a seguir. Considere somente os acessos à matriz buffer (linhas 5
e 9), ignorando páginas de código, heap e stack. Indique seu raciocínio.
```
1 |unsigned char buffer[4096][4096] ;
2 |
3 |for (int i=0; i<4096; i++) // laço 1
4 |	for (int j=0; j<4096; j++)
5 |		buffer[i][j] = 0 ;
6 |
7 |for (int j=0; j<4096; j++) // laço 2
8 |	for (int i=0; i<4096; i++)
9 |		buffer[i][j] = 0 ;
```
		
15. Considerando um sistema com tempo de acesso à RAM de 50 ns, tempo de
acesso a disco de 5 ms, calcule quanto tempo seria necessário para efetuar os
acessos à matriz do exercício anterior nos dois casos (laço 1 e laço 2). Considere
que existem 256 quadros de 4.096 bytes (inicialmente vazios) para alocar a
matriz e despreze os efeitos do cache TLB.

Cap 16 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. Explique o que é fragmentação externa. Quais formas de alocação de memória
estão livres desse problema?

R: 

2. Explique o que é fragmentação interna. Quais formas de alocação de memória
estão livres desse problema?

R:

3. Em que consistem as estratégias de alocação first-fit, best-fit, worst-fit e next-fit?

R:

4. Considere um sistema com processos alocados de forma contígua na memória.
Em um dado instante, a memória RAM possui os seguintes “buracos”, em
sequência e isolados entre si: 5K, 4K, 20K, 18K, 7K, 9K, 12K e 15K. Indique
a situação final de cada buraco de memória após a seguinte sequência de
alocações: 12K → 10K → 5K → 8K → 10K. Considere as estratégias de alocação
first-fit, best-fit, worst-fit e next-fit.

R:

5. Considere um banco de memória com os seguintes “buracos” não-contíguos:
	B1		| 	B2 		|	B3 		|	B4		|	 B5 		|	B6
	10MB 	|	4MB	| 	7MB 	| 	30MB 	|	12MB 	|	20MB
Nesse banco de memória devem ser alocadas áreas de 5MB, 10MB e 2MB, nesta
ordem, usando os algoritmos de alocação First-fit, Best-fit ou Worst-fit. Indique a
alternativa correta:
(a) Se usarmos Best-fit, o tamanho final do buraco B4 será de 6 Mbytes.
(b) Se usarmos Worst-fit, o tamanho final do buraco B4 será de 15 Mbytes.
(c) Se usarmos First-fit, o tamanho final do buraco B4 será de 24 Mbytes.
(d) Se usarmos Best-fit, o tamanho final do buraco B5 será de 7 Mbytes.
(e) Se usarmos Worst-fit, o tamanho final do buraco B4 será de 9 Mbytes.

6. Considere um alocador de memória do tipo Buddy binário. Dada uma área
contínua de memória RAM com 1 GByte (1.024 MBytes), apresente a evolução
da situação da memória para a sequência de alocações e liberações de memória
indicadas a seguir.
(a) Aloca A 1 200 MB
(b) Aloca A 2 100 MB
(c) Aloca A 3
(d) Libera A 2
(e) Libera A 1
(f) Aloca A 4 100 MB
(g) Aloca A 5 40 MB
(h) Aloca A 6 300 MB

Cap 17 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. O que é uma falta de página? Quais são suas causa possíveis e como o sistema
operacional deve tratá-las?

R: É quando um processo tenta acessar uma página que está em disco, o núcleo deve verificar se a página é válida e caso sim o processo entra em suspensão até que a página seja recuperada

2. Calcule o tempo médio efetivo de acesso à memória se o tempo de acesso à RAM
é de 5 ns, o de acesso ao disco é de 5 ms e em média ocorre uma falta de página
a cada 1.000.000 (10^6 ) de acessos à memória. Considere que a memória RAM
sempre tem espaço livre para carregar novas páginas. Apresente e explique seu
raciocínio.

R:  t_médio = (((10⁶-1)* 5ns) + 5ms + 5ns)/ 10⁶  = 10 ns Caso a memória não esteja saturada só precisaremos fazer um acesso ao disco Feito a transferencia realizamos mais um acesso a memória (a página carregada)

3. Repita o exercício anterior, considerando que a memória RAM está saturada:
para carregar uma nova página na memória é necessário antes abrir espaço,
retirando outra página.

R:  t_médio = (((10⁶-1)* 5ns) + 2*5ms + 5ns)/ 10⁶ = 15ns Caso a memória esteja saturada precisaremos fazer 2 acessos ao disco (swap in e 1 swap out) Feito a transferencia realizamos mais um acesso a memória (a página carregada)

4. Considere um sistema de memória com quatro quadros de RAM e oito páginas
a alocar. Os quadros contêm inicialmente as páginas 7, 4 e 1, carregadas em
memória nessa sequência. Determine quantas faltas de página ocorrem na
sequência de acesso {0, 1, 7, 2, 3, 2, 7, 1, 0, 3}, para os algoritmos de escalonamento
de memória FIFO, OPT e LRU.

R:  FIFO = 6 fp OPT = 4 fp LRU = 5 fp / Folha 

5. Repita o exercício anterior considerando um sistema de memória com três
quadros de RAM.

R:  FIFO = 6 fp OPT = 5 fp LRU = 7 fp / Folha 

6. Um computador tem 8 quadros de memória física; os parâmetros usados pelo
mecanismo de paginação em disco são indicados na tabela a seguir:

página 	| carga na memória | último acesso 	| bit R 	| bit M
p0		|	14 			     |		58 			|	1 	|	1
p1 		|	97 			     |		97 			|	1	|	0
p2 		|	124 		     |		142 		|	1	|	1
p3 		|	47			     | 	90 				|	0	|	1
p4 		|	29			     |		36 			|	1	|	0
p5 		|	103 		     |		110 		|	0	|	0
p6 		|	131 		     |		136 		|	1 	|	1
p7 		|	72			     |		89			|	0	|	0

Qual será a próxima página a ser substituída, considerando os algoritmos LRU,
FIFO, segunda chance e NRU? Indique seu raciocínio.

R: O FIFO deve substituir a p0, afinal é a primeira na fila. O LRU substituirá a página p4,  já que ela é quem possui o "último acesso" mais antigo. O algoritmo da segunda chance escolherá a página p3 pois ela é a primeira na fila que não foi acessada recentente. Já para o NRU a página escolhida é p5 pois é a primeira página com nível 0 (R=0; M=0)

7. Considere um sistema com 4 quadros de memória. Os seguintes valores são
obtidos em dez leituras consecutivas dos bits de referência desses quadros:
0101, 0011, 1110, 1100, 1001, 1011, 1010, 0111, 0110 e 0111. Considerando o
algoritmo de envelhecimento, determine o valor final do contador associado a
cada página e indique que quadro será substituído.

R:  A página substituida será a p0 / os valores foram p0 = 31; p1 = 227;  p2 = 249; p3 = 172

8. Em um sistema que usa o algoritmo WSClock, o conteúdo da fila circular de
referências de página em tc = 220 é indicado pela tabela a seguir. Considerando
que o ponteiro está em p0 e que τ = 50, qual será a próxima página a substituir?
E no caso de τ = 100?
página 	| último acesso 	| bit R	| bit M
p0 		|	142 		|	1 	|	0
p1 		|	197 		|	0 	|	0
p2 		|	184 		|	0 	|	1
p3 		|	46 			|	0 	|	1
p4 		|	110 		|	0 	|	0
p5 		|	167 		|	0	|	1
p6 		|	97 			|	0 	|	1
p7 		|	129 		|	1 	|	0

R:  No caso de τ = 50 será a p3 (idade =174) já no caso de τ = 100  também será a p3.

9. Sobre as afirmações a seguir, relativas à gerência de memória, indique quais são
incorretas, justificando sua resposta:
(a) Por “Localidade de referências” entende-se o percentual de páginas de um
processo que se encontram na memória RAM.
(b) De acordo com a anomalia de Belady, o aumento de memória de um sistema
pode implicar em pior desempenho.
(c) A localidade de referência influencia significativamente a velocidade de
execução de um processo.
(d) O algoritmo LRU é implementado na maioria dos sistemas operacionais,
devido à sua eficiência e baixo custo computacional. o
(e) O compartilhamento de páginas é implementado copiando-se as páginas a
compartilhar no espaço de endereçamento de cada processo. 
(f) O algoritmo ótimo define o melhor comportamento possível em teoria, mas
não é implementável. 

(a) F, localidade de referencia é a propriedade de um processo ou sistema concentrar seus acessos em poucas áreas da memória a cada instante
(b) V
(c) V
(d) F, ele possui desempenho limitado
(e) F, é feito apontando a tabela de páginas de cada processo envolvido para o mesmo quadro da memória física
(f) V
