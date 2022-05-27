	.intel_syntax noprefix

	.section .data
x:
	.quad 2
y:	
	.quad 3
z:
	.quad 0


	.section .text	
	.global _start
_start:
	mov  rax, -13
	mov  rbx, QWORD PTR [x]
	imul rax, rbx, 42
	mov  QWORD PTR [z], rax
	mov  r8b, 0xff
	movsx  rax, r8b
	movzx  rcx, r8b
	mov    rax, OFFSET here1
	jmp    rax
	int3
here1:
	jmp qword ptr [jt]
	int3
here:
	jmp here
	
	.section .data
jt:
	.quad here
