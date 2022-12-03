#include <stdio.h>
#include <limits.h>

int 
main(int argc, char **argv)
{
  int x = INT_MIN;
  int y = INT_MAX;
  int z = INT_MIN + INT_MAX;

  printf("x: %d %u (0x%08x) y: %d %u (0x%08x) z: %d %u (0x%08x)\n",
	 x, x, x,
	 y, y, y,
	 z, z, z);
  
  return 0;
}
