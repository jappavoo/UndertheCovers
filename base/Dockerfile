## Dockerfile for constructing the base Open Education Effort (OPE)
## container.  This container contains everything required for authoring OPE courses
## Well is should anyway ;-)

ARG FROM_REG
ARG FROM_IMAGE
ARG FROM_TAG

FROM ${FROM_REG}${FROM_IMAGE}${FROM_TAG}

LABEL maintainer="Open Education <opeffort@gmail.com>"

# ARGS are consumed and reset after FROM
# so any arguments you want to use below must be stated below FROM

ARG ADDITIONAL_DISTRO_PACKAGES
ARG PYTHON_PREREQ_VERSIONS
ARG PYTHON_INSTALL_PACKAGES
ARG JUPYTER_ENABLE_EXTENSIONS
ARG GDB_BUILD_SRC
ARG UNMIN

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add a "USER root" statement followed by RUN statements to install system packages using apt-get,
# change file permissions, etc.

# install linux packages that we require for systems classes
USER root

RUN dpkg --add-architecture i386 && \
    apt-get -y update --fix-missing && \
    apt-get -y install ${ADDITIONAL_DISTRO_PACKAGES} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Now that distro packages are installed lets install the python packages we want
# This was inspired by
# https://github.com/jupyter/docker-stacks/blob/b186ce5fea6aa9af23fb74167dca52908cb28d71/scipy-notebook/Dockerfile

USER ${NB_UID}

# sometimes there are problems with the existing version of installed python packages
# these need to be installed to the prerequisite versions before we can install the rest of the
# packages
RUN mamba install --quiet --yes \
    ${PYTHON_PREREQ_VERSIONS} && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
    
# Install Python 3 packages
RUN mamba install --quiet --yes \
    ${PYTHON_INSTALL_PACKAGES} && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

# enable extensions
RUN for ext in ${JUPYTER_ENABLE_EXTENSIONS} ; do \
   jupyter nbextension enable "$ext" ; \
   done && \
   fix-permissions "${CONDA_DIR}" && \
   fix-permissions "/home/${NB_USER}"

USER root
# as per the nbstripout readme we setup nbstripout be always be used for the joyvan user for all repos
RUN nbstripout --install --system 

# get and build gdb form source so that we have a current version >10 that support more advanced tui functionality 
RUN if [[ -n "${GDB_BUILD_SRC}" ]] ; then \
      cd /tmp && \
      wget http://ftp.gnu.org/gnu/gdb/${GDB_BUILD_SRC}.tar.gz && \
      tar -zxf ${GDB_BUILD_SRC}.tar.gz && \
      cd ${GDB_BUILD_SRC} && \
      ./configure --prefix /usr/local --enable-tui=yes && \
      make -j 4 && make install && \
      cd /tmp && \
      rm -rf ${GDB_BUILD_SRC} && rm ${GDB_BUILD_SRC}.tar.gz ; \
    fi 

COPY aarch64vm /home/aarch64vm
RUN fix-permissions /home/aarch64vm

USER root

# we want the container to feel more like a fully fledged system so we are pulling the trigger and unminimizing it
RUN [[ $UNMIN == "yes" ]] &&  yes | unminimize || true

# jupyter-stack contains logic to run custom start hook scripts from
# two locations -- /usr/local/bin/start-notebook.d and
#                 /usr/local/bin/before-notebook.d
# and scripts in these directoreis are run automatically
# an opportunity to set things up based on dynamic facts such as user name
COPY start-notebook.d /usr/local/bin/start-notebook.d

USER $NB_USER

# final bits of cleanup 
RUN touch /home/${NB_USER}/.hushlogin && \
# use a short prompt to improve default behaviour in presentations
    echo "export PS1='\$ '" >> /home/${NB_USER}/.bashrc && \
# work around bug when term is xterm and emacs runs in xterm.js -- causes escape characters in file    
    echo "export TERM=linux" >> /home/${NB_USER}/.bashrc && \
# finally remove default working directory from joyvan home
    rmdir /home/${NB_USER}/work && \
    fix-permissions "/home/${NB_USER}"

