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
#include <sys/stat.h>
#include <mqueue.h>

#define GAULESES 5
#define ever ;;

sem_t buffer_cald;

typedef struct messbuf
{
  int num_javali;
} Javali;// messbuf_t;


Javali data;
Javali *ptr = &data;
mqd_t fd;

char nome[] = "VITOR";
int gaules[GAULESES];

void delay(int n){
  sleep(random() % n);
}

void* RetiraJavali(int tid){

    sem_wait(&buffer_cald);
    mq_receive(fd, (void *)ptr, sizeof(Javali), 0);//(fd, (void *)ptr, sizeof(messbuf_t), 0);
    return (void*)(intptr_t)fd;
}

void* ComeJavali(Javali j, int tid){

    if (ptr->num_javali == 0)
    {
        printf("Gaules %c(%d) acordou o cozinheiro\n", nome[tid], tid);
    }
    ptr->num_javali--;
    sem_post(&buffer_cald);

    printf("Gaules %c(%d): Comeu o Javali [%d]\n", nome[tid], tid, (int)ptr->num_javali);

    delay(2);
}

void* Gaules(void* id){
    int tid = (long)id;
    for(ever){
        Javali j = RetiraJavali(tid);
        //j = (Javali)(long)temp;
        ComeJavali(j, tid);
    }
}

int main(void){
    
    fd = mq_open("/myqueue", O_RDWR);

    pthread_t gaules[GAULESES];

    sem_init(&buffer_cald, 0, 1);

    for (long i = 0; i < GAULESES; i++)
    {
        pthread_create(&gaules[i], NULL, Gaules, (void *)i);
    }

    pthread_exit(NULL);

    sleep(5);
    return 0;
}