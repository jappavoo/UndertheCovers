<!-- #region -->
Under the Covers : The Secret Life of Software
=====================================

In this book we will look under the covers to learn exactly what software is and how it works. Our goal is to allow a reader to learn concepts and practical skills that will help them understand and participate in the digital world.   We will dissect how software and computers work so that the reader can understand the underlying ideas and mechanisms of computing technologies, revealing both beauty and ugliness. 

We will learn how hardware and software are broken down and organized. Learning the generic models that apply to most modern computers.   We will see how physical devices are turned into a blank canvas on which humans paint information as collections of binary bits.  Learning how different types of data are represented and how programs themselves are represented.  We will build our way to understanding how layers of software are fitted together to allow more complex information and ideas, not natively supported by the hardware, to be represented and worked with. 
Understanding this process will reveal to us how the layers make it simpler and simpler for humans to program computers and the limits and overheads that comes along with the layering.    

While this is not explicitly a programming course, as part of our journey we will be learning practical skills:
- Learning the tools and ideas that make up the UNIX program development environment, as this is the defacto environment for industrial and academic computing and for looking under the covers.
- Learning how to read, write and understand software as assembly code as we learn how computers operate and how data and programs are represented at the binary level.  
- Learning how to read, write and understand 'C' code from an assembly language perspective.  Experiencing how higher level data structures and programming ideas, expressed in a human friendly way, are translated into assembly code while maintaining direct control of the hardware. 

A core goal of this material is to help a reader learn to use the tools that enable developing and controlling all fundamental aspects of a computer.    This includes being productive in the UNIX command line environment, understanding the core concepts of files, terminal interaction, processes, and UNIX credentials.  This coverage will include the use of editors, the make utility, and GIT as a repository control system.  Using knowledge of  these tools we will then explore how to use assemblers and compilers to convert human readable code into machine executable software. Throughout this process we will learn how to use a machine level debugger, such as gdb, both to explore and control how the software and hardware work from a memory-oriented perspective and how to map the human symbolic version of code onto the memory.  

The material is broken down into three parts: 
1. The Unix Software development environment
2. The Belly of the Beast: The von Neumann Architecture and assembly programming
3. Into the Light: C Programming

This textbook was developed for Boston University's College of Arts and Sciences Computer Science CS210 Computer Systems class. A more detailed list of topics that the book covers can be found in [CS210 Learning outcomes](BUCS210_intro.md).


## About

This ["book"](https://jappavoo.github.io/UndertheCovers/textbook/intro_tb.html) has associated with it [Lecture Notes](https://jappavoo.github.io/UndertheCovers/lecturenotes/intro_ln.html) and a [Lab Manual](https://jappavoo.github.io/UndertheCovers/labmanual).   The book, lecture notes and lab manual websites have been generated using [Jupyter-book](https://jupyterbook.org/intro.html).  The source material is maintained in the following git repository: https://github.com/jappavoo/UndertheCovers.  


Jupyter-book is a tool for converting  and exploiting [Jupyter Notebooks](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/what_is_jupyter.html) as the main document type for authoring content.  Jupyter Notebooks are an ipython document type who's file names end in `.ipynb`. Jupyter Notebooks allow an author to design and include both static text and interactive content in a document that can be viewed and worked using a [Jupyter user interface app](https://jupyter.org) such as Juypter Lab or the older Jupyter Notebook Classic Interface.

Jupyter-books converts each of the Jupyter Notebooks that make up either the textbook, lecture notes, or lab manual into a website composed of web-pages (html) that can be viewed like any other website.    The websites are static version of the content that the jupyter-book tool created from the underlying source notebooks.    The notebooks however are interactive documents and may include code and content that is best used directly in the form of the notebook.    This is particularly true for the lecture notes and lab manual content.  The lecture notes are designed to used within the classic juypter user interface with the  RISE Presentation extension (https://rise.readthedocs.io/en/stable/).  

To get access to the source notebooks so that you can use them interactively or for you to help author new content you need to get a copy of the [repository](https://github.com/jappavoo/UndertheCovers).    This can be done by manually setting up your own environment and cloning the repository or by using short cuts built into the static websites.  For the interactive pages you will see a rocket icon which if you hover over will reveal a JupyterHub button.  Clicking on this button will redirect you to a JupyterHub service that will start a private Jupyter server for you that will contain a clone of the source material.  See the attached video for more information.   If at any point we want to quickly see the source material you can use the git icon at the top of the web pages -- hovering over it will reveal a repository button that will take you the the git repository. 



   
   



<!-- #endregion -->
