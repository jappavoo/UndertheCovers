	.intel_syntax noprefix

	.section .text

	# tell linker that sumIt symbol can be referenced in other files	
	.global sumIt	  

	# code to sum data in array who's address is in rcx
	# we assume we were started with call so return address on stack
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
sumIt:	                         # label that marks where this code begins
	xor  rax, rax            # rax -> sum : sum = 0
	push rdi                 # spill current value of rdi before we use it
	xor  rdi, rdi            # rdi -> i : i = 0
	
	# code to sum data in array who's address is in rcx
	# we assume we were started with call so return address on stack
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
loop_start:                                 
	cmp  rbx, rdi                       # rbx - rdi
	jz   loop_done                      # if above is zero (they are equal) jump
	add  rax, QWORD PTR [rcx + rdi * 8] # add the i'th value to the sum
	inc  rdi                            # i=i+1
	jmp  loop_start                     # go back to the start of the loop
loop_done:
	pop  rdi                            # restore rdi back to its original value
	ret                                 # use return to pop value off the stack
	                                    # and jump to that location

