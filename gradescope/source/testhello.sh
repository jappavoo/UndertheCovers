#!/bin/bash
#set -x 
# 2 Simple script to help test a hello world python program

pgm=$1

# check we got at least one argument 
if [[ -z $pgm ]]; then
    echo "USAGE: $0 <program>"
    echo " check that that the specified program meets the requirement."
    echo " 1) check the file exits"
    echo " 2) check that the file is executable"
    echo " 3) check that has the correct first line"
    echo " 4) check that when run it produces the right output"
    exit -1
fi

# check 1: does the file exist
if [[ ! -a $pgm ]]; then
    echo "FAIL: $pgm does not exist ... did you commit and push your version of $pgm"
    echo "0/1"
    exit -1
fi

# check 2: is the file executable
if [[ ! -x $pgm ]]; then
    echo "FAIL: $pgm does is not marked as executable ... did you run 'chmod +x $pgm'?"
    echo "0/1"
    exit -1
fi

# check 3: is the first line correct
if [[ $(head -1 $pgm) != '#!/opt/conda/bin/python' ]]; then
    echo "FAIL: $pgm does not have the correct first line.  It should exactly match '#!/opt/conda/bin/python'"
    echo "0/1"
    exit -1
fi

# check 4: when run does the program produce the right output
output=$($pgm)
referenceoutput="Hello World!!!"

if [[ $output == $referenceoutput ]]; then
    echo "Good job your program produces the correct output."
    echo PASS
    echo 1/1
else
    echo "Sorry at this point your program does not produce the correct output."
    echo "Your program produced:"
    echo "$output"
    echo "It should have produced:"
    echo "$referenceoutput"
    echo "Remember this have to match exactly."
    echo FAIL
    echo 0/1
fi

