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
	eval "\$(conda shell.bash hook)"
	conda activate easySFS
	easySFS.py -a -i ${vcf_file} -p ${pop_file} \
	 --proj=${pop1_val},${pop2_val},${pop3_val} --prefix p1_p2_p3
	"""
}

process demographic_calculation {

publishDir "${results_dir}/final_par_file/", mode:"copy"

	input:
	path p1
	file tpl_file
	file est_file

	output:
	file "r*"

	"""
	for i in {1..10}; do
	fsc2709 -t ${tpl_file} -n 100 -m -e ${est_file} -M -L 40 -q -s 0
	mkdir r\$i
	mv p1_p2_p3/* r\$i
	mv seed.txt r\$i
	mv p1_p2_p3.par r\$i ;done
	"""
}

process best_likelihood {

publishDir "${results_dir}/maximum_par_file/", mode:"copy"

	input:
	path p2

	output:
	path "best_likelihood/p1_p2_p3_maxL.par"

	shell:
  '''
	for i in {1..10}; do
	tail -n1 r\$i/p1_p2_p3.bestlhoods > results
	echo r\$i > name
	paste name results > r\$i.txt ;done

	cat r*.txt > likelihoods
	sort -k 6 -n likelihoods | tail -1 | cut -f1 > best_likelihood

	shopt -s extglob
	rm -R !("$(cat best_likelihood)")
	cp -r r* ./best_likelihood
	'''
}

process editing_file {

publishDir "${results_dir}/modified_maxlpar/", mode:"copy"

	input:
	path p3
	val no_snps
	val recombination_rate
	val mutation_rate

	output:
	path "final.par"

	"""
	head -n -1 ${p3} > file_1
	echo "DNA" > chrc1
	echo ${no_snps} > chrc2
	echo ${recombination_rate} > chrc3
	echo ${mutation_rate} > chrc4
	echo OUTEXP > chrc5
	paste -d " " chrc1 chrc2 chrc3 chrc4 chrc5 > file_2
	cat file_1 file_2 > final.par
	"""
}

process simulating_data {

publishDir "${results_dir}/simulated_data/", mode:"copy"

	input:
	path p4

	output:
	path "final/"

	"""
	fsc2709 -i ${p4} -n 100 -j 1 -m -s 0
	"""
}
