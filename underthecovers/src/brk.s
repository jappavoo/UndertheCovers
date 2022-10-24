#include <asm/unistd_64.h> 	
	.intel_syntax noprefix
	
	.equ UNIX_SUCCESS_VALUE, 0      
	.equ LINUX_SYSCALL_EXIT, __NR_exit
	.equ LINUX_SYSCALL_SBRK,  __NR_brk

	.data
brk_ptr:
	.quad 0
head:
	.quad 0
	
	.text
	.global _start
_start:

	mov     rax, LINUX_SYSCALL_SBRK
	mov     rdi, 0
	syscall

	mov     rdi, rax
	mov     QWORD ptr brk_ptr, rdi      # update brk_ptr
	mov     QWORD ptr head, rdi         # set head to brk_ptr
	
	add     rdi, 32                     # ask for 32 bytes
	mov     rax, LINUX_SYSCALL_SBRK
	syscall
	mov     QWORD ptr brk_ptr, rdi      # update brk_ptr

	
	mov     rax, LINUX_SYSCALL_EXIT 	
	mov     rdi, UNIX_SUCCESS_VALUE
	syscall                         	
