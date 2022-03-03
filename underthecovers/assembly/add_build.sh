# add targets to Makefile
make add

as -g add.s -o add.o
ld -g add.o -o add
