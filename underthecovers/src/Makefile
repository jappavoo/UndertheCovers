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


clean:
	rm popcnt main simple exit *.o *~
