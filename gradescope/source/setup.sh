#!/usr/bin/env bash
# these get both gcc, make and python
apt-get install -y python python3-pip python-dev

# setup a compatible path for python with respect to the container
mkdir -p /opt/conda/bin
ln -s /usr/bin/python3.8 /opt/conda/bin/python
