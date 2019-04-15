#include<stdlib.h>
#include<stdio.h>

int * create_static_array(int size) {
  int *arr = malloc(4 * sizeof(int)); /* Ici, on ne connaît pas la valeur des cases mémoires. La valeur de chacune des cases mémoires est totalement aléatoire. */
  arr[0] = 10;
  arr[1] = 3;
  printf("%d\n", arr[0]);
  printf("%d\n", arr[1]);
  printf("%d\n", arr[2]);
  printf("%d\n", arr[7]);
  return arr;
}
int main() {
  create_static_array(4);
}
