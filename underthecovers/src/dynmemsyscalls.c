#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/syscall.h>   /* For SYS_xxx definitions */

int
main(int argc, char **argv)
{
  char *cptr;
  int n = 4096;

  cptr = malloc(n);
  memset(cptr, 0xaa, n);
  free(cptr);

  cptr = sbrk(4096);
  memset(cptr, 0xaa, 4096);

  cptr = (void *) syscall(12, 0); // hardcode syscall number
  syscall(SYS_brk, cptr + 4096);  // use constant from header
  memset(cptr, 0xaa, 4096);

  return 0;
}
