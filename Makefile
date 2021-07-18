.PHONEY: help build-bk pub-bk clean-bk build-ln pub-ln clean-ln build-lm pub-lm clean-lm build pub clean

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build all materials 
build: build-bk

pub: ## publish all materials to github pages
pub: pub-bk

clean: ## cleanup/remove all build files
clean: clean-bk

build-bk: ## build only the textbook
	make --no-print-directory -f textbook.mk build

pub-bk: ## publish only the textbook to github pages 
	make --no-print-directory -f textbook.mk pub

clean-bk: ## cleanup/remove only textbook build files
	make --no-print-directory -f textbook.mk clean

build-ln: ## build only the lecture notes
	make --no-print-directory -f lecturenotes.mk build

pub-ln: ## publish only the lecture notes to github pages
	make --no-print-directory -f lecturenotes.mk pub

clean-ln: ## Cleanup/remove only lecture notes build files
	make --no-print-directory -f lecturenotes.mk clean

