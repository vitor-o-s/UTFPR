/*Uma tribo gaulesa janta em comunidade a partir de uma mesa enorme com espaço para
javalis grelhados. Quando um gaulês quer comer, serve-se e retira um javali da mesa
a menos que esta já esteja vazia. Nesse caso o gaulês acorda o cozinheiro e aguarda que
este reponha javalis na mesa. O código seguinte representa o código que implementa o gaulês e o cozinheiro.
Implemente o código das funções RetiraJavali() e ColocaJavalis() incluindo
código de sincronização que previna deadlock e acorde o cozinheiro apenas quando a
mesa está vazia.
Lembre que existem muitos gauleses e apenas um cozinheiro.
Idenfique regiões crícas na vida do gaules e do cozinheiro.
A solução deve aceitar um numero N de gauleses igual ao número de letras de seu
primeiro nome e 1 único cozinheiro.
Cada gaules terá um nome, dado pela letra correspondente
– Ex: dalcimar = 8 gauleses
Cada gaules deve imprimir na tela seu nome (dado pela letra) quando come e
quando acorda o cozinheiro.
– Ex: Gaules d(0) comendo
– Ex: Gaules a(1) acordou cozinheiro
A quantidade javalis grelhados M deve ser igual ao número dos dois primeiros dígitos de seu RA
A solução não deve ter nenhum comentário
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define JAVALIS 20
#define GAULESES 5

int numJavalis = JAVALIS;
char NOME[] = {'V', 'I', 'T', 'O', 'R'};
sem_t sem_Coz, sem_Retira, sem_Gau, sem_Lib, sem_mesa;

void RetiraJavali(long gaules){
    sem_wait(&sem_Gau);
    if(!numJavalis){
        sem_post(&sem_Coz);
        printf("Gaulês %c(%ld) acordou o cozinheiro\n", NOME[gaules], gaules);
        sem_wait(&sem_Retira);
    }
    if(numJavalis){
        numJavalis--;
    }
    sem_post(&sem_Lib);
}

void *Gaules(void *threadid){
    long gaules = (long)threadid;
    while(1){
    	sem_wait(&sem_mesa);
        sem_post(&sem_Gau);
        RetiraJavali(gaules);
        sem_wait(&sem_Lib);
        printf("Gaulês %c(%ld) comendo. Restam %d Javalis\n", NOME[gaules], gaules, numJavalis);
        sem_post(&sem_mesa);
        //sleep(rand() % 4 + 1);
    }
    pthread_exit(NULL);
}

void *Cozinheiro(){
    while(1){
        sem_wait(&sem_Coz);
        printf("Cozinheiro reabasteceu os javalis e dormiu\n");
        numJavalis = JAVALIS;
        sem_post(&sem_Retira);
    }
    pthread_exit(NULL);
}

int main(void){
    srand(time(NULL));
    sem_init(&sem_Coz, 0, 0);
    sem_init(&sem_Retira, 0, 0);
    sem_init(&sem_Gau, 0, 0);
    sem_init(&sem_Lib, 0, 0);
    sem_init(&sem_mesa, 0, 1);
    
    pthread_t thread[6];
    long i;
    
    for(i = 0; i < GAULESES; i++)
        pthread_create(&thread[i], NULL, Gaules, (void*)i);
    
    pthread_create(&thread[GAULESES], NULL, Cozinheiro, NULL);
    
    for(i = 0; i <= GAULESES; i++)
        pthread_join(thread[i], NULL);

    //pthread_exit(NULL);

    return 0;
}