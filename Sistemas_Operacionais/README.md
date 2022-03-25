# Sistemas Operacionais

Este repositório contém um breve resumo, anotações e demais arquivos utilizados durante a disciplina de Sistemas Operacionais (realizado em 2022/1). O README.md do projeto apresenta um resumo do livro ["Sistemas Operacionais: Conceitos e Mecanismos"](http://wiki.inf.ufpr.br/maziero/doku.php?id=socm:start) do Prof Carlos A. Maziero, além de notas de aulas do professor [Dalcimar](dalcimar.com) e professor [Bruno Ribas](https://www.brunoribas.com.br/index.html).

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

## Capítulo 3 - Arquiteturas de SOs

## Capítulo 4 - O conceito de tarefa

## Capítulo 5 - Implementação de tarefas

## Capítulo 6 - Escalonamento de tarefas

## CApítulo 7 - Tópicos em gestão de tarefas
