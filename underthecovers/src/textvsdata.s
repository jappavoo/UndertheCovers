	# To assemble and link this example:
	#
	# as -g -a=textvsdata.lst textvsdata.s -o textvsdata.o
	#
	# We ask the assembler to generate a listing file
	# so that we can see what byte values it generates for
	# each line of source code.  Look at this file it will help
	# you understand what is going on
	#
        # ld -g -Map=textvsdata.map textvsdata.o -o textvsdata
	#
	# Linking it into an executable will let us use gdb to
	# explore the memory image that the code defines.
	  
	.intel_syntax noprefix

	# When we write assembly code we have complete
	# freedom to express byte values in any of the
	# supported ways in any section we like
	# this example trys to illustrate this point

	.section .data    # set the current section to data

        # Default notation is signed integers for constants
	# assembler will put the equivalent 2's complement
	# encode bytes into memory image.  Other formats
	# for values include hex (0x), binary (0b),
	# ascii single character (''), ascii multiple ("")
	
	.byte 1  # reserve one byte with an initial value
	.short 2  # reserve two bytes with an initial value
	.long 3 # reserve four bytes with an initial value
	.quad 4  # reserve eight bytes with an initial value
	
	.byte 'a'            # reserve single byte with that encodes ascii a
	.ascii "hello world" # reserve as many bytes need to encode ascii
	                     # values in quotes (NO terminating zero byte)
	.asciz "hello world" # same as above but extra zero byte added to end

	# with all of the above you can give multiple values and it will
	# encode them as a sequence of the partricular type eg.
	.quad 1,2,3,4            # encodes four 8 byte values initalized 
	.byte 'a', 'b', 'c', 0x0 # four 1 byte values

	# PAY ATTENTION HERE!
	# Now it is equal valid to put the above in the text section too
	.section .text

	.byte 1
	.short 2
	.long 3
	.quad 4
	.byte 'a'
	.ascii "hello world"
	.asciz "hello world"

	# of course an other very powerful encoding that the assembler
	# understands is how to translate mnemonics of the cpu into bytes
	# eg.
	popcnt rax, rbx

	# PAY ATTENTION!!!!
	# But here is the thing that is hard at first to get your
	# head around at first. You can encode bytes in any way you like
	# so you can generate the bytes that encode popcnt rax,rbx
	# in the data section too!
	.section .data
	popcnt rax, rbx

	# It is better to think of the assembler as a tool for laying values
	# out in memory rather than a programming language
	# it is up to you to layout bytes in a usefull way.

	# lets add an _start in .text so that we will be able to link
	# the object file into a binary that you can explore using gdb
	.section .text
	.global _start
	# we will ada
_start:
	# for the record if we know the bytes for an intruction
	# we can specify them as values. Any where we like
	.short 0xcc90  # what am I doing here? Fancy :)
	
