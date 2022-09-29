	.intel_syntax noprefix
	
	.text
        
	.global _start 	
_start:
	popcnt rax, rbx   # same as  .byte 0xF3, 0x48, 0x0F, 0xB8, 0xD8  
