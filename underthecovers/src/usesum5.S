	.intel_syntax noprefix
	.data	
	.comm A_SUM, 8, 8
	.comm A_LEN, 8, 8
	.comm A, 8*1024, 8	

	.comm B_SUM, 8, 8
	.comm B_LEN, 8, 8
	.comm B, 8*1024, 8	

	.comm C_SUM, 8, 8
	.comm C_LEN, 8, 8
	.comm C, 8*1024, 8	

	.text
	.global _start 
_start:
	mov rbx, QWORD PTR [A_LEN]
	mov rcx, OFFSET A
	call sumIt
	mov QWORD PTR [A_SUM], rax

	mov rbx, QWORD PTR [B_LEN]
	mov rcx, OFFSET B
	call sumIt
	mov QWORD PTR [B_SUM], rax

	mov rbx, QWORD PTR [C_LEN]
	mov rcx, OFFSET C
	call sumIt
	mov QWORD PTR [C_SUM], rax
	int3
