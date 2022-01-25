SOL6502LIBOBJS = sol6502lib/interrupt.o sol6502lib/crt0.o sol6502lib/cputc.o sol6502lib/cgetc.o sol6502lib/oserror.o

%.o: %.c

%.s: %.c
	cc65 -t none -O -Oi --cpu 6502 $< -o $@

%.o: %.s
	ca65 --cpu 6502 $< -o $@ 

sol6502.lib: /usr/share/cc65/lib/none.lib $(SOL6502LIBOBJS)
	cp /usr/share/cc65/lib/none.lib  $@
	ar65 a $@ $(SOL6502LIBOBJS)

%.img: %.o SOL6502CC.cfg sol6502.lib
	ld65 -C SOL6502CC.cfg -o $@ $< sol6502.lib


clean:
	-rm -f $(wildcard *.o *.s *.lst *.img *.map $(SOL6502LIBOBJS))
