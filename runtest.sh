files_path="test/data"
pop1_sfs=202
pop2_sfs=124
pop3_sfs=152
snp_number=600000
recombination_rate=0
mutation_rate=2.5e-8
output_directory="test/results"

echo -e "======\n Testing NF execution \n======" \
&& rm -rf $output_directory \
&& nextflow run demographic.nf \
	--files_path $files_path \
	--pop1_sfs $pop1_sfs \
	--pop2_sfs $pop2_sfs \
	--pop3_sfs $pop3_sfs \
	--snp_number $snp_number \
	--mutation_rate $mutation_rate \
	--recombination_rate $recombination_rate \
	--output_dir $output_directory \
	-resume \
	-with-report $output_directory/`date +%Y%m%d_%H%M%S`_report.html \
	-with-dag $output_directory/`date +%Y%m%d_%H%M%S`.DAG.html \
&& echo -e "======\n Basic pipeline TEST SUCCESSFUL \n======"
