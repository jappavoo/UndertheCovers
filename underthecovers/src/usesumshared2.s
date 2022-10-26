	.intel_syntax noprefix
	.section .data	

	
	.comm A_SUM, 8, 8
	.comm A_LEN, 8, 8
	# pointer to heap memory for our array
	.comm A_PTR, 8, 8
	# pointer to break 
	.comm brk_ptr, 8, 8
	
	.section .text
	.global _start 
_start:	
	# get current break pointer
	xor rdi, rdi                         # pass 0 to brk (invalid request)
	mov rax, 12                          # brk syscall number 12
	syscall                              # call brk with 0
	mov QWORD PTR [rip + A_PTR], rax     # set A_PTR to start of end of break memory
	mov rdi, rax                         # mov current end of break into rax
	
	add rdi, 4096 * 8                    # add request num bytes to end break
	mov rax, 12                          # brk syscall number 12
	syscall                              # call brk with break end + request
	mov QWORD PTR [rip + brk_ptr], rax   # save current break pointer incase
	                                     # want to add more memory later

	# os places number of command line arguments on 
	# the stack and a array of string pointers as well
        # lets use this to get the name of the file that has our data
	pop rax      # we now have the count of command line arguments in rax
	cmp rax, 2   # in unix first command line argument is name of executable so
	jne error

	pop rax      # we now have a pointer to the command name
	pop rax      # we now have a pointer to the first argument!

	mov rdi, rax                       # pass pointer to path string in rdi
	mov rsi, QWORD PTR [rip + A_PTR]             # pass pointer to data memory in rsi
	call sumReadData                   # call sumReadData
	mov QWORD PTR [rip + A_LEN], rax   # save length in A_LEN for good measure

	
	mov rbx, QWORD PTR [rip + A_LEN]   # pass length in rbx
	mov rcx, QWORD PTR [rip + A_PTR]   # pass pointer to data in rcx
	call sumIt                   # sumit!!!
	mov QWORD PTR [rip + A_SUM], rax   # save result in A_SUM

	call sumPrint

	# exit normally 
exit:
	mov rdi, 0		
	mov rax, 60
	syscall 

	# exit with error
error:
	mov rdi, 1
	mov rax, 60
	syscall

