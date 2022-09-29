popcnt: popcnt.o
	ld -g popcnt.o -o popcnt

popcnt.o: popcnt.s
	as -g popcnt.s -o popcnt.o

add: add.o
	ld -g add.o -o add

add.o: add.s
	as -g add.s -o add.o

exit: exit.o
	ld -g exit.o -o exit

exit.o: exit.s
	as -g exit.s -o exit.o

int3: int3.o
	ld -g int3.o -o int3

int3.o: int3.s
	as -g int3.s -o int3.o

exitfancy: exitfancy.o
	ld -g exitfancy.o -o exitfancy

exitfancy.o: exitfancy.s
	as -g exitfancy.s -o exitfancy.o

exitfancy.s: exitfancy.S
	gcc -E exitfancy.S > exitfancy.s

clean:
	-rm -f $(wildcard *.o  popcnt  add int3 exit exitfancy exitfancy.s)
