	.intel_syntax noprefix
	.section .data

	.equ MAX_LEN_BYTES, 1024 * 8
	# Added space heap memory array
	.comm SUM,       8, 8
	.comm LEN,       8, 8
	.comm ARRAY_PTR, 8, 8

	.section .rodata
mystr:	
	.string "Hello World!!!\n"
	
	.section .text
	.global _start 
_start:
	# get current break pointer
	mov rdi, 0                     # pass 0 to brk (invalid request)
	mov rax, 12                    # brk syscall number 12
	syscall                        # call brk with 0
				       # FIXME : check for errors
	mov QWORD PTR [ARRAY_PTR], rax # set D_PTR to start of end of break memory
	mov rdi, rax                   # mov current end of break into rax
	
	add rdi, 1024 * 8              # add request num bytes to end break
	mov rax, 12                    # brk syscall number 12
	syscall                        # call brk with break end + request
                                       # FIXME : check for errors
	
	mov rdi, 0                     # rdi = fd = 0 = stdin
	mov rsi, QWORD PTR [ARRAY_PTR] # rsi = buf = ARRAY_PTR
	mov rdx, OFFSET MAX_LEN_BYTES  # rdx = count = MAX_LEN_BYTES
	mov rax, 0                     # rax = 0 = read syscall num
	syscall                        # rax = read(0, ARRAY_PTR, MAX_LEN_BYTES)
                                       # FIXME : check for errors
	              
	shr rax, 3                     # logical right shift by 3 to divide byte size by 8
	mov QWORD PTR [LEN], rax     
	
	
	mov rbx, QWORD PTR [LEN] 
	mov rcx, QWORD PTR [ARRAY_PTR]
	call sumIt
	mov QWORD PTR [SUM], rax

	# write sum value in binary to stdout
	# you can use od -l -Ad to convert output to ascii
	mov rdi, 1                    # rdi = fd = 1 = stdout
	mov rsi, OFFSET SUM           # rsi = address of SUM
	mov rdx, 8                    # rdx = 8 length of SUM in bytes
	mov rax, 1                    # rax = 1 write syscall num
	syscall                       # rax = write(fd, &SUM, 8)

	
	mov rdi, 0                    # rdi = 0 = exit value
	mov rax, 60                   # rax = exit syscall num
	syscall                       # exit(0)
	

