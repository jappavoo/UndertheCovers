	.intel_syntax noprefix
	.section .rodata       # readonly data
str:
	.string "Hello World\n"  # the string

	.section .text
	.global _start
_start:
	mov rax, 1          # write syscall number 1
	mov rdi, 1          # fd = rdi = stdout = 1
	mov rsi, OFFSET str # address of data to send
	mov rdx, 12         # length of data
	syscall   

	mov rax, 60         # exit syscall number 60
	mov rdi, 3          # rdi = exit status code = 3
	syscall
