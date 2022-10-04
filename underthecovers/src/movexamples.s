	# Example code that illustrates various ways of
	# working with data in memory.
	# 1) Assemble this code eg. as -g mov.s -o mov.o
	# 2) Link into an executable eg. ld -g mov.o -o mov
	#
	# I suggest you then use gdb to single step the instructions --
	# executing the instructions one by one. But before you go on
	# to then next instruction do the following
	#   1) display the destination register
	#   2) examine the value in memory you think it will be loaded with
	#   3) write down on a paper your guess
	#   4) step the instruction
	#   5) display the destination register and see if you were right
	#      if not try and figure out why not

	.intel_syntax noprefix

	# Quick discussion about sections and organizing our memory into
        # data and text portions
	
	# Sections let us seperate out our programs memory into
	# distinct non-overlaping areas.  The two sections
	# we will use are .text and .data
	#
	# .text is for opcodes     (bytes to be executed)
	# .data is for data values (bytes to be read and written by our program
	#
	# We switch sections with the .section directive
	# All bytes for a section will be grouped together by the linker and
	# placed in a single contingous area of memory when a process is created
	#
	# Every assembly file can add bytes to either section
	# You can switch sections at any point in your assembly files
	
	# Switch current section to the data section
	.section .data
	
	# set a label MYBYTES to the begin of the following bytes
MYBYTES:    
	.quad 0xdeadbeeffeedface   # reserve 8 bytes initialized to
	                           # the value indicated in hex

	# Switch current section to the text section
	.section .text
	
	.global _start                # expose this symbol to the linker
_start:
	# examples of loading registers of different sizes from
	# data at a label
	xor r8, r8                    # r8 = 0  (clear r8)
	mov r8,  QWORD PTR [MYBYTES]  # load  r8 with 8 byte vector at MYBYTES
	mov r8d, DWORD PTR [MYBYTES]  # load r8d with 4 byte vector at MYBYTES
	mov r8w, WORD PTR [MYBYTES]   # load r8w with 2 byte vector at MYBYTES
	mov r8b, BYTE PTR [MYBYTES]   # load r8b with 1 byte vector at MYBYTES

	# example of loading registers of differrent sizes using another register
	# that we first load with the address of the data
	xor rax, rax		      # rax = 0 (clear rax) 
	mov rax, OFFSET MYBYTES       # rax = &MYBYTES (set rax to the address)

	mov rbx, QWORD PTR [rax]
	mov ecx, DWORD PTR [rax]
	mov dx,  WORD  PTR [rax]
	mov sil, BYTE  PTR [rax]

	# example of using another register to act as a index
	# Effective Address = rax + r9 * 1
	# where the current value in rax is added to the value in r9 times 1
	# 1 is called the scale when one we can skip it but show it to be
	# explicit. Other valid values for scale are 2, 4, and 8
	xor r9,r9
	mov r10b, BYTE PTR [rax + r9*1]    
	inc r9
	mov r11b, BYTE PTR [rax + r9*1]    
	inc r9
	mov r12b, BYTE PTR [rax + r9*1]	
	inc r9
	mov r13b, BYTE PTR [rax + r9*1]

	# same as above but using a label
	xor r9,r9
	mov r10b, BYTE PTR [MYBYTES + r9*1]    
	inc r9
	mov r11b, BYTE PTR [MYBYTES + r9*1]    
	inc r9
	mov r12b, BYTE PTR [MYBYTES + r9*1]	
	inc r9
	mov r13b, BYTE PTR [MYBYTES + r9*1]
	
	# example of using scale = 2
	xor r9, r9
	mov r14w, WORD PTR [rax + r9 * 2]  
	inc r9
	mov r15w, WORD PTR [rax + r9 * 2]

	# example of using a base reg, index, and displacement
	xor r9, r9
	mov r14w, WORD PTR [rax + r9 * 2 + 1]
	inc r9
	mov r15w, WORD PTR [rax + r9 * 2 + 1]
	
	# following calls the UNIX OS exit system call
	# so that we terminate nicely
	
	.equ EXIT_SYSCALL_NR,60
	mov rax, EXIT_SYSCALL_NR
	mov rdi, 0
	syscall
	
	
