.PHONEY: all

all: popcnt simple empty add exit main hello exit_bb

popcnt: popcnt.S
	gcc --static -g -nostartfiles -nolibc popcnt.S -o popcnt

simple: simple.S
	gcc --static -g -nostartfiles -nolibc simple.S -o simple

empty: empty.S
	gcc --static -g -nostartfiles -nolibc empty.S -o empty

add: add.S
	gcc --static -g -nostartfiles -nolibc add.S -o add

addwithvars: addwithvars.S
	gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=$@.map  $< -o $@ > $@.lst

exit: exit.S
	gcc --static -g -nostartfiles -nolibc exit.S -o exit

exit_bb: exit_bb.S
	gcc --static -g -nostartfiles -nolibc $< -o $@

exit_bb_bb: exit_bb_bb.S
	gcc --static -g -nostartfiles -nolibc $< -o $@

main: main.S
	gcc --static -g main.S -o main

hello: hello.c
	gcc -O0 -g hello.c -o hello

6502add.o: 6502add.s
	ca65 6502add.s -l 6502add.lst

6502add: 6502add.o
	ld65 -o 6502add -C 6502.cfg 6502add.o -m 6502add.map
	od -An -tx1 -w5  6502add

clean:
	rm -f $(wildcard popcnt main simple hello 6502add exit *.o *~ *.lst *.map empty add exit_bb exit_bb_bb addwithvars)
