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

### 00 Environment setup

### 01 Sequence concatienation

### 02 MAFFT: multiple sequence alignment

### 03 IQ-TREE: phylogenetic inference

## Preliminary tree inspection

### 04 iTOL: visualization of unrooted tree

## R-based visualization

### 05 Ape: tree rooting and plotting
