.PHONEY: all

all: popcnt simple main

popcnt: popcnt.S
	gcc --static  -g -nostartfiles -nolibc popcnt.S -o popcnt

simple: simple.S
	gcc --static  -g -nostartfiles -nolibc simple.S -o simple

main: main.S
	gcc --static -g main.S -o main

clean:
	rm main simple *.o
