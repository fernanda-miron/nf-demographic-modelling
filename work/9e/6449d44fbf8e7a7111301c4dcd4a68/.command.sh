#!/bin/bash -ue
for i in {1..10}; do
tail -n1 r$i/p1_p2_p3.bestlhoods > results
echo r$i > name
paste name results > r$i.txt ;done

cat r*.txt > likelihoods
sort -k 6 -n likelihoods | tail -1 | cut -f1 > best_likelihood

shopt -s extglob
rm -R !("$(cat best_likelihood)")
cp -r r* ./best_likelihood
