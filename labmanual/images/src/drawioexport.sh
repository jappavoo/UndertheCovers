#!/bin/bash
#set -x
#default export to png
DIOFORMAT=${DIOFORMAT:-png}
#default do not make background transparent : set to -t to make transparent
DIOTRANSPARENT=${DIOTRANSPARENT:-}
#page to export defaults to all pages (0)
DIOPAGE=${DIOPAGE:-0}
#default border width
DIOBORDER=${DIOBORDER:-1}
# scale ??? 6 = 600dpi?
DIOSCALE=1

DIO=$(type -p draw.io)
[[ -z $DIO &&  -x "/Applications/draw.io.app/Contents/MacOS/draw.io" ]] && DIO="/Applications/draw.io.app/Contents/MacOS/draw.io"

if [[ -z $DIO ]]; then
   echo "ERROR: failed to find draw.io executable"
   exit -1
fi

input=$1
output=$2

if [[ $DIOPAGE = 0 ]]; then
    # Export diagram to plain XML
    $DIO --export --format xml --uncompressed -o /tmp/$$_$input.xml "$input" 2> /dev/null
    # Count how many pages based on <diagram element
    count=$(grep -o '<diagram' /tmp/$$_$input.xml | wc -l)
    pages=$(seq 0 $(($count-1)) )
    rm /tmp/$$_$input.xml
fi

echo $pages
for page in $pages; do
    ofile=$(printf "$output/%03d.$DIOFORMAT" $page)
    echo $DIO -x  -f $DIOFORMAT $DIOTRANSPARENT -b $DIOBORDER -s $DIOSCALE -p $page $input -o $ofile
    $DIO -x  -f $DIOFORMAT $DIOTRANSPARENT -b $DIOBORDER -s $DIOSCALE -p $page $input -o $ofile 2>/dev/null
    
done
