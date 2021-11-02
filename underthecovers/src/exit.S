	# Pull in a file that contains all the OS system call numbers
	# for this to work we must preprocess this file via gcc -E before
	# we can assemble it with as so that the contents of the header file
	# will be included 
	
#include <asm/unistd_64.h>

	# See discussion bellow to understand what is in this file
	
	.intel_syntax noprefix   # set assembly language format to intel

	# Define some constants so that we don't have magic numbers
	# in our code.  We use the .equ (equal) assembly directive
	# "This directive sets the value of symbol to expression."
	# (https:#sourceware.org/binutils/docs/as/Equ.html#Equ)
	# FORMAT:	
	# .equ <SYMBOL>, <EXPRESSION>
	
	.equ UNIX_SUCCESS_VALUE, 0      
	.equ LINUX_SYSCALL_EXIT, __NR_exit

	.text                    # Place the following in the area that
	                         # instruction should be encoded and stored
	                         # for historical reasons it is called text
	.global _start
_start:                          # The linker knows to mark the _start address
                              	 # as location where execution should begin.
	                         # The OS will be sure to setup the CPU so that the
	                         # program counter is initialized with this address

	# To voluntarily hand control of the cpu back to the Operating system so it can
	# do somthing for us we use a special instruction
	#  -- on x86_64 this instruction is syscall (man syscall - table 1)
	#
	# Operating systems provide many functions that a program can call to
	# get things done.  eg.  open a stream, read or write bytes to or from a stream
	# or simply terminate and exit our program.
	#
	# Each call is identifed by a number we call a system call number.
	# On LINUX it expects us to load rax register with the system call number
	# prior to executing the syscall.  Once control is handed over to the OS
	# It will then look the number up and invoke the approriate function inside itself.
	# Other registers can be used to pass parmeters to the particular OS system call function
	# that we want to invoke.  The following is the conventions on X86_64 Linux
	# 
	#       Arch/ABI      arg1  arg2  arg3  arg4  arg5  arg6  arg7 
        # ────────────────────────────────────────────────────────────
        #       x86-64        rdi   rsi   rdx   r10   r8    r9    -
	# (see man syscall -- table 2)
	# The list of all Linux system call numbers can be found in a file so that programers
	# can know what number to use to invoke a particular call
	# On our installation of linux you can find it here
	#  /usr/include/x86_64-linux-gnu/asm/unistd_64.h
	# For an explanation of all the systems calls see man syscalls (note the s)
	# -- When we switch to understanding C we it will be easier to understand
	#    the above manual pages
	#
	# On LINUX 
	#   One of these calls is the EXIT system call that tells OS our program is done 
	#   (see man 2 exit)
	
	mov     rax, LINUX_SYSCALL_EXIT        # load rax with the Linux system call number for
	                                       # exit
	
	mov     rdi, UNIX_SUCCESS_VALUE        # load rdi with the exit status value we want
	                                       # to pass back to the program that launched us
	                                       # eg. the shell in which we ran our program from
	
	syscall                                # use the syscall instruction to hand control over
	                                       # to the OS.  Note since we will be terminated
	                                       # this instruction will be our last and nothing else
	                                       # need follow it
	
