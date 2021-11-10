	.intel_syntax noprefix

	.equ VAL, 0    
	.equ LEFT, 8   
	.equ RIGHT, 16
	
	.section .text
	.global _start
_start:
	mov rax, QWORD PTR [ROOT] 
loop:
	mov rbx, QWORD PTR [rax + LEFT]  
	mov rdx, QWORD PTR [rax + RIGHT] 
	cmp QWORD PTR [rax + VAL], 0     
	cmovl  rax, rbx                  
	cmovge rax, rdx                  
	cmp rax, 0                       
	jne loop                         
	int3

	.section .data
ROOT:
	.quad N0
N0:
	.quad 8    # N0.VAL   = 8
	.quad N1   # N0.LEFT  = &N1
	.quad N2   # N0.RIGHT = &N2
N1:
	.quad 0    # N1.VAL   = 0
	.quad N3   # N1.LEFT  = &N3
	.quad N4   # N1.RIGHT = &N4
N2:
	.quad -5   # N2.VAL   = -5
	.quad N5   # N2.LEFT  = &N5
	.quad N6   # N2.RIGHT = &N6
N3:
	.quad 6    # N3.VAL   = 6
	.quad 0    # N3.LEFT  = 0
	.quad 0    # N3.RIGHT = 0
N4:
	.quad 90   # N4.VAL   = 90
	.quad N7   # N4.LEFT  = &N7
	.quad 0    # N4.RIGHT = 0
N5:
	.quad -3   # N5.VAL   = -3
	.quad N7   # N5.LEFT  = &N7
	.quad 0    # N5.RIGHT = 0
N6:
	.quad 567  # N6.VAL   = 567
	.quad 0    # N6.LEFT  = 0
	.quad 0    # N6.RIGHT = 0
N7:
	.quad -8   # N7.VAL   = -8
	.quad 0    # N7.LEFT  = 0
	.quad 0    # N7.RIGHT = 0
	
