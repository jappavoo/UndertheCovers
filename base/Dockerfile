## Dockerfile for constructing the base Open Education Effort (OPE)
## container.  This container contains everything required for authoring OPE courses
## Well is should anyway ;-)

ARG BASE_REG
ARG BASE_IMAGE
ARG BASE_TAG
FROM ${BASE_REG}${BASE_IMAGE}${BASE_TAG}

LABEL name="s2i-odh-ope-base" \
      version="latest" \
      summary="Open Education Effort Customized Jupyter Notebook Source-to-Image for Python 3.9 applications." \
      description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.display-name="Custom Notebook Python 3.9 S2I" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="python,python39" \
      io.openshift.s2i.build.commit.ref="container" \
      io.openshift.s2i.build.source-location="https://github.com/OPEFFORT/ope"
ENV XDG_CACHE_HOME="/opt/app-root/src/.cache" \
    THAMOS_RUNTIME_ENVIRONMENT="" \
    UPGRADE_PIP_TO_LATEST="1" \
    WEB_CONCURRENCY="1" \
    THOTH_ADVISE="0" \
    THOTH_ERROR_FALLBACK="1" \
    THOTH_DRY_RUN="1" \
    THAMOS_DEBUG="0" \
    THAMOS_VERBOSE="1" \
    THOTH_PROVENANCE_CHECK="0"

USER root

# Add all build time work that we need to do as root here
# 1) install linux packages that we need for OPE book development and course materials
#    FIXME: Right now this is a mess of stuff that JA and OK need for systems classes in addition
#    to the minimum needed for OPE juypter book authorimg

# minimal-notebook no longer inludes compiler and other tools we we install them
# and some other standard unix develpment tools
#  stuff for gdb texinfo libncurses 
#  ssh
#  vim 
#  emacs
#  6502 tool chain -- includes C compiler, assembler and a linker
#  file utility -- guesses the type of content in a file -- standard unix tool
#  man pages
#  find
#  we add xterm to pick up resize :-(
#
# build-essential
#Unable to find a matchs for these in ubi8: texinfo emacs-nox cc65 man-pages xterm strace bison flex nasm rlwrap qemu-system-aarch64 libbsd
RUN dnf -y upgrade && \
    dnf -y install ncurses-devel vim  \
    man-db  bc gdb cmake gcc-c++ \
    openssh openssl-devel elfutils-libelf \
    socat libgcc.i686 libedit-devel.i686 && \
    dnf update --assumeyes --nobest --setopt=tsflags=nodocs && \
    dnf --assumeyes clean all && \
    rm -rf /var/cache/dnf

#  adding moria for old time sake
#  sed '36d' CMakeLists.txt -> Ref: https://github.com/dungeons-of-moria/umoria/issues/44
RUN cd /tmp && wget https://github.com/dungeons-of-moria/umoria/archive/refs/tags/v5.7.15.tar.gz \
    && tar -zxf v5.7.15.tar.gz && cd umoria-5.7.15 && sed -i '36d' CMakeLists.txt \
    && cmake . && make \
    && mv umoria /opt/umoria \
    && ln -s /opt/umoria/umoria /opt/umoria/moria \
    && cd /tmp && rm -rf v5.7.15 && rm v5.7.15.tar.gz

ENV PATH=$PATH:/opt/umoria

# FIXME: This probably should go back to being a seperate image but to ease bootstrap
# have merged this into the base image
# Un-minimize the system -- aka add documentation and man pages back to the container
# To ensure a more complete UNIX user experience
# from http://docs.projectatomic.io/container-best-practices/
RUN [ -e /etc/dnf/dnf.conf ] && sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf || true
RUN dnf -y reinstall "*"

### What Follows is the s2i standard stuff that we want to continue along with

# clean up cache
RUN rm -rf /var/cache/dnf
# Copying in override assemble/run scripts
COPY .s2i/bin /tmp/scripts
# Copying in source code
COPY . /tmp/src

# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/scripts /tmp/src
USER 1001

RUN /tmp/scripts/assemble
CMD /tmp/scripts/run
