b _start
run
display /1gx &D_PTR
x/10gd (void *)D_PTR
si
si
si
si
x/10gd (void *)D_PTR
si
si
si
si
x/10gd (void *)D_PTR
restore 100.bin binary <addr>
x/10gd (void *)D_PTR
set *((long long *)&D_LEN)=100
disass
break *addr
c
si
display /1gd D_SUM


