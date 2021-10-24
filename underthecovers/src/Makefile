ASMTARGETS=popcnt simple empty add hello exit exit_bb exit_bb_bb brk main cbrk
CTARGETS=hello cbrk
ASM6502TARGETS=6502add

.PHONEY: all

# default rule for standalone assembly examples
%: %.S
	gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=$@.map  $< -o $@ > $@.lst


%: %.c
	gcc -O0 -g $< -o $@

%.6502_o: %.6502_s
	ca65 $< -o $@ -l $@.lst

%: %.6502_o 6502.cfg
	ld65 -o $@ -C 6502.cfg $< -m $@.map
	od -An -tx1 -w5  $@

all: ${ASMTARGETS} ${CTARGETS} ${ASM6502TARGETS}

# main.S is now a libc compatiable assembly file so we need stanadard crt and libs
main: main.S
	gcc --static -g $< -o $@

clean:
	rm -f $(wildcard ${ASMTARGETS} ${CTARGETS} ${ASM6502TARGETS} *.o *.6502_o *~ *.lst *.map)
