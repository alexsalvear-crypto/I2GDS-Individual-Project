# Linux and R-based multi-gene phylogenetic reconstruction
This repository documents a short, reproducible pipeline for reconstructing a phylogeny from multiple genes using Linux-based tools, including MAFFT for sequence alignment and IQ-TREE for maximum-likelihood inference, followed by tree rooting and visualization in R using the ape package. All steps are performed on the Virginia Tech Advanced Research Computing (ARC) system.

## Introduction

### About the pipeline
This repository documents a reproducible pipeline for reconstructing phylogenies from multiple genes. The pipeline is designed to be recreated on the Virginia Tech Advanced Research Computing (ARC) system.
The pipeline uses MAFFT for multiple sequence alignment, IQ-TREE for maximum-likelihood phylogenetic inference and support estimation, and the ape package in R for tree rooting and visualization. Output files produced by this pipeline can also be explored or further annotated using complementary tools such as iTOL or alternative R packages (e.g., ggtree) which are not covered here.
Example input data are provided to demonstrate the pipeline. The sample dataset consists of FASTA files of gene sequences (CO1, CytB, and ND1) from 31 domestic and wild cat specimens of the subfamily Felinae (Carnivora: Felidae), along with five outgroup taxa from the families Hyaenidae, Viverridae, Nandinidae, Canidae, and Manidae. These data are included as a compressed ZIP file for reproducibility.

### Required input
The pipeline requires FASTA files containing nucleotide sequences, with one file per gene region. Sequence headers must not contain spaces and must be identical for each specimen across all genes. Note that inconsistent naming can lead to errors during concatenation and phylogenetic inference. Example input data are provided in the compressed file [`Sample_Data.zip`](Sample_Data.zip).

## Linux-based phylogenetic inference

### 00 Module load
For this pipeline we used MAFFT and IQ-TREE. These modules are available on the [`VT ARC systems`](https://www.docs.arc.vt.edu/software/01table.html).
To check available versions of MAFFT and IQ-TREE:
```bash
module spider mafft
module spider iq-tree
```
To load MAFFT and IQ-TREE:
```bash
module load MAFFT/7.526-GCC-13.2.0-with-extensions #Or other available versions of MAFFT
module load IQ-TREE/2.3.6-gompi-2023a #Or other available versions of IQ-TREE
```
To confirm both modules are working:
```bash
which mafft
mafft --version
which iq-tree
iq-tree --version
```
This will print the loaded version of each tool. Additionally, this can be confirmed by listing active modules:
```bash
module list
```
If both MAFFT and IQ-TREE are working, you should see them listed as follows:
<img width="3166" height="441" alt="image" src="https://github.com/user-attachments/assets/0f6725e5-3cc8-4ae1-a5bb-ebf23be90639" />

### 01 Sequence concatienation
Sequences were concatenated prior to alignment to generate one combined FASTA file per gene. Each concatenated file contains sequences from all specimens for a single gene and serves as the input for multiple sequence alignment. In the provided sample data, three gene regions are used (**CO1**, **CytB**, and **ND1**). Three concatenated FASTA files are generated, one for each gene accordingly.
```bash
#Using "*" and the gene name will concatenate all FASTA files for that gene in the working directory.
#Output file names are arbitrary, here they are formatted as "Gene_all.fasta".
cat *ND1*.fasta > ND1_all.fasta
cat *CytB*.fasta > CytB_all.fasta
cat *CO1*.fasta > CO1_all.fasta
```
This will generate a single FASTA file for each gene. This can be confirmed using:
```bash
ls *_all.fasta
```
If using the sample data, three concatenated FASTA files should be listed.

### 02 MAFFT: multiple sequence alignment
MAFFT was used to perform multiple sequence alignment for each gene independently. This step aligns homologous nucleotide positions across all specimens within a gene and generates the alignments required for phylogenetic inference using IQ-TREE. MAFFT is run separately on each concatenated gene file using the `--auto` option, which automatically selects an appropriate alignment algorithm based on the data. The `--reorder` option was used to reorder sequences for optimal alignment.

```bash
# Input file names depend on the output of the concatenation step.
# Output file names are arbitrary; here they are formatted as "Gene_aln.fasta".
mafft --auto --reorder CO1_all.fasta  > CO1_aln.fasta
mafft --auto --reorder CytB_all.fasta > CytB_aln.fasta
mafft --auto --reorder ND1_all.fasta  > ND1_aln.fasta
```
To confirm the aligments were done correctly, the alignments need to have the same number of sequences as the input files. This can be checked using:
```bash
echo "COI input:"  && grep '^>' CO1_all.fasta  | wc -l
echo "COI aligned:" && grep '^>' CO1_aln.fasta | wc -l
echo "CytB input:"  && grep '^>' CytB_all.fasta  | wc -l
echo "CytB aligned:" && grep '^>' CytB_aln.fasta | wc -l
echo "ND1 input:"  && grep '^>' ND1_all.fasta  | wc -l
echo "ND1 aligned:" && grep '^>' ND1_aln.fasta | wc -l
```
If aligned correctly, all files should have the same number of sequences:

<img width="187" height="159" alt="image" src="https://github.com/user-attachments/assets/a0b53a35-bba1-407b-9cb0-968abd914564" />

### 03 IQ-TREE: phylogenetic inference
IQ-TREE was used to reconstruct phylogenetic relationships under a maximum-likelihood framework. IQ-TREE can infer trees from a single gene or from multiple genes combined into a partitioned analysis. When multiple genes are used, a partitions file is required to specify the boundaries of each gene in the alignment.
For the sample dataset, three genes (**CO1**, **CytB**, and **ND1**) were included and defined as separate partitions ("part1", "part2", and "part3") in a Nexus file.
To create a partitions file, a new Nexus file was generated:
```bash
# Create a new Nexus file
nano cats_genes.nex
```
The following content was added to define gene partitions:
```
`# Nexus`
begin sets;
   charset part1 = CO1_aln.fasta;
   charset part2 = CytB_aln.fasta;
   charset part3 = ND1_aln.fasta;
end;
```

## Preliminary tree inspection

### 04 iTOL: visualization of unrooted tree

## R-based visualization

### 05 Ape: tree rooting and plotting
