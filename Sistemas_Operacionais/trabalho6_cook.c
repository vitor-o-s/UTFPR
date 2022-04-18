#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mqueue.h>

#define true 1
#define COZINHEIRO 1
#define QTD_JAVALI 20

void delay(int n);
void ColocaJavalis();
void Cozinheiro();

typedef struct messbuf
{
  int num_javali;
} Javali;// messbuf_t;

mqd_t fd;
Javali data; //messbuf_t data;
Javali *ptr = &data; //messbuf_t *ptr = &data;

int main(void)
{
  struct mq_attr attr;

  attr.mq_maxmsg = 10;
  attr.mq_msgsize = sizeof(Javali);//sizeof(messbuf_t);
  attr.mq_flags = 0;

  mq_unlink("/myqueue");
  fd = mq_open("/myqueue", O_RDWR | O_CREAT, 0666, &attr);

  ptr->num_javali = 0;
  Cozinheiro();

  sleep(5);
  return 0;
}

void delay(int n)
{
  sleep(random() % n);
}

void ColocaJavalis()
{
  mq_send(fd, (void *)ptr, sizeof(Javali), 0);//(fd, (void *)ptr, sizeof(messbuf_t), 0);
  ptr->num_javali++;
  printf("Cozinheiro preparou o javali[%d]\n", (int)ptr->num_javali);

  delay(2);
}

void Cozinheiro()
{
  while (1)
  {
    ColocaJavalis();
  }
}