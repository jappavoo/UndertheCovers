## Dockerfile for constructing the base Open Education Effort (OPE)
## container.  This container contains everything required for authoring OPE courses
## Well is should anyway ;-)

ARG BASE_REG
ARG BASE_IMAGE
ARG BASE_TAG
FROM ${BASE_REG}${BASE_IMAGE}${BASE_TAG}

# Add RUN statements to install packages as the $NB_USER defined in the base images.

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root

RUN apt-get -y update --fix-missing && \
    apt-get -y install build-essential \
               texinfo \
	       libncurses-dev \
	       vim \
	       ssh \
	       emacs-nox \
	       cc65 \
	       bsdmainutils \
	       file \
	       man-db \
	       manpages-posix \
	       manpages-dev \
	       manpages-posix-dev \
	       findutils \
	       less \
	       bc \
	       valgrind \
	       libasan5 \
	       libubsan1 \
	       xterm \
	       moria \
	       acl \
	       cmake \
	       zip \
	       ascii2binary \
	       strace \
               bison \
	       flex \
	       libssl-dev \
	       libelf-dev \
	       nasm \
	       qemu-system-aarch64 \
	       socat \
	       rlwrap

RUN dpkg --add-architecture i386 && apt-get -y update && apt-get install -y lib32gcc-9-dev libedit-dev:i386

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
#RUN cd /tmp && wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.gz && tar -zxf gdb-10.2.tar.gz && cd gdb-10.2 && ./configure --prefix /usr/local --enable-tui=yes && make -j 4 && make install
#RUN cd /tmp && rm -rf gdb-10.2 && rm gdb-10.2.tar.gz

COPY aarch64vm /home/aarch64vm

USER root
RUN chown -R jovyan /home/aarch64vm
RUN chgrp -R root /home/aarch64vm && chmod -R g+rX /home/aarch64vm && chmod g+w /home/aarch64vm && chmod g+w /home/aarch64vm/*

# turned off for the moment to minimize size
# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
#RUN yes | unminimize || true

# jupyter-stack contains logic to run custom start hook scripts from
# two locations -- /usr/local/bin/start-notebook.d and
#                 /usr/local/bin/before-notebook.d
# and scripts in these directoreis are run automatically
# an opportunity to set things up based on dynamic facts such as user name
COPY start-notebook.d /usr/local/bin/start-notebook.d

USER $NB_USER

