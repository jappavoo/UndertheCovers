	.intel_syntax noprefix
	.section .text

	.global _start
_start:
	mov rdi, OFFSET PLAYER_ARRAY
	mov rsi, (PLAYER_ARRAY_END - PLAYER_ARRAY)/93   #ugly magic number
	
	call find_player

	mov rdi, rax
	mov rax, 60
	syscall 

        .data
PLAYER_ARRAY:
	.quad   7            # id
	.string "The Doctor" # name
	.zero   80 - 11      # fill rest of name array with 0
	.int    42           # score 
	.byte   255          # age

	.quad   37           # id
	.string "Bugs Bunny" # name
	.zero   80 - 11      # fill rest of name array with 0
	.int    -4           # score 
	.byte   9            # age
PLAYER_ARRAY_END:	

