BASE_REG?=quay.io/
BASE_IMAGE?=jupyteronopenshift/s2i-minimal-notebook-py36
BASE_STABLE_VERSION?=:2.5.1

.PHONEY: build

build:
	s2i build base $(BASE_REG)$(BASE_IMAGE)$(BASE_STABLE_VERSION) quay.io/jappavoo/ope-base:latest

