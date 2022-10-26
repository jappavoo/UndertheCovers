	.intel_syntax noprefix

	.section .text

	# tell linker that sumIt symbol can be referenced in other files	
	.global sumIt	  

	# code to sum data in array who's address is in rcx
	# we assume we were started with call so return address on stack
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
sumIt:	                         # label that marks where this code begins
	xor  rax, rax            # rax -> sum : sum = 0
	push rdi                 # spill current value of rdi before we use it
	xor  rdi, rdi            # rdi -> i : i = 0
	
	# code to sum data in array who's address is in rcx
	# we assume we were started with call so return address on stack
	# we assume rbx has length  rbx -> len
	# and that we will leave final sum in rax
loop_start:                                 
	cmp  rbx, rdi                       # rbx - rdi
	jz   loop_done                      # if above is zero (they are equal) jump
	add  rax, QWORD PTR [rcx + rdi * 8] # add the i'th value to the sum
	inc  rdi                            # i=i+1
	jmp  loop_start                     # go back to the start of the loop
loop_done:
	pop  rdi                            # restore rdi back to its original value
	ret                                 # use return to pop value off the stack
	                                    # and jump to that location

	# send value in rax to standard out
	.global sumPrint
sumPrint:
	push rcx
	push rdi
	push rsi
	push rdx
	push rax

	mov rax, 1      # write syscall = 1
	mov rdi, 1      # fd = 1
	mov rsi, rsp    # rax was last thing we pushed on the stack
	mov rdx, 8      # rax value is 8 bytes
	syscall

	pop rax
	pop rdx
	pop rsi
	pop rdi
	pop rcx

	ret

	# BAD CODE NO ERROR CHECKING :-(
	# rdi points to string path of file
	# rsi pointer to where to store data
	# rax returns length
	.global sumReadData
sumReadData:
	push rcx
	push rdx
	push r8
	push rsi
	
	# open
	mov rax, 2              # open syscall number 2
	# rdi already has string of path
	mov rsi, 0x0            # O_RDONLY
	xor rdx, rdx            # 0 for the mode flags
	syscall

	mov r8, rax             # save fd in r8
	
	# calculate length
	# use lseek
	mov rdi, r8             # mov fd into rdi
	xor rsi, rsi            # offset = 0
	mov rdx, 2              # SEEK_END = 2
	mov rax, 8   
	syscall

	push rax                      # save length in bytes to top of stack

	# reset file postion to the beginning lseek(fd, 0, SEEK_SET)
	mov rdi, r8                   # fd = rdi = r8  
	xor rsi, rsi                  # offset = rsi = 0 
	xor rdx, rdx                  # whence = rdx = SEEK_SET = 0
	mov rax, 8                    # lseek syscall number is 8
	syscall
	
	# read data
	mov rdi, r8                   # fd = rdi = r8
	mov rsi, QWORD PTR [rsp+8]    # buf = rsi = pointer to data memory is
	                              # second last thing pushed on to the stack so is at rsp + 8
	mov rdx, QWORD PTR [rsp]      # len = rdx =length in bytes is top of stack
	xor rax, rax                  # read syscall number is 0
	syscall

	# calculate return value
	pop rax
	shr rax, 3        # divide by 8 to get number of quads

	# cleanup
	# restore register values from stack
	pop rsi
	pop r8
	pop rdx
	pop rcx

	ret
