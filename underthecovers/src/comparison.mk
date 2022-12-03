comparison: comparison.c
	gcc -g -fno-inline -static -Os comparison.c -o comparison

comparison.s: comparison.c
	gcc -fno-inline -fno-stack-protector -fno-pic  -static -Werror -fcf-protection=none -fno-asynchronous-unwind-tables -Os -masm=intel comparison.c -o comparison.s -S

clean:
	-rm -rf $(wildcard comparison comparison.s)
