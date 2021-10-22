ASMTARGETS=popcnt simple empty add hello exit exit_bb exit_bb_bb brk

.PHONEY: all

# default rule for standalone assembly examples
%: %.S
	gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=$@.map  $< -o $@ > $@.lst

%: %.s
	gcc --static -g $< -o $@

all: ${ASMTARGETS} hello 6502add

hello: hello.c
	gcc -O0 -g hello.c -o hello

6502add.o: 6502add.s
	ca65 6502add.s -l 6502add.lst

6502add: 6502add.o
	ld65 -o 6502add -C 6502.cfg 6502add.o -m 6502add.map
	od -An -tx1 -w5  6502add

clean:
	rm -f $(wildcard ${ASMTARGETS} hello 6502add  *.o *~ *.lst *.map)
