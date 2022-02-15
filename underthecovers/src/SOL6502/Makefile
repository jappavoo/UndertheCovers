%.o: %.s
	ca65 $< -l $@.lst -o $@


%.img: %.o SOL6502.cfg
	ld65 -o $@ -C SOL6502.cfg $< 
#	od -An -t1 -w5  $@

add.img:

clean:
	-rm $(wildcard *.o *.lst *.map *.img)

