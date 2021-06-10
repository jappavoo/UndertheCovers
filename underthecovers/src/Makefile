.PHONEY: all

all: popcnt simple exit main

popcnt: popcnt.S
	gcc --static -g -nostartfiles -nolibc popcnt.S -o popcnt

simple: simple.S
	gcc --static -g -nostartfiles -nolibc simple.S -o simple

exit: exit.S
	gcc --static -g -nostartfiles -nolibc exit.S -o exit

main: main.S
	gcc --static -g main.S -o main

6502add.o: 6502add.s
	ca65 6502add.s -l 6502add.lst

6502add: 6502add.o
	ld65 -o 6502add -C 6502.cfg 6502add.o -m 6502add.map
	od -An -tx1 -w5  6502add

clean:
	rm popcnt main simple 6502add exit *.o *~ *.lst *.map
