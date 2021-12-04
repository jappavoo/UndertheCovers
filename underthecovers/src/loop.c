#include "misc.h"

int fetch(struct machine *m) { NYI; }
int decode(struct machine *m) { NYI; }
int execute(struct machine *m) { NYI; }

int
loop(int count, struct machine *m)
{
  int rc = 1;
  unsigned int i = 0;

  if (count<0) return rc;

  while (1) {
    TRACE_LOOP(dump_cpu(m));
    rc = interrupts(m);
    if (rc) rc = fetch(m);
    if (rc) rc = decode(m);
    if (rc) rc = execute(m);
    i++;
    if (rc < 0 || (count && i == count))
      break;
  }
  VPRINT("EXITING: count=%d i=%d\n",count,i);
  return rc;
}

