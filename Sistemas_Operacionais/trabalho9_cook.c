#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#include <mqueue.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#define JAVALIS 20
#define GAULESES 5

typedef struct _msgbuff_t{
    int controle;
}msgbuff_t;

msgbuff_t a, r;
msgbuff_t *acorda = &a, *retira = &r;
mqd_t fd1, fd2;

int main(){
    struct mq_attr attr;

    attr.mq_maxmsg = 1;
	attr.mq_msgsize = sizeof(msgbuff_t);
	attr.mq_flags = 0;
    
    mq_unlink("/retira");
    mq_unlink("/acorda");
	fd2 = mq_open("/retira", O_RDWR|O_CREAT, 0666, &attr);
    fd1 = mq_open("/acorda", O_RDWR|O_CREAT, 0666, &attr);

    //Inicialização dos javalis
    printf("Cozinheiro reabasteceu os javalis e dormiu\n");
    retira->controle = JAVALIS;
    mq_send(fd2, (void*)retira, sizeof(msgbuff_t), 0);

    while(1){
        mq_receive(fd1, (void*)acorda, sizeof(msgbuff_t), 0);
        if(acorda->controle == 1){ //
            printf("Cozinheiro reabasteceu os javalis e dormiu\n");
            mq_send(fd2, (void*)retira, sizeof(msgbuff_t), 0);
            acorda->controle = 0;
        }
    }
}
// gcc trabalho9_cook.c -o cook9 -lpthread -lrt 
// ./cook9