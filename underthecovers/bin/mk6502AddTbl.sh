#!/bin/bash

echo '|Memonic|Binary Value|6502 Operation|'
echo '|-------|-------------|---------------|'
grep ADC images/6502_opcodes.txt | while read hex binary opc desc
do
    echo '|' $opc '|' \$$binary\$ '|' $desc '|'
done
