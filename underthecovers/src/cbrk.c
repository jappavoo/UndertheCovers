#include <unistd.h>
#include <sys/syscall.h>

int 
main() {

  long rtn = syscall(0xc, 0);
  asm ("int3");
}
