/*Suponha o grafo de precedência abaixo com 5 processos.

A-|      |->D
  |-> C -|
B-|      | -> E

Adicione semáforos a esses processos de modo que a precedência definida acima seja
alcançada
Ao iniciar sua execução o processo imprime na tela uma mensagem (e.g. ‘Iniciando A’) e
espera um tempo aleatório entre 1 e 5 segundos para finalizar.
Ao finalizar o processo imprime uma mensagem (e.g. ‘Finalizando processo ‘A’)
*/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdint.h>
#include <semaphore.h>
//#include <time.h>
#include<unistd.h>

#define ever ;;

sem_t a, b, c, d, e;

void* process_a(void* v){
    sem_wait(&a);
    printf("Iniciando processo A\n");      
    sleep((rand()%4) + 1);        
    printf("Finalizando processo A\n");
    sem_post(&b);
}

void* process_b(void* v){
    sem_wait(&b);
    printf("Iniciando processo B\n");
    sleep((rand()%4)+1);
    printf("Finalizando processo 'B'\n");
    sem_post(&c);  
}

void* process_c(void* v){
    sem_wait(&c);
    printf("Iniciando processo C\n");
    sleep((rand()%4)+1);
    printf("Finalizando processo 'C'\n");
    sem_post(&d);
}


void* process_d(void* v){
    sem_wait(&d);
    printf("Iniciando processo D\n");
    sleep((rand()%4)+1);
    printf("Finalizando processo 'D'\n");
    sem_post(&e);
}

void* process_e(void* v){
    sem_wait(&e);
    printf("Iniciando processo E\n");
    sleep((rand()%4)+1);
    printf("Finalizando processo 'E'\n");
}

int main(void){
    
    pthread_t thread[5];

    sem_init(&a,0,1);
    sem_init(&b,0,0);
    sem_init(&c,0,0);
    sem_init(&d,0,0);
    sem_init(&e,0,0);

    pthread_create(&thread[0], NULL, &process_a, NULL);
    pthread_create(&thread[1], NULL, &process_b, NULL);
    pthread_create(&thread[2], NULL, &process_c, NULL);
    pthread_create(&thread[3], NULL, &process_d, NULL);
    pthread_create(&thread[4], NULL, &process_e, NULL);

    for(int i = 0; i<5; i++)
        pthread_join(thread[i],NULL);

    //pthread_kill(thread,'SIGKILL');
    return 0;
}