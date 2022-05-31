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

#define GAULESES 5
#define JAVALIS 20
#define ever ;;

char NOME[] = {'V', 'I', 'T', 'O', 'R'};

pthread_mutex_t mutex;
sem_t full, empty;
pthread_t tid;

typedef struct{
    int num_javali;
}Javali;

int mesa[JAVALIS];
int counter;


void ComeJavali(char nome_thread, int tid){
    printf("Gaules %c(%d) comendo\n", nome_thread,tid);
}

int RetiraJavali(int *j){
    if(counter > 0){ // When the buffer is not empty remove the item and decrement the counter
		*j = mesa[(counter-1)];
        //printf("Retirando %d",mesa[(counter-1)]);
		counter--;
		return 0;
	}
	else { // Error buffer empty
		return 1;
	}
}
    

int ColocaJavalis(int M){
    if(counter < JAVALIS){ // When the buffer is not full add the item and increment the counter*/
		mesa[counter] = M;
        //printf("%d",mesa[counter]);
		counter++;
        
		return 0;
	}
	else{ // Error the buffer is full
		return 1;
	}
}

void* Gaules(void *id){
    int item;
    long tidd = (long)id;
    while(1){
        sem_wait(&full);
        pthread_mutex_lock(&mutex);

        
        char nome_thread = NOME[tidd];

        if(!RetiraJavali(&item)) {
            //printf("Chegamo aqui\n");
			ComeJavali(nome_thread, tidd);
		}
		else {
			printf("Gaules %c(%ld) acordou o cozinheiro\n", nome_thread, tid);
		}

        //int j = RetiraJavali();
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
        
    }
}

void* Cozinheiro(){
    while(1){
        int M = rand() % 100;
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        if(!ColocaJavalis(M)) {
			printf("Cozinheiro colocou javali na mesa \n");
		}
		/*else {
			fprintf(stderr, " Producer report error condition\n");
		}*/

        pthread_mutex_unlock(&mutex);
        sem_post(&full);
    }
}

void initializeData() {
	counter = 0; //init buffer

	pthread_mutex_init(&mutex, NULL); //create the mutex lock */
	sem_init(&full, 0, 0); 	//create the full semaphore and initialize to 0 */
	sem_init(&empty, 0, JAVALIS); //create the empty semaphore and initialize to BUFFER_SIZE */
}

int main(void){

    int i;
    pthread_t gauleses[GAULESES];
    pthread_t cozinheiro;

	initializeData();

	// Create the producer threads
	pthread_create(&cozinheiro, NULL, Cozinheiro, NULL);

    for(i = 1; i < GAULESES; i++)
        pthread_create(&gauleses[i], NULL, Gaules, (void *)(intptr_t)i);

    sleep(10);

    return 0;
}