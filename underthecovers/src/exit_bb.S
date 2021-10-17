#include <asm/unistd_64.h> 	
	.intel_syntax noprefix
	
	.equ UNIX_SUCCESS_VALUE, 0      
	.equ LINUX_SYSCALL_EXIT, __NR_exit

	.text
	.global _start
_start:      	
	mov     rax, LINUX_SYSCALL_EXIT 	
	mov     rdi, UNIX_SUCCESS_VALUE
	syscall                         	
