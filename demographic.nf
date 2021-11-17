#!/usr/bin/env nextflow

/*================================================================
The Aguilar Lab presents...

The demographic inference pipeline

- A tool to make demographic inference

==================================================================
Version: 0.1
Project repository:
==================================================================
Authors:

- Bioinformatics Design
 Israel Aguilar-Ordonez (iaguilaror@gmail.com)
 María Fernanda Mirón Toruño (fernandamiront@gmail.com)

- Bioinformatics Development
 María Fernanda Mirón Toruño (fernandamiront@gmail.com)

- Nextflow Port
 Israel Aguilar-Ordonez (iaguilaror@gmail.com)
 María Fernanda Mirón Toruño (fernandamiront@gmail.com)

=============================
Pipeline Processes In Brief:

Pre-processing:


Core-processing:


Pos-processing:

Analysis:

================================================================*/

/* Define the help message as a function to call when needed *//////////////////////////////
def helpMessage() {
	log.info"""
  ==========================================
	The demographic inference pipeline
  v${version}
  ==========================================

	Usage:

	nextflow run ${pipeline_name}.nf --files_path <path to input 1> --pop1_sfs <path to input 2> --pop2_sfs <path to input 3> --pop3_sfs <path to input 4> --snp_number <path to input 5>  [--output_dir path to results ]

	  --files_path	<- The path to the required files for demographic modelling

		--pop1_sfs <- Value for projecting for pop1

		--pop2_sfs <- Value for projecting for pop2

		--pop3_sfs <- Value for projecting for pop3

		--snp_number <- Number of SNPs that are going to be simulated

	  --output_dir  <- directory where results, intermediate and log files will be stored;
	      default: same dir where vcf files are

	  -resume	   <- Use cached results if the executed project has been run before;
	      default: not activated
	      This native NF option checks if anything has changed from a previous pipeline execution.
	      Then, it resumes the run from the last successful stage.
	      i.e. If for some reason your previous run got interrupted,
	      running the -resume option will take it from the last successful pipeline stage
	      instead of starting over
	      Read more here: https://www.nextflow.io/docs/latest/getstarted.html#getstart-resume
	  --help           <- Shows Pipeline Information
	  --version        <- Show version
	""".stripIndent()
}

/*//////////////////////////////
  Define pipeline version
  If you bump the number, remember to bump it in the header description at the begining of this script too
*/
version = "0.1"

/*//////////////////////////////
  Define pipeline Name
  This will be used as a name to include in the results and intermediates directory names
*/
pipeline_name = "nf_demographic"

/*
  Initiate default values for parameters
  to avoid "WARN: Access to undefined parameter" messages
*/
params.files_path = false // default is false to not trigger help message
params.pop1_sfs = false
params.pop2_sfs = false
params.pop3_sfs = false
params.snp_number = false
params.help = false //default is false to not trigger help message automatically at every run
params.version = false //default is false to not trigger version message automatically at every run

/*//////////////////////////////
  If the user inputs the --help flag
  print the help message and exit pipeline
*/
if (params.help){
	helpMessage()
	exit 0
}

/*//////////////////////////////
  If the user inputs the --version flag
  print the pipeline version
*/
if (params.version){
	println "${pipeline_name} v${version}"
	exit 0
}

/*//////////////////////////////
  Define the Nextflow version under which this pipeline was developed or successfuly tested
  Updated by iaguilar at MAY 2021
*/
nextflow_required_version = '20.01.0'
/*
  Try Catch to verify compatible Nextflow version
  If user Nextflow version is lower than the required version pipeline will continue
  but a message is printed to tell the user maybe it's a good idea to update her/his Nextflow
*/
try {
	if( ! nextflow.version.matches(">= $nextflow_required_version") ){
		throw GroovyException('Your Nextflow version is older than Pipeline required version')
	}
} catch (all) {
	log.error "-----\n" +
			"  This pipeline requires Nextflow version: $nextflow_required_version \n" +
      "  But you are running version: $workflow.nextflow.version \n" +
			"  The pipeline will continue but some things may not work as intended\n" +
			"  You may want to run `nextflow self-update` to update Nextflow\n" +
			"============================================================"
}

