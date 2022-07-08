# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONEY: help build dev test test-env clean

# We use this to choose between a jupyter or a gradescope build
BASE?=jupyter

# we use this to choose between a build from the blessed known stable version or a test version
VERSION?=stable

BASE_REG?=quay.io/
BASE_IMAGE?=thoth-station/s2i-minimal-f34-py39-notebook
#BASE_STABLE_TAG?=@sha256:8dd0326cdb8f89dedd1a858ed7469fce77a84a444c2656f134896ab20449121
BASE_STABLE_TAG?=:v0.3.0
BASE_TEST_TAG?=:latest

PUB_REG?=quay.io/
PUB_IMAGE=jappavoo/bu-cs-book-dev
PUB_STABLE_TAG=:ope_stable
PUB_TEST_TAG=:ope_test

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
  else
    BASE_TAG=$(BASE_TEST_TAG)
    PUB_TAG=$(PUB_TEST_TAG)
  endif
else
  BASE_IMAGE=gradescope/auto-builds
  BASE_VERSION=:ubuntu-20.04
  IMAGE:=rh_ee_adhayala/bu-cs-book-gradescope
endif

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

base/aarch64vm/README.md:
	cd base && wget -O - ${ARCH64VMTGZ} | tar -zxf -

base-build: base/aarch64vm/README.md
base-build: IMAGE=$(PUB_IMAGE)-base
base-build: DARGS?=--build-arg BASE_REG=$(BASE_REG) --build-arg BASE_IMAGE=$(BASE_IMAGE) --build-arg BASE_TAG=$(BASE_TAG)
base-build: ## Make the base image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(PUB_REG)$(IMAGE)$(PUB_TAG) base

base-push: IMAGE=$(PUB_IMAGE)-base
base-push: DARGS?=
base-push: ## push base image
	docker push $(PUB_REG)$(IMAGE)$(PUB_TAG)

base-root: IMAGE=$(PUB_IMAGE)-base
base-root: ARGS?=/bin/bash
base-root: DARGS?=-u 0
base-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS)

base-default: IMAGE=$(PUB_IMAGE)-base
base-default: ARGS?=/bin/bash
base-default: DARGS?=
base-default: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS)

base-nb: IMAGE=$(PUB_IMAGE)-base
base-nb: ARGS?=
base-nb: DARGS?=--user $(shell id -u)  -e JUPYTER_ENABLE_LAB=0  -v "${HOST_DIR}":"${MOUNT_DIR}" 
base-nb: PORT?=8080
base-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):$(PORT) $(DARGS) $(PUB_REG)$(IMAGE)$(PUB_TAG) $(ARGS) 


