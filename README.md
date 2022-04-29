
# **nf-demographic-modelling**

[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A521.10.5-green.svg)](https://www.nextflow.io/)
[![Ubuntu](https://img.shields.io/badge/ubuntu-%E2%89%A518.04-orange.svg)](https://ubuntu.com/download)

Nextflow pipeline that simulates neutral genomic data with fastsimcoal2

### **Introduction**

**nf-demographic-modelling** is a bioinformatics best-practice analysis pipeline for simulating
genomic data under neutral models. 

The pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner.

### **Pipeline Summary**

By default, the pipeline currently performs the following:

1. SFS calculation (`easySFS`)
2. Demographic model generation (`fastsimcoal2`)
3. Neutral model data generation (`fastsimcoal2`)
4. ARLEQUIN to VCF file (`PGDSpider`)

### **Requirements**


#### Compatible OS:

-   [Ubuntu 18.04 ](http://releases.ubuntu.com/18.04/)

#### Software:

|                    Requirement                     |          Version           |  Required Commands \*  |
|:--------------------------------------------------:|:--------------------------:|:----------------------:|
|        [Nextflow](https://www.nextflow.io/)        |          21.10.5           |        nextflow        |
| [easySFS](https://github.com/isaacovercast/easySFS)       |          NA          | SFS calculation   |
| [fastsimcoal2](http://cmpg.unibe.ch/software/fastsimcoal27/)       |          fsc27 (.09)           | Data simulation  |
|          [PGDSpider](http://www.cmpg.unibe.ch/software/PGDSpider/)           |           2.1.1.5            | HAP2VCF  |



\* **easySFS and fastsimcoal2** must be accessible from your `$PATH` (*i.e.* you
should be able to invoke them from your command line).

### **Installation**

Download nf_selection from Github repository:

    git clone https://github.com/fernanda-miron/nf-demographic-modelling.git

------------------------------------------------------------------------

### **Test**

To test nf_selection execution using test data, run:

    bash runtest.sh

Your console should print the Nextflow log for the run, once every
process has been submitted, the following message will appear:

     ======
     Basic pipeline TEST SUCCESSFUL
     ======

results for test data should be in the following file:

    nf_selection/test/results
    
### **Usage**

### **Main arguments**

    --files_path [VCF and popfile]
    --pop1_sfs [Number of pop1 individuals x2]
    --pop2_sfs [Number of pop2 individuals x2]
    --pop3_sfs [Number of popout individuals x2]
    --snp_number [Number of snps to be simulated]
    --recombination_rate [Recombination rate]
    --mutation_rate [Mutation rate]
    
### **Running the pipeline**
The typical command for running the pipeline is as follows:

    nextflow run demographic.nf \
	--files_path $files_path \
	--pop1_sfs $pop1_sfs \
	--pop2_sfs $pop2_sfs \
	--pop3_sfs $pop3_sfs \
	--snp_number $snp_number \
	--mutation_rate $mutation_rate \
	--recombination_rate $recombination_rate

### **Authors**

Fernanda Miron T