/*  General antomy of a assembly program line
[lablel]:   <directive or opcode> [operands]  # comment
*/
	.intel_syntax noprefix   # assembler syntax to use <directive>
	                         # set assembly language format to intel  

	.text                    # linker section <directive>
	                         # let the linker know that what follows are cpu instructions to
	                         # to be executed -- uposed to values that represent data.
	                         # For historical reasons cpu instructions are called "text"
	                         
	.global _start           # linker symbol type <directive> 
	                         # makes the symbol _start in this case visible to the linker
	                         # The linker looks for an _start symbol so that it knows address
	                         # of the first instruction of our program
	
_start:                          # introduce a symbolic (human readable) label for "this" address
	                         # associates the address of this point in our program with the
      	                         # name following the ':' -- in our case _start
	                         # In our program or in the debugger we can use this name to
	                         # to refer to this location -- address.  And thus the values
	                         # that end up here.
#	.byte 0xF3, 0x48, 0x0F, 0xB8, 0xD8  # popcnt rax,rbx	
	popcnt rax, rbx          # ok the single intel opcode (instruction) that makes up
	                         # our program
/*
     Details about the assembler directives and general syntax that we will be using
     https://sourceware.org/binutils/docs/as/
     Intel instruction set reference -- documents the cpu memonics/instructions of
                                    the computer's processor that we are writing for
	 https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-2a-2b-2c-and-2d-instruction-set-reference-a-z.html
*/
