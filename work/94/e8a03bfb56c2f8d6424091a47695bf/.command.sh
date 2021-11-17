#!/bin/bash -ue
for i in {1..10}; do
fsc2702 -t p1_p2_p3.tpl -n 100 -m -e p1_p2_p3.est -M -L 40 -q -s 0
mkdir r$i
mv p1_p2_p3/* r$i
mv seed.txt r$i
mv p1_p2_p3.par r$i ;done
