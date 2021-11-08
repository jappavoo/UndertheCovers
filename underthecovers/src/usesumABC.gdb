b _start
run
restore A.bin binary &A
set *((long long *)&A_LEN)=10
restore B.bin binary &B
set *((long long *)&B_LEN)=10
restore C.bin binary &C
set *((long long *)&C_LEN)=10

display /d { (long long)A_SUM, (long long)B_SUM, (long long)C_SUM }

