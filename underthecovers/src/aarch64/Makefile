.PHONEY: all clean

all: hello test
test: test.o
	ld -g -o $@ $<

test.o: test.s
	as -g $< -o $@

hello: hello.o
	ld -g -o $@ $<

hello.o: hello.s
	as -g $< -o $@

clean:
	-rm -rf $(wildcard *.o hello test)
