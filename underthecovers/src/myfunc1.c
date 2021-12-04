__attribute__ ((noinline))
int funcA(void) {
  return 7;
}

int funcB(void) {
  return 3 + funcA();
}

