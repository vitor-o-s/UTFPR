#include <stdio.h>
#include <stdlib.h>

#define NUM 3000
#define MX_TYPE long double // tipo dos elementos da matriz
#define ID_TYPE long int // tipo dos índices da matriz

int main()
{
  
  // criando e inicializando as matrizes 1, 2 e 3 (a matriz 3 inicializada com zeros):
  printf("\n*versão serial*\n\n");
  printf("criando as matrizes 1, 2 e 3...");

  MX_TYPE   *m1_1d,
            *m2_1d,
            *m3_1d;

  ID_TYPE i, j, k;

  m1_1d= malloc(NUM * NUM * sizeof(MX_TYPE));
  m2_1d= malloc(NUM * NUM * sizeof(MX_TYPE));
  m3_1d= calloc(NUM * NUM, sizeof(MX_TYPE));
  printf("OK\n");

  // inicializando os valores da matriz 1 e 2 (utilizando os valores dos índices)
  printf("inicializando matrizes 1 e 2...");

  for(i = 0; i<NUM; i++){
    for(j = 0; j<NUM; j++){
      m1_1d[NUM*i+j] = i;
      m2_1d[NUM*i+j] = j;
    }
  }
  printf("OK\n");

  // multiplicando matrizes 1 e 2, salvando resultado na matriz 3
  printf("multiplicando matrizes 1 e 2...");

  for(i=0;i<NUM;i++){
    for(j=0;j<NUM;j++){
      for(k=0;k<NUM;k++){
        m3_1d[NUM*i+j] += m1_1d[NUM*i+k] * m2_1d[NUM*k+j];
      }
    }
  }
  printf("OK\n");

  // salvando a matriz 3 em um arquivo para conferência no código paralelo
  printf("salvando matriz resultado no arquivo 'mx.data'...");

  int written = 0;
  FILE *f = fopen("mx.data", "wb");
  written = fwrite(m3_1d, sizeof(MX_TYPE), NUM*NUM, f);
  if (written == 0){
    printf("erro durante escrita para o arquivo !\nabortando...\n");
    return -1;
  }
  else printf("OK\n");
  fclose(f);

  // desalocando memória das matrizes:
  printf("\ndesalocando memória...");

  free(m1_1d);
  free(m2_1d);
  free(m3_1d);
  printf("OK\n");

  return 0;
}
