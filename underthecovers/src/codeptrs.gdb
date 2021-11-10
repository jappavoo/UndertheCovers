# gdb codeptrs < codeptrs.gdb
set disassembly-flavor intel
set pagination off
b _start
run
print /x  &myfunc1
print /x  &myfunc2
disass myfunc1
x/14bx &myfunc1
disass myfunc2
x/14bx &myfunc2
display /1xg &X
break * &after_call1
break * &after_call2
break * &after_call3
c
c
c
quit
