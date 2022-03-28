/*
Escolha 2 séries quaisquer para aproximar o número pi. Veja exemplos sequenciais em Pi sequencial. Implemente a
versão paralela dessas séries, ulizando pthreads, sequindo os seguintes requisitos:
* Devem ser calculados pelo menos 1 bilhão (10^9) de termos de cada série.
* Use variáveis reais de dupla precisão (double) nos cálculos;
* O programa deve dividir o espaço de cálculo uniformemente entre as N threads
    - e.x. 1 bilhao de termos com 2 threads = 500 milhoes de termos em cada thread;
    - cada thread efetua uma soma parcial de forma autônoma;
    - Para evitar o uso de mecanismos de sincronização, cada thread T[i] deve depositar seu resultado parcial na posição result[i] de um vetor de resultados parciais.
* Após o término das threads de cálculo, o programa principal soma os resultados
parciais obdos por elas e apresenta o resultado final na tela;
* Execute as threads no seu computador pessoal
* Execute as soluções com N = {1, 2, 4, 8 e 16} threads
* Marque o tempo necessário para calcular Pi para cada N e faça um gráfico de linhas (NxTempo)
 apresentado os resultados obtidos
* Compare o resultado das duas soluções (series) escolhidas, indicando qual série é mais eficiente
 em termos de tempo e qualidade da solução (i.e. valor mais exato de pi)
*/
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<math.h>
#include<pthread.h>

#define N_THREADS 1
#define N_TERMOS_SERIE 1000000000

long parc[8*N_THREADS];
long result = 0;

void* calcula_pi(void* i){

    long tid = (long)i;
    int termos = N_TERMOS_SERIE/N_THREADS;
    int inicio = tid*termos;
    int fim = tid*termos + termos;

	for(int i = inicio; i < fim; i++)
        parc[8*tid] += pow(-1,i) / (2*i+1);
}

int main(void){

    pthread_t threads[N_THREADS];
    int i;

    for(i = 0; i < N_THREADS; i++) 
        parc[N_THREADS*i] = 0;
    
    for(i = 0; i < N_THREADS; i++)
        pthread_create(&threads[i], NULL, calcula_pi, (void*)(intptr_t)i);
    
    for(i = 0; i < N_THREADS; i ++){

        pthread_join(threads[i],NULL);
        result += parc[N_THREADS*i];
    }

    printf("Valor final: %.2ld\n",result);

    return 0;
}