#!/bin/bash
DIR=$1

if [[ -z $DIR ]]; then
    echo "USAGE: fixrefs.sh <PATH>"
    echo "   kludgy script to try and find broken links to ipynb files and fix them"
    exit -1
fi

find ${DIR} -type f -name '*.html' | while read file
do
    if grep -q '<a class="reference external" href=".*\.ipynb.*"' $file; then
	#  THIS IS REALLY STUPID -- But I could not figure out how to get sed to fix all the broken links of a single line
	#     only did the last link ... so I ended up just looping until I found no more broken links :-(
	
	while grep -q '<a class="reference external" href=".*\.ipynb.*">' $file; do
	    echo "$file -- broken links??"
	    # -i is for inplace update -- leaves original in in $file.orig -- not -i'' would stop backups from being created
	    sed -i.orig -E 's/(<a class="reference external" href=")(.*)\.ipynb(.*)"/\1\2.html\3"/g' $file
	done
    fi
done
