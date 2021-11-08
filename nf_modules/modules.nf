#!/usr/bin/env nextflow

/*Modulos de prueba para  nextflow */
results_dir = "./test/results"
intermediates_dir = "./test/results/intermediates"

process sfs_calculation {

publishDir "${results_dir}/sfs_results/", mode:"copy"

	input:
	path vcf_file
	path pop_file
	val pop1_val
	val pop2_val
	val pop3_val

	output:
	file "output/fastsimcoal2/*"

	"""
	source ~/miniconda3/etc/profile.d/conda.sh
	conda activate easySFS
	easySFS.py -a -i ${vcf_file} -p ${pop_file} \
	 --proj=${pop1_val},${pop2_val},${pop3_val} --prefix p1_p2_p3
	"""
}
