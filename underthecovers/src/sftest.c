#include <stdio.h>

void readnumbers(void)
{
  long long val;
  long long sum = 0;
  int n;                   

  fprintf(stderr, "Enter values (use '.' to end): ");   
  while (1) {
    n = scanf("%lld", &val);
    printf("n=%d v=%lld\n", n, val);
    if (n!=1) break;
    sum = sum + val;
  }
  while (getchar()!='\n');
  printf("sum=%lld\n", sum);
}

int
main(int argc, char **argv)
{
  readnumbers();
  return 0;
}
