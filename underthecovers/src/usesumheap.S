	.intel_syntax noprefix
	.section .data	
	.comm A_SUM, 8, 8
	.comm A_LEN, 8, 8
	.comm A, 8*1024, 8	

	.comm B_SUM, 8, 8
	.comm B_LEN, 8, 8
	.comm B, 8*1024, 8	

	.comm C_SUM, 8, 8
	.comm C_LEN, 8, 8
	.comm C, 8*1024, 8	

	# Added space heap memory array
	.comm D_SUM, 8, 8
	.comm D_LEN, 8, 8
	.comm D_PTR, 8, 8

	.section .rodata
mystr:	
	.string "Hello World!!!\n"
	
	.section .text
	.global _start 
_start:
	# get current break pointer
	mov rdi, 0                 # pass 0 to brk (invalid request)
	mov rax, 12                # brk syscall number 12
	syscall                    # call brk with 0
	mov QWORD PTR [D_PTR], rax # set D_PTR to start of end of break memory
	mov rdi, rax               # mov current end of break into rax
	
	add rdi, 1024 * 8          # add request num bytes to end break
	mov rax, 12                # brk syscall number 12
	syscall                    # call brk with break end + request

	mov rbx, QWORD PTR [D_LEN] 
	mov rcx, QWORD PTR [D_PTR]
	call sumIt
	mov QWORD PTR [D_SUM], rax

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

	mov rdi, rax
	mov rax, 60
	syscall
	

