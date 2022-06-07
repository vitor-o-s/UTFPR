#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

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

int main(void){
    
    mkfifo("retirar", 0666);
    mkfifo("servir", 0666);
    fd[0] = open("retirar", O_RDONLY);
    fd[1] = open("servir", O_WRONLY);
    jav.numJavalis = JAVALIS;
    printf("Cozinheiro encheu o caldeirão com %d javalis e foi nanar\n", jav.numJavalis);
    
    write(fd[1], &jav, sizeof(pipe1_t)); //Avisa que encheu
    while(1){
        read(fd[0], &pedido, sizeof(pipe2_t)); //Lê o controle
        if(pedido.controle == 'E'){
            //printf("Entrei");
            jav.numJavalis = JAVALIS; 
            printf("Cozinheiro encheu o caldeirão com %d javalis e foi nanar.\n", jav.numJavalis);
            write(fd[1], &jav, sizeof(pipe1_t)); //Avisa que encheu
            read(fd[0], &pedido, sizeof(pipe2_t));
        }
        if(pedido.controle == 'B'){
            jav.numJavalis--;
        }
        write(fd[1], &jav, sizeof(pipe1_t));
    }
    
}
