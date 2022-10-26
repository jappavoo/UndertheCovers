	.intel_syntax noprefix

	.text
	.global sharedfunc1
sharedfunc1:
	inc rax
	ret
	
	.global sharedfunc2
sharedfunc2:
	dec rax
	ret
	
