//Parameters for the coalescence simulation program : fastsimcoal.exe
3 samples to simulate :
//Population effective sizes (number of genes)
196000
60000
NCUR
//Samples sizes and samples age
101
62
84
//Growth rates	: negative growth implies population expansion
-0.0048
-0.0048
0
//Number of migration matrices : 0 implies no migration between demes
0
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
4 historical event
TBOT 2 2 1 RESBOT 0 0
TPP 2 1 1 1 -0.0048 0
920 1 0 1 1 0 0
2040 0 0 1 24.39 0 0
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per generation recombination and mutation rates and optional parameters
FREQ 1 0 2.5e-8 OUTEXP
