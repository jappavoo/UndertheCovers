# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONEY: help build ope root push publish lab nb python-versions clean
.IGNORE: ope root

# We use this to choose between a jupyter or a gradescope build
BASE?=jupyter

OPE_BOOK?=$(shell cat base/ope_book)
# USER id
OPE_UID?=$(shell cat base/ope_uid)

# we use this to choose between a build from the blessed known stable version or a test version
VERSION?=stable

BASE_REG?=$(shell cat base/base_registry)/
BASE_IMAGE?=$(shell cat base/base_image)
BASE_STABLE_TAG?=$(shell cat base/base_tag)
BASE_TEST_TAG?=:latest

DATE_TAG=$(shell date +"%m.%d.%y_%H.%M.%S")

PRIVATE_USER?=$(shell if  [[ -a base/private_user ]]; then cat base/private_user; else echo ${USER}; fi)
PRIVATE_REG?=$(shell cat base/private_registry)/
PRIVATE_IMAGE?=$(PRIVATE_USER)/$(OPE_BOOK)
PRIVATE_STABLE_TAG?=:stable
PRIVATE_TEST_TAG?=:test

PUBLIC_USER?=$(shell cat base/ope_book_user)
PUBLIC_REG?=$(shell cat base/ope_book_registry)/
PUBLIC_IMAGE?=$(PUBLIC_USER)/$(OPE_BOOK)
PUBLIC_STABLE_TAG?=:stable
PUBLIC_TEST_TAG?=:test

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
    PRIVATE_TAG=$(PRIVATE_STABLE_TAG)
    PUBLIC_TAG=$(PUBLIC_STABLE_TAG)
    PYTHON_PREREQ_VERSIONS=$(PYTHON_PREREQ_VERSIONS_STABLE)
    PYTHON_INSTALL_PACKAGES=$(PYTHON_INSTALL_PACKAGES_STABLE)
  else
    BASE_TAG=$(BASE_TEST_TAG)
    PRIVATE_TAG=$(PRIVATE_TEST_TAG)
    PUBLIC_TAG=$(PUBLIC_TEST_TAG)
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

base/mamba_versions.stable: IMAGE=$(PRIVATE_IMAGE)
base/mamba_versions.stable: ARGS?=/bin/bash
base/mamba_versions.stable: DARGS?=
base/mamba_versions.stable:
	docker run -it --rm $(DARGS) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) mamba list | tr -d '\r' > $@

base/apt.versions:
	docker run -it --rm $(DARGS) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) apt list > $@

base/aarch64vm/README.md:
	cd base && wget -O - ${ARCH64VMTGZ} | tar -zxf -

build: base/aarch64vm/README.md
build: IMAGE=$(PRIVATE_IMAGE)
build: DARGS?=--build-arg FROM_REG=$(BASE_REG) \
                   --build-arg FROM_IMAGE=$(BASE_IMAGE) \
                   --build-arg FROM_TAG=$(BASE_TAG) \
                   --build-arg OPE_UID=$(OPE_UID) \
                   --build-arg ADDITIONAL_DISTRO_PACKAGES="$(BASE_DISTRO_PACKAGES)" \
                   --build-arg PYTHON_PREREQ_VERSIONS="$(PYTHON_PREREQ_VERSIONS)" \
                   --build-arg PYTHON_INSTALL_PACKAGES="$(PYTHON_INSTALL_PACKAGES)" \
                   --build-arg JUPYTER_ENABLE_EXTENSIONS="$(JUPYTER_ENABLE_EXTENSIONS)" \
                   --build-arg GDB_BUILD_SRC=$(GDB_BUILD_SRC) \
                   --build-arg UNMIN=$(UNMIN)
build: ## Make the image customized appropriately
	-docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) base

push: IMAGE=$(PRIVATE_IMAGE)
push: DARGS?=
push: ## push private build
# make dated version
	docker tag $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)_$(DATE_TAG)
# push to private image repo
	docker push $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)_$(DATE_TAG)
# push to update tip to current version
	docker push $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)

publish: IMAGE=$(PUBLIC_IMAGE)
publish: DARGS?=
publish: ## publish current private build to public published version
# make dated version
	docker tag $(PRIVATE_REG)$(PRIVATE_IMAGE)$(PRIVATE_TAG) $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG)
# push to private image repo
	docker push $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG)
# copy to tip version
	docker tag $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG) $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)
# push to update tip to current version
	docker push $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)

root: IMAGE?=$(PRIVATE_IMAGE)
root: REG?=$(PRIVATE_REG)
root: TAG?=$(PRIVATE_TAG)
root: ARGS?=/bin/bash
root: DARGS?=-u 0
root: ## start private version  with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)

ope: IMAGE?=$(PRIVATE_IMAGE)
ope: REG?=$(PRIVATE_REG)
ope: TAG?=$(PRIVATE_TAG)
ope: ARGS?=/bin/bash
ope: DARGS?=
ope: ## start privae version with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)

nb: IMAGE?=$(PUBLIC_IMAGE)
nb: REG?=$(PUBLIC_REG)
nb: TAG?=$(PUBLIC_TAG)
nb: ARGS?=
nb: DARGS?=-e DOCKER_STACKS_JUPYTER_CMD=notebook -v "${HOST_DIR}":"${MOUNT_DIR}" -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -p ${SSH_PORT}:22
nb: PORT?=8888
nb: ## start published version with jupyter classic notebook interface
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS) 

lab: IMAGE?=$(PUBLIC_IMAGE)
lab: REG?=$(PUBLIC_REG)
lab: TAG?=$(PUBLIC_TAG)
lab: ARGS?=
lab: DARGS?=-u $(OPE_UID) -v "${HOST_DIR}":"${MOUNT_DIR}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -p ${SSH_PORT}:22
lab: PORT?=8888
lab: ## start published version with jupyter lab interface
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS) 


