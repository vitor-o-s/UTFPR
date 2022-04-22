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

## Capítulo 5 - Implementação de tarefas

## Capítulo 6 - Escalonamento de tarefas

## CApítulo 7 - Tópicos em gestão de tarefas
