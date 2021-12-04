	.intel_syntax noprefix

	.global _start	
_start:
	call sumit
	mov rdi, 0      # rdi = 0 = exit return value
	mov rax, 60     # rax = 60 = exit syscall num
	syscall         # exit(0)
