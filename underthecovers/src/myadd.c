long myadd(long *x_ptr, long val)
{
  long x = *x_ptr;
  long y = x + val;
  *x_ptr = y;
  return x;
}

