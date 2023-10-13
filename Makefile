# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONY: help build ope root push publish lab nb python-versions distro-versions image-sha clean
.IGNORE: ope root
SHELL := /bin/bash

# We use this to choose between a jupyter or a gradescope build
BASE := jupyter

OPE_CONTAINER_NAME := $(shell cat base/ope_container_name)


# we use this to choose between a build from the blessed known stable version or a test version
VERSION := stable

BASE_REG := $(shell cat base/base_registry)/
BASE_IMAGE := $(shell cat base/base_image)
BASE_STABLE_TAG := $(shell cat base/base_tag)
BASE_TEST_TAG := :latest

DATE_TAG := $(shell date +"%m.%d.%y_%H.%M.%S")

PRIVATE_USER := $(shell if  [[ -a base/private_user ]]; then cat base/private_user; else echo ${USER}; fi)
PRIVATE_REG := $(shell cat base/private_registry)/
PRIVATE_IMAGE := $(PRIVATE_USER)/$(OPE_CONTAINER_NAME)
PRIVATE_STABLE_TAG := :stable-$(OPE_CONTAINER_NAME) 
PRIVATE_TEST_TAG := :test-$(OPE_CONTAINER_NAME)

PUBLIC_USER := $(shell cat base/ope_book_user)
PUBLIC_REG := $(shell cat base/ope_book_registry)
PUBLIC_IMAGE := $(PUBLIC_USER)/$(OPE_CONTAINER_NAME)
PUBLIC_STABLE_TAG := :stable-$(OPE_CONTAINER_NAME)
PUBLIC_TEST_TAG := :test-$(OPE_CONTAINER_NAME)


# Set customization variables

# To ensure that the container runs correctly on some particular container deployment instance
# we provide a target that will customize the container's file  permissions and user credentials 
# to match what may be required.  This approach grew out of the fact that an openshift RHODS
# cluster starts all containers with a single preordained user id (that is not root).
# The deploynment customization ensures that the jovyan user has an entry in /etc/password with the
# specifed deployment uid and that home directory credentials and permissions match

# Variables to define which image is being customized
# Maybe name CUSTOMIZE_FROM instead of base in order to not confuse between final tagged image vs
# which image it is actually customizing 

CUSTOMIZE_BASE := $(shell cat base/customize_base) # quay.io/opeffort/ope-test

# Tags represent: container name, options such as customize, date

# <reg>/<ope_project>:<stable|test>-<ope_container>-<customization>-<latest|date>
# quay.io/ucsls:stable-ucsls-burosa2023prod-latest

CUSTOMIZE_NAME := $(shell cat base/customize_name) 

# Variables to define final tagged image after customize stage
# CUSTOMIZE_IMAGE := $(CUSTOMIZE_BASE_IMAGE)
# CUSTOMIZE_TAG := :custom-$(shell tail -c +2 base/customize_base_tag)

# USER id
CUSTOMIZE_UID := $(shell cat base/customize_uid)
# GROUP id
CUSTOMIZE_GID := $(shell cat base/customize_gid)
# GROUP name
CUSTOMIZE_GROUP := $(shell cat base/customize_group)


BASE_DISTRO_PACKAGES := $(shell cat base/distro_pkgs)

# use recursive assignment to defer execution until we have mamba versions made
PYTHON_PREREQ_VERSIONS_STABLE =  $(shell cat base/python_prereqs | base/mkversions)
PYTHON_INSTALL_PACKAGES_STABLE = $(shell cat base/python_pkgs | base/mkversions)
PIP_INSTALL_PACKAGES_STABLE = $(shell cat base/pip_pkgs)

PYTHON_PREREQ_VERSIONS_TEST := 
PYTHON_INSTALL_PACKAGES_TEST := $(shell cat base/python_pkgs)
PIP_INSTALL_PACKAGES_TEST := $(shell cat base/pip_pkgs)

JUPYTER_ENABLE_EXTENSIONS := $(shell cat base/jupyter_enable_exts)
JUPYTER_DISABLE_EXTENSIONS := $(shell if  [[ -a base/jupyter_disable_exts  ]]; then cat base/jupyter_disable_exts; fi) 

# build gdb from source to ensure we get the right version and build with tui support
GDB_BUILD_SRC := gdb-12.1

# expand installation so that the image feels more like a proper UNIX user environment with man pages, etc.
UNMIN := yes

# external content
ARCH64VMTGZ := https://cs-web.bu.edu/~jappavoo/Resources/UC-SLS/aarch64vm.tgz

# extra directories to fix permissions on
EXTRA_CHOWN := $(shell if  [[ -a base/extra_chown  ]]; then cat base/extra_chown; fi) 

