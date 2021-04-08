.PHONEY: all book pub

all: book pub

book:
	jupyter-book build underthecovers

pub:
	ghp-import -n -p -f underthecovers/_build/html
	echo "Published: https://jappavoo.github.io/UndertheCovers"

