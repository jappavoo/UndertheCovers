#include <stdio.h>

short x;
unsigned int y;

void func1(short a) {
  x = a;
  y = x;  // same as (unsigned int)((int)x)
}

void func2(short a) {
  x = a;
  y = (unsigned int)((unsigned short)x);
}

int
main(int argc, char **argv)
{
  func1(-1);
  printf("y=%d (0x%x)\n", y, y);
  func2(-1);
  printf("y=%d (0x%x)\n", y, y);
  return 0;
}
