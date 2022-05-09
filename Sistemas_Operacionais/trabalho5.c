/*Considere o seguinte o grafo de precedência:

                  |-> procB x=x*2 -> procC x=x+1   | -> procD h=y+x   ->|
procA x=1 y=1 z=2 |----------------> procE y=y+2 ->|                    |->procF u=h+j/3    
                  |----------------> procG z=z/2   | -> procH j=z+y-4 ->|

Que será executado por três processos, conforme código abaixo:
P1: begin A; E; F; end;
P2: begin B; C; D; end;
P3: begin G; H; end;
Adicione semáforos a este programa, e as respectivas chamadas às suas operações, 
de modo que a precedência definida acima seja alcançada.
Obdeça as equações obtendo valor final de u dado as entradas de x, y e z
*/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdint.h>
#include <semaphore.h>
#include<unistd.h>

#define ever ;;
#define NUM_THREADS 3

sem_t procA, procB, procC;//, procD, procD1, procE, procF, procF1, procG, procH, procH1;
int x = 0, y = 0, z = 0, h = 0, j = 0, u = 0;

void* process_1(void* v){
    sem_wait(&procA); //Liberado pelo processo principal para executar A
    x = 1;
    y = 1;
    z = 2;
    sem_post(&procB);//Libera processo 2 para executar B
    sem_post(&procA);//sem_post(&procE);//Libera processo 1 para executar E
    sem_post(&procC);//sem_post(&procG);//Libera processo 3 para executar G

    sem_wait(&procA);//sem_wait(&procE);//Liberado pelo processo 1 para executar E
    y = y+2;
    sem_post(&procB);//sem_post(&procD);//Libera processo 2 para executar D
    sem_post(&procC);//sem_post(&procH);//Libera processo 3 para executar H

    sem_wait(&procA);//sem_wait(&procF);//Liberado pelo processo 2 para executar F
    sem_wait(&procA);//sem_wait(&procF1);//Liberado pelo processo 3 para executar F
    u = h+j/3;
    printf("O valor de u e: %d\n",u);
}

void* process_2(void* v){
    sem_wait(&procB);//Liberado pelo processo 1 para executar B
    x = x*2;
    sem_post(&procB);//sem_post(&procC);//Libera processo 2 para executar C

    sem_wait(&procB);//sem_wait(&procC);//Liberado pelo processo 2 para executar C
    x = x+1;
    sem_post(&procB);//sem_post(&procD1);//Libera processo 2 para executar D

    sem_wait(&procB);//sem_wait(&procD);//Liberado pelo processo 1 para executar D
    sem_wait(&procB);//sem_wait(&procD1);//Liberado pelo processo 2 para executar D
    h = y+x;
    sem_post(&procA);//sem_post(&procF);//Libera processo 1 para executar F
}

void* process_3(void* v){
    sem_wait(&procC);//sem_wait(&procG);//Liberado pelo processo 1 para executar G
    z=z/2;
    sem_post(&procC);//sem_post(&procH1);//Libera processo 3 para executar H

    sem_wait(&procC);//sem_wait(&procH);//Liberado pelo processo 1 para executar H
    sem_wait(&procC);//sem_wait(&procH1);//Liberado pelo processo 3 para executar H
    j = z+y-4;
    sem_post(&procA);//sem_post(&procF1);
}

int main(void){
    
    pthread_t thread[NUM_THREADS];

    sem_init(&procA, 0,1);
    sem_init(&procB, 0,0);
    sem_init(&procC, 0,0);
    /*sem_init(&procD, 0,0);
    sem_init(&procD1,0,0);
    sem_init(&procE, 0,0);
    sem_init(&procF, 0,0);
    sem_init(&procF1,0,0);
    sem_init(&procG, 0,0);
    sem_init(&procH, 0,0);
    sem_init(&procH1,0,0);*/

    pthread_create(&thread[0], NULL, &process_1, NULL);
    pthread_create(&thread[1], NULL, &process_2, NULL);
    pthread_create(&thread[2], NULL, &process_3, NULL);

    for(int i = 0; i < NUM_THREADS; i++)
        pthread_join(thread[i],NULL);

    return 0;
}