# Common docker run configuration designed to mirror as closely as possible the openshift experience
# if port mapping for SSH access
SSH_PORT := 2222

# we mount here to match openshift
MOUNT_DIR := /opt/app-root/src
HOST_DIR := ${HOME}

ifeq ($(BASE),jupyter)
  ifeq ($(VERSION),stable)
    BASE_TAG := $(BASE_STABLE_TAG)
    PRIVATE_TAG := $(PRIVATE_STABLE_TAG)
    PUBLIC_TAG := $(PUBLIC_STABLE_TAG)
    PYTHON_PREREQ_VERSIONS = $(PYTHON_PREREQ_VERSIONS_STABLE)
    PYTHON_INSTALL_PACKAGES = $(PYTHON_INSTALL_PACKAGES_STABLE)
    PIP_INSTALL_PACKAGES = $(PIP_INSTALL_PACKAGES_STABLE)
  else
    BASE_TAG := $(BASE_TEST_TAG)
    PRIVATE_TAG := $(PRIVATE_TEST_TAG)
    PUBLIC_TAG := $(PUBLIC_TEST_TAG)
    PYTHON_PREREQ_VERSIONS = $(PYTHON_PREREQ_VERSIONS_TEST)
    PYTHON_INSTALL_PACKAGES = $(PYTHON_INSTALL_PACKAGES_TEST)
    PIP_INSTALL_PACKAGES = $(PIP_INSTALL_PACKAGES_TEST)
  endif
else
  BASE_IMAGE := gradescope/auto-builds
  BASE_VERSION := :ubuntu-20.04
  IMAGE := rh_ee_adhayala/bu-cs-book-gradescope
endif

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

python-versions: ## gather version of python packages
python-versions: base/private_mamba_versions.$(VERSION)

distro-versions: ## gather version of distro packages
distro-versions: base/private_distro_versions.$(VERSION)

image-info: ## gather sha of image
image-info: base/private_image_sha.$(VERSION)

base/private_mamba_versions.$(VERSION): IMAGE = $(PRIVATE_IMAGE)
base/private_mamba_versions.$(VERSION): DARGS ?=
base/private_mamba_versions.$(VERSION):
	docker run -it --rm $(DARGS) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) /bin/bash -c "mamba list | cat" | tr -d '\r' > $@

base/private_distro_versions.$(VERSION): IMAGE = $(PRIVATE_IMAGE)
base/private_distro_versions.$(VERSION): DARGS ?=
base/private_distro_versions.$(VERSION):
	docker run -it --rm $(DARGS) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)  /bin/bash -c "apt list | cat"  | tr -d '\r' > $@

base/private_image_info.$(VERSION): IMAGE = $(PRIVATE_IMAGE)
base/private_image_info.$(VERSION): DARGS ?=
base/private_image_info.$(VERSION):
	docker inspect $(DARGS) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)  > $@

base/aarch64vm/README.md:
	cd base && wget -O - ${ARCH64VMTGZ} | tar -zxf -

build: base/aarch64vm/README.md
build: DARGS ?= --build-arg FROM_REG=$(BASE_REG) \
                   --build-arg FROM_IMAGE=$(BASE_IMAGE) \
                   --build-arg FROM_TAG=$(BASE_TAG) \
                   --build-arg ADDITIONAL_DISTRO_PACKAGES="$(BASE_DISTRO_PACKAGES)" \
                   --build-arg PYTHON_PREREQ_VERSIONS="$(PYTHON_PREREQ_VERSIONS)" \
                   --build-arg PYTHON_INSTALL_PACKAGES="$(PYTHON_INSTALL_PACKAGES)" \
                   --build-arg PIP_INSTALL_PACKAGES="$(PIP_INSTALL_PACKAGES)" \
                   --build-arg JUPYTER_ENABLE_EXTENSIONS="$(JUPYTER_ENABLE_EXTENSIONS)" \
                   --build-arg JUPYTER_DISABLE_EXTENSIONS="$(JUPYTER_DISABLE_EXTENSIONS)" \
                   --build-arg GDB_BUILD_SRC=$(GDB_BUILD_SRC) \
                   --build-arg UNMIN=$(UNMIN)
build: ## Make the base container image 
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(PRIVATE_REG)$(PRIVATE_IMAGE)$(PRIVATE_TAG) --file base/Build.Dockerfile base


customize: DARGS ?= --build-arg FROM_REG=$(CUSTOMIZE_BASE_REG) \
                   --build-arg FROM_IMAGE=$(CUSTOMIZE_BASE_IMAGE) \
                   --build-arg FROM_TAG=$(CUSTOMIZE_BASE_TAG) \
                   --build-arg CUSTOMIZE_UID=$(CUSTOMIZE_UID) \
                   --build-arg CUSTOMIZE_GID=$(CUSTOMIZE_GID) \
                   --build-arg CUSTOMIZE_GROUP=$(CUSTOMIZE_GROUP) \
		               --build-arg EXTRA_CHOWN="$(EXTRA_CHOWN)"
