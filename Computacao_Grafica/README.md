# Computação Gráfica

Este repositório contém um breve resumo, anotações e demais arquivos utilizados durante a disciplina de Computação Gráfica (realizado em 2022/1), ministrada pelo Prof. Dr. [Érick Oliveira Rodrigues](https://sites.google.com/view/ppgee-pb/pesquisadores/%C3%A9rick-oliveira-rodrigues).

## Introdução

Começamos a disciplina entendendo um pouco sobre a arquitetura do computador, em especial o funcionamento da GPU. Podemos dizer que inicialmente uma das principais diferenças entre a GPU e a CPU é a quantidade de núcleos, onde a CPU normalmente possui 16/32... a GPU vem a ter +1000 normalmente.

Diferenças de uso entre CPU (Central Processor Unit) e GPU (Graphic Unit Processor)

| CPU | GPU
:----:| :----:
| Cálculos mais simples | Especializada em calculos de matrículas
| Não paralelo | Se for possível paralelizar
| Alta depêndencia de dados | Baixa depêndecia dos dados

Os paradigmas de execução para cada plataforma é diferente.

* CPU - Multiple Instruction Multiple Data (MIMD);
* GPU - Single Instruction Multiple Data (SIMD).

| MIMD | SIMD
:----:|:----:
| Específico para diversas aplicações (diferentes entre si) | Não funciona bem com todas as aplicações
| Precisa de mais memória | Apenas uma unidade de controle
| Precisa de mais de uma unidade de controle | Menos memória (apenas uma cópia do programa)

## Tarefas

### T1

Fazer um resumo de um artigo que utiliza CUDA explicando o objetivo e os resultados.

Artigo escolhido: [A Performance Comparison of CUDA and OpenCL](https://arxiv.org/abs/1005.2581)

Atividade: [T1.txt](https://github.com/vitor-o-s/UTFPR/tree/main/Computacao_Grafica)
