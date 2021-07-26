#To assemble and link the code we will use the following command:
gcc --static -g -nostartfiles -nolibc popcnt.S -o popcnt
# We can automate this using a makefile so that all we would need to do is:
make popcnt
