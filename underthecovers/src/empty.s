/*  General antomy of a assembly program line
[lablel]:   <directive or opcode> [operands]  # comment
*/
	.intel_syntax noprefix        # assembler syntax to use <directive>
	                              # set assembly language format to intel  

	.text                         # linker section <directive>
	                              # let the linker know that what follows are cpu instructions to
	                              # to be executed -- uposed to values that represent data.
	                              # For historical reasons cpu instructions are called "text"
	                         
	.global _start                # linker symbol type <directive> 
	                              # makes the symbol _start in this case visible to the linker
	                              # The linker looks for an _start symbol so that it knows address
	                              # of the first instruction of our program

_start:                               # introduce a symbolic (human readable) label for "this" address
	                              # associates the address of this point in our program with the
	                              # name following the ':' -- in our case _start
	                              # In our program or in the debugger we can use this name to
	                              # to refer to this location -- address.  And thus the values
	                              # that end up here.
	.byte 0x00, 0x00, 0x00, 0x00  # .byte directive place value at successive locations in memory
	.byte 0x00, 0x00, 0x00, 0x00  # (https://sourceware.org/binutils/docs/as/Byte.html#Byte)
