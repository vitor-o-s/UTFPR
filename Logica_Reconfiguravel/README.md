# Lógica Reconfigurável

Este repositório contém um breve resumo, anotações e demais arquivos utilizados durante a disciplina de Lógica Reconfigurável (realizado em 2022/1).

## Introdução

Def. Dispositivo Lógico Programáveis (PLD em inglês): Dispositivo que recebe a programação de um circuito digital determinado pelo projetista.

* Reduz o número de chips TTL, passando para 1 as funções necessárias;
* Reduziam custos dos cicuitos integrados de aplicação específicas (ASICs)
* Redução do espaço necessário para a solução.

### Classificação dos PLDs

#### SPLDs (Simple PLDs)

PALs (Programmable Array Logic) e PLAs (Programmable Logic Arrays) - Praticamente a mesma função, geralmente só implementavam circuitos combinacionais. Técnoogia iguais da memória ROMs (fusível/antifusível). Uma PAL é uma implementação de soma de produtos ((A+B)*(A+B)...), vale lembrar quequalquer função lógica pode ser escrita por soma de produtos ou Produto das Somas

Já a GAL (Generic Array Logic) pode ser descrita como um avanço nesta área pois possuia:

* Sinal de retorno;
* Era reprogramável; e
* Organizadas em um arranjo com portas AND e macrocélulas.

Um macrocṕelula possui:

* 1 Flip-Flop;
* 1 porta XOR; e
* 5 multiplexadores.

As PALCEs (PAL CMOS ellectrically erasable/programmable device) funcionava como as GALS contudo possuiam este nome diferente.

#### CPLDs

#### FPGAs
