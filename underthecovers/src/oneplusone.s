	.intel_syntax noprefix        

	.text                         
	                              	                         
	.global _start     
_start:                    
	mov al, 1        # transfer 1 into al
	add al, 1        # add 1 to the value in al
	nop              # do nothing -- requires only one byte to encode
	mov bl, al       # transfer value in al to bl
	
