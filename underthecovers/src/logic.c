#include <stdio.h>

int main(int argc, char **argv)
{
  int x = 0;
  x = !42;               printf("%d\n", x);
  x = !!42;              printf("%d\n", x);
  x = (1 == 2);          printf("%d\n", x);
  x = (2<10);            printf("%d\n", x);
  x = (2<10) && (-1>0);  printf("%d\n", x);
  x = (2<10) && (-1U>0); printf("%d\n", x);
}
