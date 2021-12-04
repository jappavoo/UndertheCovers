__attribute__ ((noinline))
void myfunc2(long long *i)
{
  *i += 1;
}

long long myfunc(void) {
  long long i=(long long)&myfunc;
  myfunc2(&i);
  return i;
}
