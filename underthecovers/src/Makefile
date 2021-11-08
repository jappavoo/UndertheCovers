ASMTARGETS=popcnt simple empty add addwithvars hello exit exit_bb exit_bb_bb brk int3 main cbrk mov usesum usesum2 usesum3 usesum4 usesum5
CTARGETS=hello cbrk
ASM6502TARGETS=6502add

DEBUG:=-g

.PHONEY: all clean

# override default behaviour of removing .o's as intermediate file cleanup
.PRECIOUS: %.o %.I

# default rule for standalone assembly examples
# override standard defaults
%: %.s
%: %.c 
%: %.S

%.I: %.S
	gcc -E $< -o $@	

%.o: %.I
	as ${DEBUG} -a=$@.lst $< -o $@

%.o: %.S
	as ${DEBUG} -a=$@.lst $< -o $@

%: %.o
	ld ${DEBUG} -Map=$@.map $^ -o $@

#	gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=$@.map  $< -o $@ > $@.lst


%: %.c
	gcc -O0 -g $< -o $@

%.bin: %.nums
	ascii2binary -t sq < $< > $@

%.6502_o: %.6502_s
	ca65 $< -o $@ -l $@.lst

%: %.6502_o 6502.cfg
	ld65 -o $@ -C 6502.cfg $< -m $@.map
	od -An -tx1 -w5  $@

all: ${ASMTARGETS} ${CTARGETS} ${ASM6502TARGETS}

usesum: usesum.o sumit.o

usesum2: usesum2.o sumit2.o

usesum3: usesum3.o sumit3.o

usesum4: usesum4.o sumit3.o

usesum5: usesum5.o sumit5.o

# overides so that we use cpp to proces includes
exit.o: exit.I
exit_bb.o: exit_bb.I
brk.o: brk.I

10num.bin: 10num.txt
	ascii2binary -t sq 10num.tx < $< > $@


100randomnum.bin:
	dd if=/dev/random of=$@ bs=1 count=800

# main.S is now a libc compatiable assembly file so we need stanadard crt and libs
main: main.S
	gcc --static -g $< -o $@

clean:
	rm -f $(wildcard ${ASMTARGETS} ${CTARGETS} ${ASM6502TARGETS} *.o *.6502_o *~ *.lst *.map *.I)
