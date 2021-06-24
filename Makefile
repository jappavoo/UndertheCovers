.PHONEY: all textbook_build textbookfixlinks textbookimages textbookpub textbookclean build pub clean

TB_DIR=${PWD}/textbook

all: build 

build: textbookfixlinks

clean: textbookclean

textbook_build:
	jupyter-book build --path-output ${TB_DIR} --config ${PWD}/underthecovers/tb_config.yml --toc ${PWD}/underthecovers/tb_toc.yml underthecovers

textbookimages: textbook_build
	-mkdir ${TB_DIR}/_build/html/images
	cp underthecovers/images/* ${TB_DIR}/_build/html/images

textbookfixlinks:  textbookimages
	./fixlinks.sh ${TB_DIR}/_build/html

textbookpub: textbookimages
	ghp-import -n -p -f ${TB_DIR}/_build/html
	echo "Published: https://jappavoo.github.io/UndertheCovers"

textbookclean: 
	${RM} -rf  ${TB_DIR}

