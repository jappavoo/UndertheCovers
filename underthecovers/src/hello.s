	.intel_syntax noprefix
	.section .rodata
str:
	.string "Hello World\n"

	.section .text
	.global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, OFFSET str
	mov rdx, 12
	syscall

	mov rax, 60
	mov rdi, 3
	syscall
	
