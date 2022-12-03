#include<stdio.h>

void a(int x) {
  if  (x>-10) { printf("greater\n"); }
  else { printf("NOT greater\n"); }
}

void b(unsigned int x) {
  if  (x>-10) { printf("greater\n"); }
  else { printf("NOT greater\n"); }
}

int main(int argc, char **argv)
{
  a(0);
  b(0);
  return 0;
}
