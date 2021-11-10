set pagination off
set disassembly-flavor intel
x/1gx &ROOT
x/16xb 0x402008
x/8xh 0x402008
x/4xw 0x402008
x/2xg 0x402008

x/9i _start

b _start
run
display /x $rax
display /1dg $rax + 0
display /2gx $rax + 8

b loop
c
c
c
c
c



