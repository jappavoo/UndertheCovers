	.intel_syntax noprefix
	
	.text
	.global _start
_start:      	
	mov     rax, 60    # Linux exit system call number is 60       
	mov     rdi, 0     # rdi is return value 0 success

	syscall                         	
