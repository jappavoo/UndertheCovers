#include "myadd.h"

long call_myadd(void) {
  long a = 15214;
  long b = myadd(&a, 5001);
  return a+b;
}

long
main() {
  return call_myadd();
}
  
