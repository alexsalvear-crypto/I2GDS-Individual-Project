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
For this pipeline you will need MAFFT and IQ-TREE. These modules are available on the [`VT ARC systems`](https://www.docs.arc.vt.edu/software/01table.html).
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

### 02 MAFFT: multiple sequence alignment

### 03 IQ-TREE: phylogenetic inference

## Preliminary tree inspection

### 04 iTOL: visualization of unrooted tree

## R-based visualization

### 05 Ape: tree rooting and plotting
