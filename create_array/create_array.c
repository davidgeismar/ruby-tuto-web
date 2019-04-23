#include<stdlib.h>

int * create_static_array(int size) {
  int *arr = malloc(size * sizeof(int));
  printf("int=%lu bytes\n", sizeof(int));
  return arr;
}
