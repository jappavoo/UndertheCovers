test: test.o
	ld -g -o $@ $<

test.o: test.s
	as -g $< -o $@
