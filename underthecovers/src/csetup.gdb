set disassembly-flavor intel
tui new-layout mylayout regs 3 {src 1 asm 1} 2 cmd 1 status 0
layout mylayout
winh cmd 3
winh regs 12
winh src 12
focus cmd
