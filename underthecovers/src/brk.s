	.intel_syntax noprefix

	.data
brk_ptr:
	.quad 0
head:
	.quad 0
	
	.text
	.global _start
_start:
	# get current break pointer
	xor rdi, rdi               # pass 0 to brk (invalid request)
	mov rax, 12                # brk syscall number 12
	syscall                    # call brk with 0

	mov     QWORD ptr brk_ptr, rax      # update brk_ptr	
	mov     QWORD ptr head, rax         # set head to brk_ptr

	# now add some memory by requesting to increase the break
	# address by 32 bytes
	mov     rdi, rax            # mov current brk_ptr into rdi
	add     rdi, 32             # ask for 32 bytes rdi=rdi+32
	mov     rax, 12             # brk sycall 12
	syscall
	mov     QWORD ptr brk_ptr, rdi # update brk_ptr to its new value

	# at this point head points to the beginning of our new memory
	# that is 32 bytes in length!
	# write the string hello\n at the start of the new memory
	mov rax, QWORD PTR [head]  # move address of new memory into rax
	mov BYTE PTR [rax], 'h
	mov BYTE PTR [rax+1], 'e
	mov BYTE PTR [rax+2], 'l
	mov BYTE PTR [rax+3], 'l
	mov BYTE PTR [rax+4], 'o
	mov BYTE PTR [rax+5], '\n

	# call write system send string to standard out
	
	mov rdi, 1                 # stdout = 1
	mov rsi, QWORD PTR [head]  # mov address of memory into rsi   
	mov rdx, 7                 # len = 7
	mov rax, 1                 # write syscall number = 1
	syscall
	
	mov     rax, 60 	
	mov     rdi, 0
	syscall                         	
