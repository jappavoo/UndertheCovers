	.intel_syntax noprefix
        # TREE NODE STRUCTURE IN MEMORY
	# A NODE is composed of 3, 8 byte values
	# First 8 bytes is an 8 byte signed value
	# Second 8 bytes is a pointer to the left child (another node)
	# Third 8 bytes is a pointer to the right child (another node)
	# a 0 value pointer means there are no nodes in that direction

	#  node.VAL
	#  node.LEFT
	#  node.RIGHT
	.equ VAL, 0       # tree node value 8 bytes (offset 0)
	.equ LEFT, 8      # pointer to left child 8 bytes (offset 8)
	.equ RIGHT, 16    # pointer to right child 8 bytes (offset 16)

	.section .text
	.global _start
_start:
	mov rax, QWORD PTR [ROOT]  # pointer to root node is in a memory location ROOT
loop:
	mov rbx, QWORD PTR [rax + LEFT]  # rbx = left child location
	mov rdx, QWORD PTR [rax + RIGHT] # rdx = right child location
	cmp QWORD PTR [rax + VAL], 0     # compare node's value to zero
	cmovl  rax, rbx                  # if val < 0 then rax = rbx -- left child
	cmovge rax, rdx                  # if val >= 0 then rax = rdx -- right child
	cmp rax, 0                       # if location of next node is 0 we are done
	jne loop                         # otherwise keep walking the tree

	int3

	.section .data
ROOT:
	.quad N0               # ROOT global variable stores address of
	# N0 node &N0 (eg points to N0)

	# A BUNCH OF NODES CONNECTED TO FORM A TREE LIKE STRUCTURE
N0:
	.quad 8                # N0.VAL   = 8
	.quad N1               # N0.LEFT  = &N1
	.quad N2               # N0.RIGHT = &N2

N1:
	.quad 0                # N1.VAL   = 0
	.quad N3               # N1.LEFT  = &N3
	.quad N4               # N1.RIGHT = &N4

N2:
	.quad -5               # N2.VAL   = -5
	.quad N5               # N2.LEFT  = &N5
	.quad N6               # N2.RIGHT = &N6

N3:
	.quad 6                # N3.VAL   = 6
	.quad 0                # N3.LEFT  = 0
	.quad 0                # N3.RIGHT = 0

N4:
	.quad 90               # N4.VAL   = 90
	.quad N7               # N4.LEFT  = &N7
	.quad 0                # N4.RIGHT = 0

N5:
	.quad -3               # N5.VAL   = -3
	.quad N7               # N5.LEFT  = &N7
	.quad 0                # N5.RIGHT = 0

N6:
	.quad 567              # N6.VAL   = 567
	.quad 0                # N6.LEFT  = 0
	.quad 0                # N6.RIGHT = 0

N7:
	.quad -8               # N7.VAL   = -8
	.quad 0                # N7.LEFT  = 0
	.quad 0                # N7.RIGHT = 0
	
