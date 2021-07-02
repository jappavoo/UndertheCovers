Under the Covers : The Secret Life of Software
==============================================
![logo](underthecovers/logo.jpg)

This repository is the source material for the textbook (TB), lecture notes (LN), and lab manual (LM) for BU CAS CS210.  

The current published master versions can be found here:
1) [Text Book](https://jappavoo.github.io/UndertheCovers/textbook)
2) [Lecture Notes](https://jappavoo.github.io/UndertheCovers/lecturenotes)
3) [Lab Manual](https://jappavoo.github.io/UndertheCovers/labmanual)

This material is composed largely of jupyter notebooks and supporting files. It is organized and built into the TB, LN, and LM  using jupyter-books (see credits). 

Makefiles are used to automate the the workflow both for building and publishing.  

## Companion Container

There is a companion container available here:

https://github.com/jappavoo/bu-cs-book-dev


Once built the container has:
- all the software required to follow along and do the examples and exercises 
- all the software required to author, build and publish the books

The easiest way for a reader of these books to use the container is to  via the launch button on one of the pages.  This will launch the container on the jupyterhub service specified, clone the books contents into the container and start a jupyter server on the container for you to interact with.  The launch button also automatically redirects the browser to open a connection to the newly launched jupyter server.  

The container can however also be used manually by cloning its [repository](https://github.com/jappavoo/bu-cs-book-dev) and using its [Makefile](https://github.com/jappavoo/bu-cs-book-dev/blob/main/Makefile).  

## Developing and Contributing to  the books

### Editing content

The easiest way to work on the content of the book is via the companion container.  Launching the container will start a jupyter server.  If doing this locally, via the container repository's [Makefile](https://github.com/jappavoo/bu-cs-book-dev/blob/main/Makefile), the startup will provide a local url to connect to the container.  Starting in this manner also mounts your home directory of your local machine.  You can then navigate to a checkout of this repo and freely edit the content.  

### The Makefile 

The top-level [Makefile](Makefile) of this repository automates the tasks of building and publishing the content as html versions. 

Running `make` on its own or running `make help` will list the supported targets and briefly state what each does.

### Building the html versions

The Makefile has build targets to run the 'juypter-book' on the source files.  The build targets are:
- `make build` to build all the books
- `make build-tb` to build just the text book
- `make build-ln` to build just the lecture notes
- `make build-lm` to build just the lab manual

The build targets will create self-contained html versions of the books in the following subdirectories respectively:
- `textbook/_build/html`
- `lecturenotes/_build/html`
- `labmanual/_build/html`

To view it locally simply open the `index.html` file of the appropriate subdirectory.  You can use these directories to host the book manually on an arbitrary web server.  

### Automatic Hosting of the book

The html versions of the book can be automatically hosted via the [GitHub Pages](https://pages.github.com) service.  The Makefile's pub targets uses [ghp-import](https://github.com/c-w/ghp-import) tool to push the built content to the `gh-pages` branch of the repo.  The targets are:
- `make pub` to publish all the books
- `make pub-tb` to publish just the text book
- `make pub-ln` to publish just the lecture notes
- `make pub-lm` to publish just the lab manual

> Note if you are using a fork or independent copy of the repo the urls to the book locations will be different than the hardcoded ones at the top of this page as you are working on a different repo. 

More information on this hosting process can be found [here](https://jupyterbook.org/publish/gh-pages.html#manually-host-your-book-with-github-pages).


## Contributors

We welcome and recognize all contributions. You can see a list of current contributors in the [contributors tab](https://github.com/jappavoo/underthecovers/graphs/contributors).

## Credits

This project is created using the excellent open source [Jupyter Book project](https://jupyterbook.org/) and the [executablebooks/cookiecutter-jupyter-book template](https://github.com/executablebooks/cookiecutter-jupyter-book).
