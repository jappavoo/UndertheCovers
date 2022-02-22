	.intel_syntax noprefix        # syntax directive
	.text                         # linker section <directive>

	.global _start                # export symbol _start to linker
_start:                           # start symbol
	.fill 256, 1, 0x00            # https://sourceware.org/binutils/docs/as/Fill.html
