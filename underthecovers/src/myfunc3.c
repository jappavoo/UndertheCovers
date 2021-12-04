__attribute__ ((noinline))
int func2(int x, int y)
{
  return x + y;
}

int func1(int x)
{
  return func2(x,2);
}
