ASMTARGETS=popcnt simple empty empty256 oneplusone add addwithvars hello read exit exit_bb exit_bb_bb brk int3 main cbrk mov usesum usesum2 usesum3 usesum4 usesum5 usesum6 codeptrs selfmodify tree tree_bb playertest usesumheap usesumIO usecsumit usecsumit1 callmyadd cexp dynmem dynmemsyscalls exploringASlayout1 exploringASlayout2 exploringASlayout3 exploringASlayout4 exploringASlayout5  mmap useshared1 useshared2 usesumshared1static usesumshared2static usesumshared1dynamic usesumshared2dynamic 
CTARGETS=hello cbrk

ASFLAGS=-a=$@.lst
LDFLAGS=-Map=$@.map
DEBUG=-g

.PHONY: all clean

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
	as ${DEBUG} ${ASFLAGS} $< -o $@

%.o: %.S
	as ${DEBUG} ${ASFLAGS} $< -o $@

%.o: %.s
	as ${DEBUG} $(ASFLAGS) $< -o $@

# -fverbose-asm
# -v
%.s: %.c
	gcc -fno-inline -fno-stack-protector -fno-pic  -static -Werror -fcf-protection=none -fno-asynchronous-unwind-tables -Os -S -masm=intel $^ -o $@

%.so: %.o
	ld ${DEBUG} $(LDFLAGS) -shared $^ -o $@

%: %.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

#	gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=$@.map  $< -o $@ > $@.lst


%: %.c
	gcc -O0 -g $< -o $@

%.bin: %.nums
	ascii2binary -t sq < $< > $@

%.dis: %
	objdump -d $< > $@

all: ${ASMTARGETS} ${CTARGETS}

usesum: usesum.o sumit.o

usesum2: usesum2.o sumit2.o

usesum3: usesum3.o sumit3.o

usesum4: usesum4.o sumit3.o

usesum5: usesum5.o sumit5.o

usesum6: usesum5.o sumit6.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

usesumshared1static: usesumshared1.o sumitshared.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

usesumshared2static: usesumshared2.o sumitshared.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

usesumshared1dynamic: usesumshared1.o ${PWD}/sumitshared.so
	ld ${DEBUG} $(LDFLAGS)  $^ -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -z now -z relro -o $@

usesumshared2dynamic: usesumshared2.o ${PWD}/sumitshared.so
	ld ${DEBUG} $(LDFLAGS)  $^ -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -z now -z relro -o $@

useshared1: useshared1.o ${PWD}/sharedfuncs.so
	ld ${DEBUG} $(LDFLAGS)  $^ -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -z now -z relro -o $@

useshared2: useshared2.o ${PWD}/sharedfuncs.so
	ld ${DEBUG} $(LDFLAGS)  $^ -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -z now -z relro -o $@

csumit1.o: csumit1.s

usecsumit: usecsumit.o csumit.o

usecsumit1: usecsumit1.o csumit1.o

selfmodify: selfmodify.o
	ld --omagic ${DEBUG} $(LDFLAGS) $^ -o $@

playertest: playertest.o findplayer.o

usesumheap: usesumheap.o sumit6.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

usesumIO: usesumIO.o sumit6.o
	ld ${DEBUG} $(LDFLAGS) $^ -o $@

main0: main0.s myfunc0.s
	gcc $(VERBOSE) -fno-pic -static -Os ${DEBUG} $^ -o $@

callmyadd: callmyadd.s myadd.s myadd.h
	gcc $(VERBOSE) -fno-pic -static -Os ${DEBUG} $^ -o $@

cexp: cexp.c
	gcc $(VERBOSE) $(DEBUG)  -Os -static -Xlinker -Map=$@.map $< -o $@ -lm

dynmem: dynmem.c 
	gcc -Werror $(VERBOSE) $(DEBUG) $^ -o $@

dynmemsyscalls: dynmemsyscalls.c 
	gcc -Werror $(VERBOSE) $(DEBUG) $^ -o $@

badmsgcode.o: badmsgcode.c
	gcc $(VERBOSE) $(DEBUG) -Werror -c  $^ -o $@
# overides so that we use cpp to proces includes
exit.o: exit.I
exit_bb.o: exit_bb.I

10num.bin: 10num.txt
	ascii2binary -t sq < $< > $@


100randomnum.bin:
	dd if=/dev/urandom of=$@ bs=1 count=800

# main.S is now a libc compatiable assembly file so we need stanadard crt and libs
main: main.S
	gcc --static -g $< -o $@

clean:
	rm -f $(wildcard ${ASMTARGETS} ${CTARGETS} *.o *~ *.lst *.map *.I csumit.s myfunc0.s myfunc1.s myfunc2.s myfunc3.s main0.s myadd.s callmyadd.s csumit1.s  main0 *.dis *.so)
