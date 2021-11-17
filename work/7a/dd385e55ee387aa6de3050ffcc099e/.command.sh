#!/bin/bash -ue
head -n -1 p1_p2_p3_maxL.par > file_1
echo "DNA" > chrc1
echo 600000 > chrc2
echo 2.5e-8 > chrc3
echo OUTEXP > chrc4
paste chrc1 chrc2 chrc3 chrc4 > file_2
cat file_1 file_2 > final.par
