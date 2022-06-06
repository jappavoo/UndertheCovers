#include <stdio.h>

int main(int argc, char **argv)
{
  int x=1, y=2;
  int *ip=0; // ip is a pointer to an integer

  printf("&x=%p (%d) &y=%p (%d)\n&ip=%p (%p)\n",
	 &x,x,&y,y,&ip,ip);
  
  ip = &x; // ip is pointing to x

  *ip = *ip + 10; 
  y = *ip + 1;
  *ip +=1;
  (*ip)++;

  printf("x=%d, y=%d, *ip = %d, ip=%p\n",
	 x, y, *ip, ip);

  /* '++' and '*' are right-associative */
  ++*ip;
  printf("*ip = %d, ip=%p\n", *ip, ip);

  *ip++; // but what does this do? is it safe?
  printf("*ip = %d, ip=%p\n", *ip, ip);
  return 0;
}
