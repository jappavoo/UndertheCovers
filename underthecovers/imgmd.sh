#!/bin/bash

prefix=${prefix:-"../images/"}
extra=${extra:-""}

ls -1 | while read file;
do	      
    echo "<center>"
    echo   "<img src=\"$prefix$file\" $extra>"
    echo "</center>"
    echo
done
