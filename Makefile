.PHONEY: all book pub clean

all: book pub

book:
	jupyter-book build underthecovers

pub:
	ghp-import -n -p -f underthecovers/_build/html
	echo "Published: https://jappavoo.github.io/UndertheCovers"

clean: 
	${RM} -rf  underthecovers/_build

