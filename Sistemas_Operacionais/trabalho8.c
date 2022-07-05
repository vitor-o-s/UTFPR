#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/stat.h>

#define JAVALIS 20
#define GAULESES 5

typedef struct _pipe1_t{
    int numJavalis;
}pipe1_t;

typedef struct _pipe2_t{
    char controle;
}pipe2_t;

pipe1_t jav;
pipe2_t pedido;
int fd[2];
sem_t sem_Retira, sem_Gau, sem_Mesa;
char NOME[] = {'V', 'I', 'T', 'O', 'R'};

void RetiraJavali(long gaules){
    sem_wait(&sem_Retira);
    read(fd[1], &jav, sizeof(pipe1_t)); //Lê que encheu
    if(jav.numJavalis == 0){
        printf("Gaulês %c(%ld) acordou o cozinheiro\n", NOME[gaules], gaules);
        pedido.controle = 'E';
        write(fd[0], &pedido, sizeof(pipe2_t)); //Solicita encher
        read(fd[1], &jav, sizeof(pipe1_t)); //Lê que encheu
    }
    if(jav.numJavalis > 0){
        pedido.controle = 'B';
        write(fd[0], &pedido, sizeof(pipe2_t)); //Solicita retirar
    }
    sem_post(&sem_Gau);
}

void *Gaules(void *threadid){
    long gaules = (long)threadid;
    while(1){
        sem_wait(&sem_Mesa);
        sem_post(&sem_Retira);
        RetiraJavali(gaules);
        sem_wait(&sem_Gau);
        printf("Gaulês %c(%ld) comendo. Restam %d Javalis\n", NOME[gaules], gaules, jav.numJavalis - 1);
        sem_post(&sem_Mesa);
        sleep(rand() % 3 + 1);
    }
    pthread_exit(NULL);
}

int main(void){
    
    int i;

    srand(time(NULL));
    mkfifo("retirar", 0666);
    mkfifo("servir", 0666);
    
    sem_init(&sem_Retira, 0, 0);
    sem_init(&sem_Gau, 0, 0);
    sem_init(&sem_Mesa, 0, 1);
    fd[0] = open("retirar", O_WRONLY);
    fd[1] = open("servir", O_RDONLY);

    pthread_t gauleses[GAULESES];
    //read(fd[1], &jav, sizeof(pipe1_t)); //Lê que encheu
    for(i = 0; i < GAULESES; i++)
        pthread_create(&gauleses[i], NULL, Gaules, (void*)(intptr_t)i);

    for(i = 0; i < GAULESES; i++)
        pthread_join(gauleses[i], NULL);

    pthread_exit(NULL);
}