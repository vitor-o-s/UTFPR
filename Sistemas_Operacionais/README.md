# Sistemas Operacionais

Este repositório contém um resumo, anotações e demais arquivos utilizados durante a disciplina de Sistemas Operacionais (realizado em 2022/1). O README.md do projeto apresenta um resumo do livro ["Sistemas Operacionais: Conceitos e Mecanismos"](http://wiki.inf.ufpr.br/maziero/doku.php?id=socm:start) do Prof Carlos A. Maziero, além de notas de aulas do professor [Dalcimar](dalcimar.com) e professor [Bruno Ribas](https://www.brunoribas.com.br/index.html).

## Capítulo 1 - Conceitos básicos

O S.O. possui 2 objetivos básicos:

* Abstração de Recursos - Abstrair - Torna app independentes do hardware/Simplifica manipulação do hardware/Facilita o uso por hardwares distintos;
* Gerenciar Recursos - Definir políticas para gerenciar o uso dos recursos do hardware.

Podemos definir as principais funcionalidades implementadas de um S.O. por:

* Gerência do processador - Distribuir a capacidade de processamento;
* Gerência de memória - Fornecer e isolar uma área de memória para cada aplicação;
* Gerência de dispositivos - Implementar interação p/ cada dispositvo via *drivers*/Criar modelo abstratos para agrupar dispositivos em uma mesma interface de acesso;
* Gerência de arquivos - Criar *arquivos* e *diretórios*, definindo a interface de acesso e as regras de uso;
* Gerência de proteção - Definição de users e group users/Identificação de user/Controle de acesso aos recursos/Registro de uso.

É importante a distinção entre *política*(decisões abstratas) e *mecanismo*(procedimentos baixo nível).

### Tipos de Sistemas Operacionas

* Batch (de lote) - Execução de programa por fila;
* De rede - Oferecer recursos de outros computadores da rede (atualmente quase todos suportam esse funcionalidade);
* Distribuído - Os recursos de cada computador estão disponíveis a todos na rede de forma transparente aos users;
* Multiusuário - Suporte a identificação e regras de acesso (maioria dos S.O.s são multiusuários);
* Servidor - Gestão eficiente de grandes quantidade de recursos;
* Desktop - Atendimento do usuário;
* Móvel - Conectividade e gestão de energia são prioridade;
* Embarcado - Operar sobre um hardware com poucos recursos de processamento, armazenamento e energia;
* Tempo real - Tempo é essencial, tempo de resposta deve ser prevísivel.

### Histórico

Resolvi omitir esta parte do resumo para mais informações buscar a seção 1.4 do livro citado no inicio.

## Capítulo 2 - Estrutura de um SO

Um S.O. é composto por diversos componentes com objetivos e funcionalidades complementares, tais como:

* Núcleo (kernel): Parte fundamental do sistema operacional, gerencia os recursos e implementa as abstrações;
* Boot Code: Responsável por reconehcer os dispositivos instalados, testa-los e configura-los para o uso, assim como carregar o kernel em memória e iniciar a execução;
* Drivers: Códigos específicos para acessar os dispositivos físicos;
* Programas utilitários: Programas que facilitam o uso do sistema, por exemplo o terminal, interface gráfica, entre outros.

O kernel usualmente executa em um modo especial de operação do processar, o chamado *modo privilegiado (ou modo sistema)* e os demais programas executam no *modo usuário*

### Interrupções

Outro conceito importate que devemos nos atentar são as interrupções, elas podem ser divididas em 3 categorias:

* Interrupção: Gerada por algum evento externo;
* Exceção: Gerado por evento interno (divisão por 0, acesso indevido de memória...);
* Traps: Interrupção gerada via código.

É importante que a rotina de tratamento dessas interrupções seja rápida uma vez que elas tiram o computador do seu fluxo principal. Cada interrupção é identificada pelo hardware por um número inteiro definido pelo fabricante do processador.

### Níveis de privilégios

Núcleo e drivers devem ter acesso pleno ao hardware, contudo os outros aplicativos e utilitários devem ter um acesso restrito, assim mantemos o sistema mais estável e seguro. Para fazer isso os processadores implemntam o chamado nível de privilégio de execução, um sistema de flags especiaias na CPU. 2 níveis costumam ser implementados.

* Nível núcleo: Todas as funcionalidades do processador estão disponíveis (tanto instruções como acesso a memória);
* Nível usuário: Caso uma instrução perigosa seja enviada por esse modo uma interrupção será gerada.

Mas com este encapsulamento é necessário criar um método para invocar as rotinas oferecidas pelo núcleo. Para isso surgem as system call (chamada de sistema), assim o usuário escreve seu código e ao executar leva seus comandos para um rotina de interrupção de software (trap).

## Capítulo 3 - Arquiteturas de SOs

Para este capítulo, recomendo a leitura do livro, uma vez que o mesmo tem ótimas imagens,contudo falando brevemente sobre arquiteturas temos:

* Sistemas Monolíticos:
* Sistemas Micronúcleo:
* Sistemas em Camadas:
* Sistemas Híbridos:

Além disso podemos falar de algumas arquiteturas mais avançadas como:

* Máquinas Virtuais:
* Contêineres:
* Sistemas exonúcleo:
* Sistemas uninúcleo:

## Capítulo 4 - O conceito de tarefa

O conceito de tarefa surge diante da necessidade de atender a grande quantidade de tarefas que o sistema operacional deve realizar da melhor forma possível,já que existem mais tarefas do que processadores. Definimos tarefa como "um fluxo sequencial de isntruções, construído para atender uma finalidade específica". Há uma diferença a ser notada, um programa é estático, apresenta o código/instruções, já a tarefa é dinâmica e possui um estado interno com a execução das instruções.

### Gerência de tarefas

> Em um computador, o processador tem de executar todas as tarefas submetidas pelos usuários. Essas tarefas geralmente têm comportamento, duração e importância distintas. Cabe ao sistema operacional organizar as tarefas para executá-las e decidir em que ordem fazê-lo. Nesta seção será estudada a organização básica do sistema de gerência de tarefas e sua evolução histórica.

* Sistema Monotarefa: Executam 1 tarefa por vez, eram usados no inicio da computação. A máquina de estado deste modelo é simple "Novo -> Executando -> Terminado".
* Monitor de Sistema: O programa monitor era carregado na memória no início da oepração do sistema, era responsável por gerenciar a fila de tarefas, entradas e saídas.
* Sistemas Multitarefas: Nesse sistema várias tarefas podiam estar em andamento simultaneamente, uma vez que o tempo de recuperação de entradas (que estavam na memória) era alto o monitor colocava uma tarafa em suspensão até que sua entrada fosse carregada e executava outro fluxo neste período. A complexidade aumentou uma vez que era necessário manter o estado de uma tarefa salva também. A máquina de estado aqui fica mais interessante "Novo -> Pronto -> Executando/<- Suspenso -> Terminado" onde suspenso voltaria a fila de prontos para executar.
* Sistemas de Tempo Compartilhado: Para resolver o problema de tarefas "sem fim" foi adicionado o conceito de fatia de tempo ou também chamado "quantum", ou seja uma tarefa será executada por um quantum prédefinido depois voltara a fila de "Pronto" ou "Terminado" e uma tarefa diferente poderá ser executada. O ato de tirar o recurso de uma tarefa é o que chamamos de "preempeção". A máquina de estado aqui fica desta forma "Novo -> Pronto -> <- Executando/<- Suspenso -> Terminado" onde suspenso e executando podem voltar a fila de prontos para executar.

## Capítulo 5 - Implementação de tarefas

A primeira coisa que precisamos pensar sobre uma tarefa é seu contexto, ou o estado dela em um determinado instante. O contexto contém informações sobre recursos usado por ela, arquivos abertos, conexões de rede, semáforos, contador de programa (PC) e apontador de pilha (SP). Cada tarefa possui um descritor (estrutura de dados) para armazenar o contexto e outros dados necessários. Essa estrutura chamamos  *TCB (Task Controle Block) ou PCB (Process Control Block)*.
Para mover um tarefa para o estado de suspensa é necessário ter cuidado ao manipular seu TCB. um conjunto de rotinas denominado *despachante (dispatcher)* é quem cuida dessas operações. Já o *escalonador (scheduler)* é quem fica responsável por escolher a próxima tarefa a ser executada. A troca de contexto pode ser pelo fim do quantum, uma interrupção ou mesmo erro. É importante estar atento pois quanto menos trocas fizermos mais performatico será nosso sistema operacional.

### Processos

Atulmente podemos dizer que um processo é uma unidade de contexto (não mais uma unidade de tarefa como nos sistemas operacionais mais antigos), assim um processo pode conter váias tarefas compartilhando os mesmos recursos, mas mantendo a segurança entre outros processos. As PCBs armazenam, informações como inicio, caminho para o código, PID e mais, ja  as TCBs são mais simples armazenando apenas o identificador, registrados e uma referencia ao processo pai. Importante notar que, trocar de tarefa dentro de um mesmo processo é mais ráido do que trocar entre tarefas de processos diferentes.
Para realizarmos operações com processos é necessário utilizar chamadas de sistemas (variam de acordo com o sistema operacional), podemos citar aqui por exemplo:

* fork(): cria uma cópia exata de si. Essa cópia chamada de filho (child) recebe o mesmo estado interno do pai, acessa o mesmo recurso do kernel porém executa em área distinta da memória. Essa chamada retorna duas vezes 1 para o pai e outra para o filho.
* execve(): o uso do execve normalmente é ligado ao fork. Após a cópia estar feita o filho chama o execve para substituir seu código binário.
* exit(): Usamos esta hamada pra indicar que o processo já não é mais necessário.
* kill(): Envia um sinal ao núcleo sobre uma tarefa.
* getpid(): Retorna o ProcessIDentifier

No Linux é possível visualizar claramente a hierarquia de processo (uma árvore). Já o windows não diferencia pais e filhos mantendo todos no mesmo nível.

### Threads

>Uma thread é definida como sendo um fluxo de execução independente. Um processo pode conter uma ou mais threads, cada uma executando seu próprio código e compartilhando recursos com as demais threads localizadas no mesmo processo. Cada thread é caracterizada por um código em execução e um pequeno contexto local, o chamado Thread Local Storage (TLS), composto pelos registradores do processador e uma área de pilha em memória, para que a thread possa armazenar variáveis locais e efetuar chamadas de funções.

| Modelo | N:1 | 1:1 | N:M
|:---:|:---:|:---:|:---:
| Resumo | N threads do processo mapeados em uma thread de núcleo | Cada thread do processo mapeado em uma thread de núcleo| N threads do processo mapeados em M< N threads de núcleo
| Implementação | no pocesso (biblioteca| no núcleo | em ambos |
| Complexidade | baixa | média | alta
| Custo de gerência | baixo | médio | alto
| Escalabilidade | alta | baixa | alta
| Paralelismo entre threads do mesmo processo | não | sim | sim
| Troca de contexto entre threads do mesmo processo | rápida | lenta | rápida
| Divisão de recursos entre tarefas | injusta | justa | variável, pois o mapeamento thread->processador é dinâmico.

## Capítulo 6 - Escalonamento de tarefas

## Capítulo 7 - Tópicos em gestão de tarefas

## Capítulo 8 - Comunicação entre tarefas

## Capítulo 9 - Mecanismos de comunicação

## Capítulo 10 - Coordenação entre tarefas

## Capítulo 11 - Mecanismos de Coordenação

## Capítulo 12 - Problemas clássicos
