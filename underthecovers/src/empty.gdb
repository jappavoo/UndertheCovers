set disassembly-flavor intel
file empty
p /x &_start
b _start
run
info proc
info registers
p /x $rax
p /t $rax
p /d $rax
p /x $rip
x/8xb 0x401000
x/2i &_start
set {unsigned char}&_start = 0xF3
x/5xb &_start
x/1i &_start
set {unsigned char}(&_start+1) = 0x48
x/5xb &_start
x/1i &_start
set {unsigned char}(&_start+2) = 0x0F
x/5xb &_start
x/1i &_start
set {unsigned char}(&_start+3) = 0xB8
x/5xb &_start
x/1i &_start
set {unsigned char}(&_start+4) = 0xD8
x/5xb &_start
x/1i &_start
x/5tb &_start
x/5db &_start
x/5ub &_start
p/x {$rax, $rbx}
delete
stepi
p/x {$rax, $rbx}
set $rax = 0b1011
p/x {$rax, $rbx}
p /x $pc
set $pc = &_start
stepi
p/x {$rax, $rbx}
