	.intel_syntax noprefix
	.data	
	.comm A_SUM, 8, 8
	.comm A_LEN, 8, 8
	.comm A, 8*1024, 8	
	.section .rodata
	
	.section .text
	.global _start
_start:
	# something new os places number of command line arguments on 
	# the stack and a array of string pointers as well
        # lets use this to get the name of the file that has our data
	pop rax      # we now have the count of command line arguments in rax
	cmp rax, 2   # in unix first command line argument is name of executable so
	jne error

	pop rax      # we now have a pointer to the command name
	pop rax      # we now have a pointer to the first argument!

	mov rdi, rax        # pass pointer to path string in rdi
	lea rsi, [rip + A]  # pass pointer to data memory in rsi
	call sumReadData    # call sumReadData
	mov QWORD PTR [rip + A_LEN], rax    # save length in A_LEN for good measure
	
	mov rbx, QWORD PTR [rip + A_LEN]    # pass length in rbx
	lea rcx, [rip + A]             # pass pointer to data in rcx
	call sumIt                    # sumit!!!
	mov QWORD PTR [rip + A_SUM], rax    # save result in A_SUM

	call sumPrint                 # call sumPrint with value in rax

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
	
