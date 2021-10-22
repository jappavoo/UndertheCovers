gcc --static -g -nostartfiles -nostdlib -Wl,--build-id=none -Wa,-alh -Xlinker -Map=add.map add.S -o add > add.lst
# create makefile that automates
make add