/*//////////////////////////////
  INPUT PARAMETER VALIDATION BLOCK
*/

/* Check if the input directory is provided
    if it was not provided, it keeps the 'false' value assigned in the parameter initiation block above
    and this test fails
*/
if ( !params.files_path | !params.pop1_sfs | !params.pop2_sfs | !params.pop3_sfs | !params.snp_number) {
  log.error " Please provide the --files_path AND --pop1_sfs AND --pop2_sfs AND --pop3_sfs AND --snp_number \n\n" +
  " For more information, execute: nextflow run nf_demographic --help"
  exit 1
}

/*
Output directory definition
Default value to create directory is the parent dir of --input_dir
*/
params.output_dir = file(params.files_path).getParent() //!! maybe creates bug, should check

/*
  Results and Intermediate directory definition
  They are always relative to the base Output Directory
  and they always include the pipeline name in the variable pipeline_name defined by this Script

  This directories will be automatically created by the pipeline to store files during the run
*/
results_dir = "${params.output_dir}/${pipeline_name}-results/"
intermediates_dir = "${params.output_dir}/${pipeline_name}-intermediate/"

/*
Useful functions definition
*/

/*//////////////////////////////
  LOG RUN INFORMATION
*/
log.info"""
==========================================
The demographic inference pipeline
v${version}
==========================================
"""
log.info "--Nextflow metadata--"
/* define function to store nextflow metadata summary info */
def nfsummary = [:]
/* log parameter values beign used into summary */
/* For the following runtime metadata origins, see https://www.nextflow.io/docs/latest/metadata.html */
nfsummary['Resumed run?'] = workflow.resume
nfsummary['Run Name']			= workflow.runName
nfsummary['Current user']		= workflow.userName
/* string transform the time and date of run start; remove : chars and replace spaces by underscores */
nfsummary['Start time']			= workflow.start.toString().replace(":", "").replace(" ", "_")
nfsummary['Script dir']		 = workflow.projectDir
nfsummary['Working dir']		 = workflow.workDir
nfsummary['Current dir']		= workflow.launchDir
nfsummary['Launch command'] = workflow.commandLine
log.info nfsummary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "\n\n--Pipeline Parameters--"
/* define function to store nextflow metadata summary info */
def pipelinesummary = [:]
/* log parameter values beign used into summary */
pipelinesummary['Input data']			= params.files_path
pipelinesummary['Input data']			= params.pop1_sfs
pipelinesummary['Input data']			= params.pop2_sfs
pipelinesummary['Input data']			= params.pop3_sfs
pipelinesummary['Input data']			= params.snp_number
pipelinesummary['Results Dir']		= results_dir
pipelinesummary['Intermediate Dir']		= intermediates_dir
/* print stored summary info */
log.info pipelinesummary.collect { k,v -> "${k.padRight(15)}: $v" }.join("\n")
log.info "==========================================\nPipeline Start"

/*//////////////////////////////
  PIPELINE START
*/
/* Activar modo DSL2*/
nextflow.enable.dsl=2

/*
	READ INPUTS
*/

/* Load files  into channel*/
vcf_file = Channel.fromPath("${params.files_path}/*.vcf")
pop_file = Channel.fromPath("${params.files_path}/pop.file")
tpl_file = Channel.fromPath("${params.files_path}/p1_p2_p3.tpl")
est_file = Channel.fromPath("${params.files_path}/p1_p2_p3.est")
pop1 = Channel.from("${params.pop1_sfs}" )
pop2 = Channel.from("${params.pop2_sfs}")
pop3 = Channel.value("${params.pop3_sfs}")
number_snps = Channel.from("${params.snp_number}")


/* Import modules
*/
 include {sfs_calculation ; demographic_calculation
	 ; best_likelihood; editing_file} from './nf_modules/modules.nf'

 /*
  * main pipeline logic
  */

 workflow  {
   p1 = sfs_calculation(vcf_file, pop_file, pop1, pop2, pop3)
	 p2 = demographic_calculation(p1, tpl_file, est_file)
	 p3 = best_likelihood(p2)
	 p4 = editing_file(p3, number_snps)
 }
