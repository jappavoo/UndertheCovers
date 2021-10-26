gdb -tui add
# Now we want use gdb command to poke around popcnt
# To setup the assembly syntax to intel: 
set disassembly-flavor intel
# Configure a layout that is more friendly to assembly code:
tui new-layout mylayout regs 3 {src 1 asm 1} 2 cmd 0 status 0
winh regs 4
# Switch to the new layout: 
layout mylayout
# Set a breakpoint at the start symbol so exection will stop their: 
break _start
# Start the program running:
run
