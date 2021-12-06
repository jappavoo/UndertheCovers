#include <stdlib.h>
#include <assert.h>

// waits for request message to arrive: returns length in bytes and updates integer pointed to
// by idPtr with id of request
int getRequest(int *idPtr);
// read the data of request with id into memory pointed to by buffer
void readRequestData(int id, char *buffer);
// process request with id and data in memory pointed to by buffer, frees buffer when done
void processRequest(int id, char *buffer);

int
main(int argc, char **argv)
{
  int n;
  int *id_ptr;
  char *msg_buffer;

  // my server loop
  while (1) {
    id_ptr = malloc(sizeof(int));
    assert(id_ptr != 0);
    n = getRequest(id_ptr);
    msg_buffer = malloc(n);
    assert(msg_buffer != 0);
    readRequestData(*id_ptr, msg_buffer);
    processRequest(*id_ptr, msg_buffer);
  }
  // should never get here
  exit(0);
}
