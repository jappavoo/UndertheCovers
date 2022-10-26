	.intel_syntax  noprefix
	.section .rodata
filepath:
	.asciz "song.txt"
	
	.section .data
ptr:
	.quad 0
fd:
	.quad 0
	
	.section .text
	.global _start
	
_start:
	# open
	mov rax, 2
	mov rdi, OFFSET filepath
	mov rsi, 0x2            # O_RDWR
	xor rdx, rdx             # 0 for the mode flags
	syscall

	cmp rax, -1             # open returns -1 on errors
	je error
	mov QWORD PTR [fd], rax
	
	# mmap file associated with the fd opened above
	mov rax, 9              # mmap system call number
	mov rdi, 0              # NULL address let OS pick
	mov rsi, 100            # 100 bytes of the file
	mov rdx, 0x3            # PROT_READ | PROT_WRITE
	mov r10, 0x1            # MAP_SHARED
	mov r8, QWORD PTR [fd]
	mov r9, 0               # offset in file
	syscall

	cmp rax, -1            # check if mmap work (returns -1 on failure)
	je done        
	
	mov QWORD PTR [ptr], rax

	# capitalize all lower case 'a' that are in the data
	xor rbx,rbx                   # rbx=0
	# rax points to the data, rbx is index
loop:
	cmp BYTE PTR [rax + rbx], 'a   # check ith byte to see if it is an lower case a
	jne next                      
	mov BYTE PTR [rax + rbx], 'A   # it is so replace it with upper case A
next:
	inc rbx                        # increment index
	cmp rbx, 100                   # compare index to 100
	jl loop                        # less than the keep looping
	
	# write data of file to stdout 
	mov rax, 1                     # write system call number
	mov rdi, 1                     # fd = 1
	mov rsi, QWORD PTR [ptr]       # address of where data was mapped
	mov rdx, 100                   # 100 bytes
	syscall
	
	mov rdi, 0                     # success if we got here
	jmp done
	
error:
	mov rdi, -1
done:
	mov rax, 60
	syscall
