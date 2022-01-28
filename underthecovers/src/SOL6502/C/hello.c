#include <conio.h>

char str[80]="My string.";

int main(void)
{ 
  char c = 'a';
  int  i = 45;

  cprintf("Hello World!!!\r\n");
  cprintf("c=%c\r\n", c);
  cprintf("i=%d (%x)\r\n", i, i);
  cprintf("str=%s\r\n", str);
  cprintf("sizeof(int)=%d sizeof(long)=%d sizeof(unsigned long)=%d\r\n", 
	  sizeof(int), sizeof(long), sizeof(unsigned long));

  return 0;   
}
