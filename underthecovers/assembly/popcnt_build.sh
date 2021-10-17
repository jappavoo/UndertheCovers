#To assemble and link the code we will use the following command:
gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=popcnt.map popcnt.S -o popcnt > popcnt.lst
# We can automate this using a makefile so that all we would need to do is:
make popcnt
