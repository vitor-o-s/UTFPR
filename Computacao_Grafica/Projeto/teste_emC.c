#include <stdio.h>

void mandelbrot_Set(int iterations, float set[iterations], int threshold, float left, float top, int max_steps)
  { 
    int i, j;
    float maxx = 2.48/(iterations-1);
    float maxy = 2.26/(iterations-1);

    for(i = 0; i < iterations; i++){
      for(j = 0; j < iterations; j++){

        float real_c = i*maxx + left;
        float imag_c = j*maxy + top;
        float real_z = real_c;
        float imag_z = imag_c;

        int count = 0;
        float condition = real_z*real_z - imag_z*imag_z;
        while(condition < threshold && (count < max_steps)){
          real_z = (real_z*real_z - imag_z*imag_z) + real_c;
          imag_z = (real_z*imag_z + real_z+imag_z) + imag_c;
          condition = real_z*real_z - imag_z*imag_z;
          count++;
        }
        //printf("Acabamos o while\n");
        set[i+j] = 255 - count;
      }
    }
  }

int main(void){

  int i, j, n = 10;
  float matrix[2*n];

  for(i = 0; i < n; i++){
    for(j = 0; j < n; j++){
      matrix[i] = 255;
    }
  }
  printf("Matriz Criada\n\n");

  mandelbrot_Set(n, matrix, 4, -2, -1.13, 50);
 
   for(i = 0; i < n; i++){
    for(j = 0; j < n; j++){
        printf("%.2f ", matrix[i+j]);
    }
    printf("\n");
  }
}