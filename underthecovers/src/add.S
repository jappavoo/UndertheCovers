	.intel_syntax noprefix
	.data
x:	 .quad 142
y:	 .quad 4200

	.comm sum,8,8

	.text 	
	.global _start
_start:
	mov rax, QWORD PTR x
	add rax, QWORD PTR y
	mov QWORD PTR sum, rax
	int3
	
