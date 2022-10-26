	.intel_syntax noprefix

	.text
	.global _start
_start:
	call sharedfunc2
hang:	jmp hang
