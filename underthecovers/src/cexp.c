#include <math.h> /* for atan */
#include <stdio.h>
#include <complex.h>
#include <stdlib.h>

int
main(int argc, char **argv)
{
  double y=1.0;
  if (argc>1) y=atof(argv[1]);
  double pi = 4 * atan(y);
  double complex z = cexp(I * pi);
  printf("%f + %f * i\n", creal(z), cimag(z));
}
