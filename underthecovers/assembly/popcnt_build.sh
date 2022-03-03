#To assemble and link the code we will use the following command:
as -g popcnt.s -o popcnt.o
ld -g popcnt.o -o popcnt

# We can automate this using a makefile so that all we would need to do is:
make popcnt
