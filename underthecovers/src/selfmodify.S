	.intel_syntax noprefix
	
	.text
	.global _start
_start:
	mov r8, OFFSET array
	xor rdi, rdi
	mov al, 0xf3
	mov BYTE PTR [r8 + rdi], al
	inc rdi
	mov al, 0x48
	mov BYTE PTR [r8 + rdi], al
	inc rdi
	mov al, 0x0f
	mov BYTE PTR [r8 + rdi], al
	inc rdi
	mov al, 0xb8
	mov BYTE PTR [r8 + rdi], al
	inc rdi
	mov al, 0xd8
	mov BYTE PTR [r8 + rdi], al
	inc rdi
	mov al, 0xcc
	mov BYTE PTR [r8 + rdi], al
	jmp array

array:
	.fill 32, 1, 0xff
	
	

