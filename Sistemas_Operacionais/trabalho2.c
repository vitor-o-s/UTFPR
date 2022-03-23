/*
Escreva um trecho de código que uti liza a função fork() e gera uma árvore de busca
binária (ou quase isso) com seu primeiro nome. Para tal siga as seguintes regras:

1. Primeira letra será a raiz da árvore
2. Cada letra seguinte será inserida a direita, se a letra for maior que a raiz, ou a
esquerda, se a letra for menor que a raiz.
3. Esse procedimento (verificar a raiz e inserir a direita ou a esquerda) deve ser realizado recursivamente.
Ex: VITOR


Atenção, um processo deve mostrar uma mensagem se idenficando (“proc-V”... “proc-I”)
quando ele acaba de ser criado e quando ele está prestes a morrer
cada processo gerado deve imprimir o seu PID e o PPID você deve garantir que um pai sempre morre depois de seu filho!
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main(void){

    pid_t pid;
    int status = 0;

    printf("proc-V, pid%d, ppid%d, acaba de ser criado\n", getpid(), getppid());

    pid = fork();
    
    if(pid == 0){


    }
    else{
        waitpid(pid, &status, 0);
        printf("proc-V, pid %d, morreu\n",getpid());
        exit(0);
    }
}