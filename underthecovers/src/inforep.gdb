file empty256
break _start
run
help x
set $al = 'h'
p /x $al
p /t $al
p /u $al
p /d $al
p /c $al
set $al = 0xff
p /x $al
p /t $al
p /u $al
p /d $al
set {unsigned char}(&_start) = 'h'
set {unsigned char}(&_start+1) = 'e'
set {unsigned char}(&_start+2) = 'l'
set {unsigned char}(&_start+3) = 'l'
set {unsigned char}(&_start+4) = 'o'
set {unsigned char}(&_start+5) = 0x00
x /s &_start
kill
quit


