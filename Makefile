# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONEY: help base-build base-ope base-root base-push base-lab base-nb base-python-versions clean
.IGNORE: base-ope base-root

# We use this to choose between a jupyter or a gradescope build
BASE?=jupyter

# USER id
OPE_UID?=$(shell cat base/ope_uid)

# we use this to choose between a build from the blessed known stable version or a test version
VERSION?=stable

BASE_REG?=docker.io/
BASE_IMAGE?=jupyter/minimal-notebook
BASE_STABLE_TAG?=:2022-07-07
BASE_TEST_TAG?=:latest

PUB_USER=${USER}
PUB_REG?=quay.io/
PUB_IMAGE=$(PUB_USER)/ope
PUB_STABLE_TAG=:stable
PUB_TEST_TAG=:test

# Linux distro packages to install
# FIXME: JA add documetation explaining why we need each package
#  libgmp-dev    : for build of gdb
#  libexpat1-dev : for build of gdb
#  lib32gcc-9-dev : permit 32 bit development (eg datalab)
#  libedit-dev:i386 : permit 32 bit development
#  cm-super : for latex labels (copied from scipy jupyter docker stacks)
#  dvipng : for latex labels (copied from scipy jupyter docker stacks)
#  ffmpeg :  for matplotlib anim

BASE_DISTRO_PACKAGES = $(shell cat base/distro_pkgs)

PYTHON_PREREQ_VERSIONS_STABLE =  $(shell cat base/python_prereqs | base/mkversions)
PYTHON_INSTALL_PACKAGES_STABLE = $(shell cat base/python_pkgs | base/mkversions)


PYTHON_PREREQ_VERSIONS_TEST = 
PYTHON_INSTALL_PACKAGES_TEST = $(shell cat base/python_pkgs)

JUPYTER_ENABLE_EXTENSIONS = $(shell cat base/jupyter_enable_exts)

# build gdb from source to ensure we get the right version and build with tui support
GDB_BUILD_SRC=gdb-12.1

# expand installation so that the image feels more like a proper UNIX user environment with man pages, etc.
UNMIN=yes

# external content
ARCH64VMTGZ=https://cs-web.bu.edu/~jappavoo/Resources/UC-SLS/aarch64vm.tgz

# Common docker run configuration designed to mirror as closely as possible the openshift experience
# if port mapping for SSH access
SSH_PORT?=2222

# we mount here to match openshift
MOUNT_DIR=/opt/app-root/src
HOST_DIR=${HOME}

ifeq ($(BASE),jupyter)
  ifeq ($(VERSION),stable)
    BASE_TAG=$(BASE_STABLE_TAG)
    PUB_TAG=$(PUB_STABLE_TAG)
    PYTHON_PREREQ_VERSIONS=$(PYTHON_PREREQ_VERSIONS_STABLE)
    PYTHON_INSTALL_PACKAGES=$(PYTHON_INSTALL_PACKAGES_STABLE)
  else
    BASE_TAG=$(BASE_TEST_TAG)
    PUB_TAG=$(PUB_TEST_TAG)
    PYTHON_PREREQ_VERSIONS=$(PYTHON_PREREQ_VERSIONS_TEST)
    PYTHON_INSTALL_PACKAGES=$(PYTHON_INSTALL_PACKAGES_TEST)
  endif
else
  BASE_IMAGE=gradescope/auto-builds
  BASE_VERSION=:ubuntu-20.04
  IMAGE:=rh_ee_adhayala/bu-cs-book-gradescope
endif

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


base-python-versions: ## gather version of python packages
base-python-versions: base/mamba_versions.stable

base/mamba_versions.stable: IMAGE=$(PUB_IMAGE)-base
base/mamba_versions.stable: ARGS?=/bin/bash
base/mamba_versions.stable: DARGS?=
base/mamba_versions.stable:
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) mamba list | tr -d '\r' > $@

base/apt.versions:
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) apt list > $@

base/aarch64vm/README.md:
	cd base && wget -O - ${ARCH64VMTGZ} | tar -zxf -

base-build: base/aarch64vm/README.md
base-build: IMAGE=$(PUB_IMAGE)-base
base-build: DARGS?=--build-arg FROM_REG=$(BASE_REG) \
                   --build-arg FROM_IMAGE=$(BASE_IMAGE) \
                   --build-arg FROM_TAG=$(BASE_TAG) \
                   --build-arg OPE_UID=$(OPE_UID) \
                   --build-arg ADDITIONAL_DISTRO_PACKAGES="$(BASE_DISTRO_PACKAGES)" \
                   --build-arg PYTHON_PREREQ_VERSIONS="$(PYTHON_PREREQ_VERSIONS)" \
                   --build-arg PYTHON_INSTALL_PACKAGES="$(PYTHON_INSTALL_PACKAGES)" \
                   --build-arg JUPYTER_ENABLE_EXTENSIONS="$(JUPYTER_ENABLE_EXTENSIONS)" \
                   --build-arg GDB_BUILD_SRC=$(GDB_BUILD_SRC) \
                   --build-arg UNMIN=$(UNMIN)
base-build: ## Make the base image
	-docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(PUB_REG)$(IMAGE)$(PUB_TAG) base

base-push: IMAGE=$(PUB_IMAGE)-base
base-push: DARGS?=
base-push: ## push base image
	docker push $(PUB_REG)$(IMAGE)$(PUB_TAG)

base-root: IMAGE=$(PUB_IMAGE)-base
base-root: ARGS?=/bin/bash
base-root: DARGS?=-u 0
base-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS)

base-ope: IMAGE=$(PUB_IMAGE)-base
base-ope: ARGS?=/bin/bash
base-ope: DARGS?=
base-ope: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS)

base-nb: IMAGE=$(PUB_IMAGE)-base
base-nb: ARGS?=
base-nb: DARGS?=-e DOCKER_STACKS_JUPYTER_CMD=notebook -v "${HOST_DIR}":"${MOUNT_DIR}" 
base-nb: PORT?=8888
base-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS) 

base-lab: IMAGE=$(PUB_IMAGE)-base
base-lab: ARGS?=
base-lab: DARGS?=-u $(OPE_UID) -v "${HOST_DIR}":"${MOUNT_DIR}"
base-lab: PORT?=8888
base-lab: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS) 


