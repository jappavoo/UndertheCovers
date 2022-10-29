	# To use this assemble and link it:
	# as -g exploringASlayout1.s -o exploringASlayout1.o
        # ld -g exploringASlayout1.o -o exploringASlayout1
        # Then using two terminals:
	#   1. use the nm command on the binary to see what addresses the linker
	#      placed all the symbols at Eg.
	#        $ nm exploringASlayout1
	#        0000000000403000 D __bss_start
	#        0000000000403000 D _edata
	#        0000000000403000 D _end
	#        0000000000402000 d rwdata
	#        0000000000401000 T _start
        #      (if you like you can also run: "readelf -S <binary>" to 
	#       see more information about the sections in the binary)
	#   2. then run the binary -- its should stop on the read
	#      Eg.
	#      $ ./exploringASlayout1 
        #       
	#   3. in another terminal use ps and grep to find the process started from the binary
	#      Eg.
	#       $ ps auxgww | grep exploring
	#       jovyan      1697  0.0  0.0    168     4 pts/29   S+   13:41   0:00 ./exploringASlayout1
	#       jovyan      1699  0.0  0.0   6440   720 pts/30   S+   13:42   0:00 grep exploring
	#       $
	#      We see the process id (pid) is 1697
	#   4. using the process id you can now examine the file "/proc/<pid>/maps" to
	#      see the layout of the running processes address space
	#      Eg.
	#      $ cat /proc/1697/maps
	#      00400000-00401000 r--p 00000000 103:05 1189363                           /home/jovyan/exploringASlayout1
	#      00401000-00402000 r-xp 00001000 103:05 1189363                           /home/jovyan/exploringASlayout1
	#      00402000-00403000 rw-p 00002000 103:05 1189363                           /home/jovyan/exploringASlayout1
	#      7ffd13044000-7ffd13065000 rw-p 00000000 00:00 0                          [stack]
	#      7ffd13069000-7ffd1306d000 r--p 00000000 00:00 0                          [vvar]
	#      7ffd1306d000-7ffd1306f000 r-xp 00000000 00:00 0                          [vdso]
	#      ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
	#      $
	#     What we see is that there are three mappings to the binary file, a mapping for the stack and then some
	#     extra's used by the OS.
	#     5. you can now press enter in the terminal that the binary is running in
        #        this will cause the read to finish and the binary will then continue to execute

	# CODE to explore how we control the address space mappings	
	# The smallest size of an address space mapping is called the page size
	# on Linux the default is 4096 (4Kb). To make it easier to identify
	# the mappings we will fill each section we add to a full page (4Kb)
	# worth of bytes.
	# This version 2 adds read only data section
	# One page' of "text", one page of "data" and one pager of "readonly data"
	#  - text should get mapped to a region that is readable and executable (r-x)
	#  - data should get mapped to a region that is readable and writable (rw-)
	#  - rodata should get mapped to a region that is readable only       (r--)
	
	.intel_syntax noprefix        # assembler syntax to use <directive>
	.section .text                # linker section <directive>

	.global _start                # linker symbol type <directive> 
_start:
	# use a read system call to stop the program until user presses enter
	# so that we can examine things before and after the code runs
	mov rax, 0                 # read syscall = 0 -- read(fd, buf, len)
	mov rdi, 0                 # fd = rdi = 0 = stdin
	mov rsi, OFFSET rwdata     # buf = rsi = rwdata memory
	mov rdx, 1                 # len = rdx = 1 wait for one byte "enter"
	syscall
	
	mov rax, 60                # exit system call
	mov rdi, 0                 # exit status 0
	syscall

	# fill the text section up with zeros so that it is one page in size.	
	.org 4095                  # force the next byte to be at the end of the page (4095
	.byte 0x00                 # put a byte of zero here

	##### DATA SECTION : read and writable memory s
	.section .data
	.global rwdata
rwdata:	.fill 4096,1,0xff           # 4096 bytes each initialized with a value of 0xff

	##### READ ONLY DATA SECTION : read only memmory 
	.section .rodata
	.global rodata
rodata:
	.fill 4096,1,'a             # 4096 bytes each initialized with a value of ASCII lower case a
	                     
	# the following tells the linux kernel to set permissions the way we expect
	# rather than the defaults which map all sections as executable
	# When using a compiler it will add this for us
	.section	.note.GNU-stack,"",@progbits
