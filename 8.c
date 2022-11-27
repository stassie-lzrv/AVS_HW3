#include <stdio.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

double f(double a, double b, double x){
  return a + b / (x * x * x * x);
}

double S(double a, double b, int A, int B){
  int n = 1000000000;
  double h = (float)(B - A) / n;
  double sum = 0.0;
  double d = A + h / 2;
  for(int i = 0; i < n - 1; i++){
    sum += f(a, b, d);
    d = d + h;
  }
  return h * sum;
}

int main(int argc, char *argv[]) {
  if((argc != 2) && (argc != 4)&& (argc != 3)){
    printf("Incrorrect input, check README.md\n");
    return 0;
  }
  clock_t start, end;
  if(strcmp(argv[1], "-r") == 0){
    if(argc != 3){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    srand(time(NULL));
    FILE *out = fopen(argv[2], "w");
    if((out == NULL)){
      printf("incorrect file\n");
      return 0;
    }
    double a = (rand()%10);
    double b = (rand()%15);
    int A = (rand()%15 + 2);
    int B = (rand()%15 + 17);
    fprintf(out, "random numbers: a = %lf, b = %lf, A = %d, B = %d\n", a, b, A, B);
    start = clock();
    double s = S(a, b, A, B);
    end = clock();
    fprintf(out, "root: %lf\ntime: %.6lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(out);
  }
  else if(strcmp(argv[1], "-h") == 0){
    printf("\n-h help\n");
    printf("-r create random numbers (a, b, A, B)\n");
    printf("-f use numbers from first file and save result in second file\n");
    printf("-s take numbers from terminal and print result in file\n");
  }
  else if(strcmp(argv[1], "-f") == 0){
    if(argc != 4){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    FILE *input = fopen(argv[2], "r");
    FILE *out = fopen(argv[3], "w");
    if((input == NULL) || (out == NULL)){
      printf("incorrect file\n");
      return 0;
    }
    double a, b;
    int A, B;
    fscanf(input, "%lf", &a);
    fscanf(input, "%lf", &b);
    fscanf(input, "%d", &A);
    fscanf(input, "%d", &B);
    start = clock(); 
    double s = S(a, b, A, B);
    end = clock();
    fprintf(out, "integral = %lf\ntime: %.6lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(input);
    fclose(out);
  }
  else if((strcmp(argv[1], "-s") == 0)){
    if(argc != 3){
      printf("Incrorrect input, check README.md\n");
      return 0;
    }
    FILE *out = fopen(argv[2], "w");
    if((out == NULL)){
      printf("incorrect file\n");
      return 0;
    }
    double a, b;
    int A, B;
    scanf("%lf", &a);
    scanf("%lf", &b);
    scanf("%d", &A);
    scanf("%d", &B);
    start = clock();
    double s = S(a, b, A, B);
    end = clock();
    fprintf(out, "integral = %lf\ntime: %.6lf\n", s, (double)(end-start)/(CLOCKS_PER_SEC));
    fclose(out);
  }
  return 0;
}
