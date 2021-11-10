	.intel_syntax noprefix

	# 8 byte X  variable 
	.comm X, 8, 8
	
	.text
	.global _start	
_start:	
	mov rax, OFFSET X

	# direct call
	call myfunc2
after_call1:	
	
	# indirect call via function pointer
	# in rcx
	mov rcx, OFFSET myfunc1
	call rcx
after_call2:
	
	# indirect call via "virtual" function table
	# aka jump table of function pointers
	# rcx used as index
	mov rcx, 0
	call [myjmp_table + rcx * 8]
after_call3:
	
	int3

myfunc2:
	mov rbx, 0xdeadbeefdeadbeef
	mov QWORD PTR [rax], rbx
	ret
	
myfunc1:
	mov rbx, 0xfeedfacefeedface
	mov QWORD PTR [rax], rbx
	ret
	
	.data
myjmp_table:
	.quad myfunc2   # entry 0
	.quad myfunc1   # entry 1
	

	



