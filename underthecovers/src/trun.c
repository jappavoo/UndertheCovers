#include <stdio.h>

int main(int argc, char **argv)
{
  unsigned int i;
  unsigned char ci;

  for (i=0; i<0xfffffffff; i++) {
    ci = i;
    printf("i=%u ci=%u i mod 256=%u\n", i, ci, i%256);
  }
  return 0;
}