customize:  ## build a customized deployment image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(CUSTOMIZE_BASE)-$(CUSTOMIZE_NAME) --file base/Customize.Dockerfile base


push: IMAGE = $(PRIVATE_IMAGE) #remove references to image. reg, tag, place directly 
push: DARGS ?=
push: ## push private build
# make dated version
	docker tag $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG) $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)_$(DATE_TAG)
# push to private image repo
	docker push $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)_$(DATE_TAG)
# push to update tip to current version
	docker push $(PRIVATE_REG)$(IMAGE)$(PRIVATE_TAG)

pull: IMAGE = $(PUBLIC_IMAGE)
pull: REG = $(PUBLIC_REG)
pull: TAG = $(PUBLIC_TAG)
pull: DARGS ?=
pull: ## pull most recent public version
	docker pull $(REG)$(IMAGE)$(TAG)

pull-priv: IMAGE = $(PRIVATE_IMAGE)
pull-priv: REG = $(PRIVATE_REG)
pull-priv: TAG = $(PRIVATE_TAG)
pull-priv: DARGS ?=
pull-priv: ## pull most recent private version
	docker pull $(REG)$(IMAGE)$(TAG)

publish: IMAGE = $(PUBLIC_IMAGE)
publish: DARGS ?=
publish: ## publish current private build to public published version
# make dated version
	docker tag $(PRIVATE_REG)$(PRIVATE_IMAGE)$(PRIVATE_TAG) $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG)
# push to private image repo
	docker push $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG)
# copy to tip version
	docker tag $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)_$(DATE_TAG) $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)
# push to update tip to current version
	docker push $(PUBLIC_REG)$(IMAGE)$(PUBLIC_TAG)
	cp base/private_image_info.$(VERSION)  base/public_image_info.$(VERSION)
	cp base/private_mamba_versions.$(VERSION) base/public_mamba_versions.$(VERSION)
	cp base/private_distro_versions.$(VERSION) base/public_distro_versions.$(VERSION) 

root: IMAGE = $(PRIVATE_IMAGE)
root: REG = $(PRIVATE_REG)
root: TAG = $(PRIVATE_TAG)
root: ARGS ?= /bin/bash
root: DARGS ?= -u 0
root: ## start private version  with root shell to do admin and poke around
	-docker run -it --rm $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)

user: IMAGE = $(PRIVATE_IMAGE)
user: REG = $(PRIVATE_REG)
user: TAG = $(PRIVATE_TAG)
user: ARGS ?= /bin/bash
user: DARGS ?=
user: ## start private version with usershell to poke around
	-docker run -it --rm $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)

run: IMAGE = $(PUBLIC_IMAGE)
run: REG = $(PUBLIC_REG)
run: TAG = $(PUBLIC_TAG)
run: ARGS ?=
run: DARGS ?= -u $(OPE_DEPLOYMENT_UID):$(OPE_DEPLOYMENT_GID) -v "${HOST_DIR}":"${MOUNT_DIR}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -p ${SSH_PORT}:22
run: PORT ?= 8888
run: ## start published version with jupyter lab interface
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS) 


run-priv: IMAGE = $(PRIVATE_IMAGE)
run-priv: REG = $(PRIVATE_REG)
run-priv: TAG = $(PRIVATE_TAG)
run-priv: ARGS ?=
run-priv: DARGS ?= -u $(OPE_DEPLOYMENT_UID):$(OPE_DEPLOYMENT_GID) -v "${HOST_DIR}":"${MOUNT_DIR}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -p ${SSH_PORT}:22
run-priv: PORT ?= 8888
run-priv: ## start published version with jupyter lab interface
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)

run-cust: IMAGE = $(CUSTOMIZE_IMAGE)
run-cust: REG = $(PRIVATE_REG)
run-cust: TAG = $(CUSTOMIZE_TAG)
run-cust: ARGS ?=
run-cust: DARGS ?= -u $(OPE_DEPLOYMENT_UID):$(OPE_DEPLOYMENT_GID) -v "${HOST_DIR}":"${MOUNT_DIR}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -v "${SSH_AUTH_SOCK}":"${SSH_AUTH_SOCK}" -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -p ${SSH_PORT}:22
run-cust: PORT ?= 8888
run-cust: ## start published version with jupyter lab interface
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(REG)$(IMAGE)$(TAG) $(ARGS)