	.intel_syntax noprefix   # set assembly language format to intel
 	
	.data                    # Place the following in the data area
myvar:	.quad 0x00000000000000ff # place the 8 byte value at a location who's
	                         # address we can refer to by the symbolic
	                         # name myvar
	
	.text                    # Place the following in the area that
	                         # instruction should be encoded and stored
	                         # for historical reasons it is called text
	.global _start
_start:                          # The linker knows to mark the _start address
                              	 # as location where execution should begin.
	                         # The OS will be sure to setup the CPU so that the
	                         # program counter is initialized with this address
	
	mov rax, 0xdeadbeef   	 # mov the immediate value hex deadbeef into rax
	mov rdi, qword ptr myvar # mov the value of a the address myvar into rdi
	and rax, rdi             # rax = rax AND rdi 
	
	int3                     # trap to the debugger
	
