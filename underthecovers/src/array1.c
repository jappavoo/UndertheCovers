
#define CODE_LEN 6
typedef long long code[CODE_LEN];

code codeA = { 2, 1, 7, 8, 3, 1 };
code codeC = { 1, 0, 0, 1, 6, 5 };
code codeD = { 0, 5, 4, 8, 9, 2 };

long long * ctbl1[3] = { codeD, codeA, codeC };

#define NUM_CODES 4
code codes[NUM_CODES] =
  { { 2, 1, 7, 8, 3, 1 },
    { 1, 0, 0, 1, 6, 5 },
    { 0, 5, 4, 8, 9, 2 },
    { 9, 6, 7, 7, 1, 4 } };

long long * ctbl2[NUM_CODES] =
  { codes[3], codes[0], codes[2], codes[1] };

long getCodeDigit(code c, long long d)
{
  return c[d];
}

void replaceCodeValue(code c, long long vo, long long vn)
{
  long long i;
  for (i=0; i<CODE_LEN; i++) {
    if (c[i] == vo) c[i] = vn;
  }
}

long long * getCode(long long i)
{
  return codes[i];
}

long long getDigit(long long r, long long c)
{
  return codes[r][c];
}

long long getCtbl1Digit(long long i, long long d)
{
  return ctbl1[i][d];
}

int main()
{
  return (int)getCtbl1Digit(3,4);
}


