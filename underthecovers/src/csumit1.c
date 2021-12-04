long long XARRAY[1024];

long long  sumit(void)
{
  long long i = 0;
  long long sum = 0;
  
  for (i=0; i<10; i++) {
    sum += XARRAY[i];
  }
  return sum;
}
