DIR=kornia
REPO=https://github.com/kornia/kornia.git

.PHONEY: clean all

all: funcscount.txt torchfuncs.txt

funcs.txt: ${DIR}/CHANGELOG.md
	./findfuncs ${DIR} > $@

funcscount.txt: funcs.txt
	wc -l $< > $@

# add this after so that we can see incremental running of rules
torchfuncs.txt: funcs.txt
	grep 'torch' $< > $@

kornia/CHANGELOG.md:
	git clone ${REPO}

clean:
	-rm funcs.txt funcscount.txt torchfuncs.txt

distclean:
	-rm -rf ${DIR}
