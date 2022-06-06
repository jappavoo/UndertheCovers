        /* from man syscall
                  Arch/ABI    Instruction           System  Ret  Ret  Error    Notes
	                                            call #  val  val2
	           arm64       svc #0                w8      x0   x1   -
	          Arch/ABI      arg1  arg2  arg3  arg4  arg5  arg6  arg7  Notes
	           arm64         x0    x1    x2    x3    x4    x5    -
	*/
	.section .data
str:
	.string "hello world\n"

	.section .text
	.global _start
_start:
	mov w8, 64     /* w8 <- 64 : write syscall number  */
	mov x0, 1      /* x0 <- 1  : fd = 1, stdout */
	adr x1, str    /* x1 <- pc - &str : x1 = &str pc relative encoded: adr is a pseudo op */
	mov x2, 12     /* x2 <- 12 : length of string */
	svc #0         /* arm system call instruction */

	mov w8, 93     /* w8 <- 93 : exit syscall number */
	mov x0, 42     /* x0 <- 42 : process exit code */
        svc #0
