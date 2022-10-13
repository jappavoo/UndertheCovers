	.intel_syntax noprefix

	.section .text

	# tell linker that sumIt symbol can be referenced in other files
	.global sumIt  

	# code to sum data at XARRAY
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
sumIt:	                              # location of this code is
	xor  rax, rax            # rax -> sum : sum = 0
	xor  rdi, rdi            # rax -> i : i = 0

	# code to sum data at XARRAY
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
loop_start:
	cmp  rbx, rdi
	jz   loop_done
	add  rax, QWORD PTR [XARRAY + rdi * 8] # add the i'th value to the sum
	inc  rdi                   # i=i+1
	jmp   loop_start
loop_done:
	int3
