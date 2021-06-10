#!/bin/bash

echo '|Binary Value| 6502 Operation|'
echo '|------------|---------------|'
head -20 images/6502_opcodes.txt | while read hex binary opc desc
do
    echo '|' \$$binary\$ '|' $desc '|'
done
