	# Some example code to illustrate how the x86-64 stack
	# behaves when we push data to it.  To full understand this
	# code it is best to use gdb and single instruction step it
	# (si) while you inspect the rsp and the data at the memory
	# it points to
	# Here is how to build and run it
	# as -g stack.s -o stack.o
	# ld -g stack.o -o stack
	# runnig the resulting binary in bash
	# $ ./stack
	# hello$ echo $?
	# now use gdb to explore it eg. gdb stack
	
	.intel_syntax noprefix

	.section .data
x:
	.quad 0xdeadbeeffeedface
	
	.section .text
	.global _start
_start:
	movabs rax, 0xcafebaddecaff00d
	# push memory operand
	# 8 byte memory operand push
	push qword ptr [x]   # rsp=rsp-8  (total: 8)
	# no encoding for 4 byte (32 bit) push in 64 bit mode
	# push dword ptr [x]
	# 2 byte memory operand push
	push word ptr [x]    # rsp=rsp-2 (total: 10)
	# no support for byte sized pushes in any mode
	# push byte ptr [x]

	# push register operand
	# 8 byte register push
	push rax            # rsp=rsp-8 (total: 18)
	# no encoding for 4 byte (32 bit) push in 64 bit mode
	# push eax
	# 2 byte register push
	push ax             # rsp=rsp-2 (total: 20)
	# no support for byte sized pushes in any mode
        # push al

	# push immediate (immediate is always sign extended to 8 bytes (64 bits) in 64 bit  mode)
	# however smallest encoding of 1, 2, or 4 bytes is used as needed to code immediate value
	push 0x01          # rsp=rsp-8 (total: 28)
	push 0x0101        # rsp=rsp-8 (total: 36)
	push 0x01010101    # rsp=rsp-8 (total: 44)

	# lets clean up before we do more
	add rsp, 44        # rsp=rsp+44 (total: 0)
	
	sub rsp, 80        # rsp=rsp-80 (total: 80)
	mov BYTE PTR [rsp], 'h'
	mov BYTE PTR [rsp+1], 'e'
	mov BYTE PTR [rsp+2], 'l'
	mov BYTE PTR [rsp+3], 'l'
	mov BYTE PTR [rsp+4], 'o'
        mov BYTE PTR [rsp+5], 0  # null terminate for good measure
	
	# use OS write system call to send ascii on stack to
	# standard out of this process aka write(1, rsp, 5)
	# to correctly call the write system call we must setup the following four registers
	#  rax must hold the system call number for the linux write system call
	#  rdi must hold the file descriptor of where we want the write to go
	#  rsi must hold the address (ptr) to the data we want to write
	#  rdx must hold the length in bytes of the data to write
	#  rax will hold the return value after the system call is done
	mov rax, 1   # rax = syscall number of write which is 1
	mov rdi, 1   # rdi = file descriptor number of standard out which is 1
	mov rsi, rsp # rsi = rsp (address of where our data is)
	mov rdx, 5   # rdx = lenght of data (note we do NOT send terminating null)
	syscall 

	add rsp, 80  # cleanup after ourselves aka pop 80

	# all done lets exit properly returning the value from write as our return code
	# linux exit system call number is 60 and takes one argument the exit code
	# for the process aka exit(number)
	# rax must hold system call number
	# rdi must hold exit code (aka number)
	mov rdi, rax
	mov rax, 60
	syscall

	
	
