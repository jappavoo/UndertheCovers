	.intel_syntax noprefix
	.data
c:	.byte 0xff
	
	.text
	.global main
main:
	int3
	
