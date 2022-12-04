#include <stdio.h>
#include <stddef.h>

struct MyStruct {
  long long v1;
  char v2;
  long double v3;
  char v4;
} s;


int main(int argc, char **argv)
{
  printf("v1:sizeof(long long)=%ld\n"
	 "v2:sizeof(char)=%ld\n"
	 "v3:sizeof(long double)=%ld\n"
	 "v4:sizeof(char)=%ld\n"
	 "Total: %ld\n",
	 sizeof(long long), sizeof(char), sizeof(long double), sizeof(char), 
	 sizeof(long long) + sizeof(char) + sizeof(long double)+ sizeof(char));
  printf("sizeof(struct MyStruct)=%ld\n", sizeof(struct MyStruct));
  printf("struct MyStruct field offsets:\n"
	 "  offsetof(struct MyStruct, v1)=%ld\n"
	 "  offsetof(struct MyStruct, v2)=%ld\n"
	 "  offsetof(struct MyStruct, v3)=%ld\n"
	 "  offsetof(struct MyStruct, v4)=%ld\n",
	 offsetof(struct MyStruct, v1),
	 offsetof(struct MyStruct, v2),
	 offsetof(struct MyStruct, v3),
	 offsetof(struct MyStruct, v4));
	 
  return 0;
}
