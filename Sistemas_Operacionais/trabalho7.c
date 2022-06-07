#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/mman.h>

#define JAVALIS 20
#define GAULESES 5
#define SHM_ID "/shm_open"

typedef struct _shm_t{
    int numJavalis;
    sem_t sem_Coz, sem_Retira, sem_Lib, sem_Gau, sem_mesa;
}shm_t;

char NOME[] = {'V', 'I', 'T', 'O', 'R'};

shm_t *controle;

void RetiraJavali(long gaules){
    sem_wait(&controle->sem_Gau);
    if(!controle->numJavalis){
        sem_post(&controle->sem_Coz);
        printf("Gaulês %c(%ld) acordou o cozinheiro\n", NOME[gaules], gaules);
        sem_wait(&controle->sem_Retira);
    }
    if(controle->numJavalis){
        controle->numJavalis--;
    }
    sem_post(&controle->sem_Lib);
}

void *Gaules(void *threadid){
    long gaules = (long)threadid;
    while(1){
	sem_wait(&controle->sem_mesa);
        sem_post(&controle->sem_Gau);
        RetiraJavali(gaules);
        sem_wait(&controle->sem_Lib);
        printf("Gaulês %c(%ld) comendo. Restam %d Javalis\n", NOME[gaules], gaules, controle->numJavalis);
        sem_post(&controle->sem_mesa);
        sleep(rand() % 4 + 1);
    }
    pthread_exit(NULL);
}

int main(void){
    
    pthread_t gauleses[GAULESES];
    
    int i;

    int fd = shm_open(SHM_ID, O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
    ftruncate(fd, sizeof(shm_t));
    controle = mmap(NULL, sizeof(shm_t), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

    for(i = 0; i < GAULESES; i++)
        pthread_create(&gauleses[i], NULL, Gaules, (void*)(intptr_t)i);
      
    for(i = 0; i < GAULESES; i++)
        pthread_join(gauleses[i], NULL);
    
    pthread_exit(NULL);
}
