set pagination off
set disassembly-flavor intel
b _start
run
display /2i &array
c
x/2i &array