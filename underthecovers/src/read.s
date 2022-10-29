	.intel_syntax noprefix

	.section .data
buffer:
	.byte 0x0         # space to read one byte
	                  # from standard input
	.section .text
	.global _start
_start:
	mov rax, 0        # read syscall number 0
	mov rdi, 0        # rdi = fd = stdin = 0
	# rsi address of memory to place data read
	mov rsi, OFFSET buffer
	mov rdx, 1        # maximum bytes to read
	syscall          
	# will "block" until data is received on
	# standard input -- this means we will
	# hang here until some presses enter

	# now exit
	mov rax, 60
	mov rdi, 0
	syscall
