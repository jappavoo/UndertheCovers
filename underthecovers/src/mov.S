	.intel_syntax noprefix
	.text
	
	.equ EXIT_SYSCALL_NR,60
	
	.global _start
_start:
	mov rax, 0b1000

	mov rax, EXIT_SYSCALL_NR
	mov rdi, 2
	syscall
	
	
