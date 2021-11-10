	.intel_syntax noprefix
	# EXAMPLE ASSEMBLY CODE OF SOMETHING A LITTE MORE REALISTIC
        #   NOTE THIS IS BY NO MEANS MEANT TO BE THE MOST EFFICIENT
	#   OR ADVANCE WAY OF WRITING THIS CODE.  RATHER IT IS MEANT
	#   TO BE SIMPLE AND HOPEFULLY CORRECT
	
	# Player Structure
	#   id   : 8 byte id
	#   name : 80 byte ascii encoded name
	#   score: 4  byte score
	#   age  : 1  byte age
	#  total number of bytes for a player is 8 + 80 + 4 + 1 = 93
        .equ PLAYER_STRUCT_SIZE, 93   # size of player structure in bytes
	
	# offsets to start of each field
	.equ PLAYER_ID_OFFSET,0       # offset 8 byte unsigned id 
	.equ PLAYER_NAME_OFFSET,8     # offset 80 byte ascii name
	.equ PLAYER_SCORE_OFFSET, 88  # offset 4 byte score
	.equ PLAYER_AGE_OFFSET, 92    # offset 1 Byte unsigned age

	
	#  Routine to search an array of player structures
	#  to find first player who's name contains a 'B'
	#  We assume the location of the array is passed in %rdi
	#  and %rsi contains the length of the array.
	#  Each element of the array is a player structure
	#  When done the index of the first player found that
	#  has a B in its name shoud be left in %rax.
	#  if not found then %rax should contain -1

	# INPUTS
	# rdi -> array : address of player array
	# rsi -> len   : length of player array
	# OUTPUTS
	# rax -> i : index of player with B in name or -1 if none found

	# REGISTER USED AS TEMPORARIES
	# rdx -> player_ptr : pointer to the ith player structure
	# r8  -> j        : temporary integer used to seach name
	# r9b -> tmpc     : temporary byte used to hold the jth charater of the current
        #                 : player's name
	.global find_player
find_player:
	xor rax, rax                 #  i = 0 

	jmp find_player_loop_condition     
find_player_loop:
	mov  rdx, rax                  # player_ptr = i    
	imul rdx, PLAYER_STRUCT_SIZE   # player_ptr = i * size of player stucture
        add  rdx, rdi                  # player_ptr += array starting address
	                               # rdx now holds the address of the ith player
	xor  r8, r8                    # j=0
name_search_loop:
	# tmpc = player->name[j]
	mov  r9b, BYTE PTR [rdx +  r8 + PLAYER_NAME_OFFSET]
	
        cmp r9b, 'B'                 # compare tmpc to 'B'
	je  find_player_done         # found a 'B' in the ith player name
	cmp r9b, 0                   # is the current character 0 if so end of name
        je  name_search_loop_end     # done searching this player's name exit name loop
	inc r8                     # j++
	jmp name_search_loop          # goto top of name search loop to examine next byte in name 
name_search_loop_end:
	
	inc rax                     # i++
find_player_loop_condition:	
	cmp rax,  rsi                # if i < len
	jl find_player_loop

find_player_notfound:
	mov rax, -1
	
find_player_done:	
	ret
