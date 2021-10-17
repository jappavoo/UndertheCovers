gcc --static -g -nostartfiles -nolibc -Wl,--build-id=none -Wa,-alh -Xlinker -Map=add.map add.S -o add > add.lst
# create makefile that automates
make add
