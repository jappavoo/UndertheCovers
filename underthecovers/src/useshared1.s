	.intel_syntax noprefix

	.text
	.global _start
_start:
	call sharedfunc1
hang:	jmp hang
