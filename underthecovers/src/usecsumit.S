	.intel_syntax noprefix

	.data
SUM:
	.quad 0			;
	
	.section .text
	.global _start
	
_start:
	mov rdi, 0                     # rdi = fd = 0 = stdin
	mov rsi, OFFSET XARRAY         # rsi = address of buf = XARRAY
	mov rdx, 10*8                  # rdx = count = 8*10
	mov rax, 0                     # rax = 0 = read syscall num
	syscall                        # rax = read(0, ARRAY_PTR, MAX_LEN_BYTES)
                                       # FIXME : check for errors

	call sumit

	mov rdi, 1                     # rdi = fd = 1 = stdout
	mov rsi, OFFSET SUM            # rsi = address of sum
	mov rdx, 8                     # rdx = 8 lenght of sum in bytes
	mov rax, 1                     # rax = 1 write syscall num
        syscall

	mov rdi, 0                     # rdi = 0 = exit return value
	mov rax, 60                    # rax = 60 = exit syscall num
	syscall                        # exit(0)
