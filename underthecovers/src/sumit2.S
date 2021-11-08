	.intel_syntax noprefix
	
	.global sumIt	      	      #	 directive to let the linker

	# code to sum data in array who's address is in rcx
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
sumIt:	                              # location of this code is
	xor  rax, rax            # rax -> sum : sum = 0
	xor  rdi, rdi            # rax -> i : i = 0

	# code to sum data at value in rcx
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
loop_start:
	cmp  rbx, rdi
	jz   loop_done
	add  rax, QWORD PTR [rcx + rdi * 8] # add the i'th value to the sum
	inc  rdi                   # i=i+1
	jmp   loop_start
loop_done:
	jmp RETURN_1

