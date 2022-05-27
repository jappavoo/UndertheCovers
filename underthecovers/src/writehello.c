// Alterative hello world closer to what we did in assembly
#include <unistd.h>                // function delarations for
				   // core UNIX calls
char mystr[13] = "hello world\n";  // string in data section
                                   // 12+1 for terminating 0

int main()                         // function declaration - main
{                                  // begin scope for function
  write(STDOUT_FILENO, mystr, 12); // invoke/call libc provided write
  return 0;                        // return value to caller 
}                                  // close scope for function
				   

