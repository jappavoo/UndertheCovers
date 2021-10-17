BK_DIR=${PWD}/${NAME}

.PHONEY: all jb build fixlinks images pub clean

all: build

jb:
	# -v verbose
	# -all re-build all pages not just changed pages
	# -W make warning treated as errors
	# -n nitpick generate warnings for all missing links
	# --keep-going despite -W don't stop delay errors till the end
	jupyter-book build -v --all -n --keep-going --path-output ${BK_DIR} --config ${PWD}/underthecovers/${SN}_config.yml --toc ${PWD}/underthecovers/${SN}_toc.yml underthecovers

images: jb
	-mkdir -p ${BK_DIR}/_build/html/images
	cp -r underthecovers/images/* ${BK_DIR}/_build/html/images

fixlinks: images
	./fixlinks.sh ${BK_DIR}/_build/html

build: fixlinks

pub:
	ghp-import -n -p --prefix=${NAME} -f ${BK_DIR}/_build/html
	@echo "Published to:"
	@./ghp-url.sh ${NAME}

clean: 
	${RM} -r  ${BK_DIR}
