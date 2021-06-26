#!/bin/bash

GHP_SUFFIX="github.io"

# extract first component of repo name
# by github convention this is the use name 
ghuser=$(dirname $(git config --get remote.origin.url))
ghuser=${ghuser##*:}

repo=$(basename $(git config --get remote.origin.url))
repo=${repo%%.git}

echo "https://${ghuser}.${GHP_SUFFIX}/${repo}/$1"
