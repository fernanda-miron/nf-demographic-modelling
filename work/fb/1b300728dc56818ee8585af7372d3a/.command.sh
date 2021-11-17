#!/bin/bash -ue
source ~/miniconda3/etc/profile.d/conda.sh
conda activate easySFS
easySFS.py -a -i out.recode.addedmissingGT.n.recode.vcf -p pop.file 	 --proj=202,124,152 --prefix p1_p2_p3
