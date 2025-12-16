# Linux and R-based multi-gene phylogenetic reconstruction
This repository documents a short, reproducible pipeline for reconstructing a phylogeny from multiple genes using Linux-based tools, including MAFFT for sequence alignment and IQ-TREE for maximum-likelihood inference, followed by tree rooting and visualization in R using the ape package. All steps are performed on the Virginia Tech Advanced Research Computing (ARC) system.

## Introduction

### About the pipeline
This repository documents a reproducible pipeline for reconstructing phylogenies from multiple genes. The pipeline is designed to be recreated on the Virginia Tech Advanced Research Computing (ARC) system.
The pipeline uses MAFFT for multiple sequence alignment, IQ-TREE for maximum-likelihood phylogenetic inference and support estimation, and the ape package in R for tree rooting and visualization. Output files produced by this pipeline can also be explored or further annotated using complementary tools such as iTOL or alternative R packages (e.g., ggtree) which are not covered here.
Example input data are provided to demonstrate the pipeline. The sample dataset consists of FASTA files of gene sequences (CO1, CytB, and ND1) from 31 domestic and wild cat specimens of the subfamily Felinae (Carnivora: Felidae), along with five outgroup taxa from the families Hyaenidae, Viverridae, Nandinidae, Canidae, and Manidae. These data are included as a compressed ZIP file for reproducibility.

### Required input
The pipeline requires FASTA files containing nucleotide sequences, with one file per gene region. Sequence headers must not contain spaces and must be identical for each specimen across all genes. Note that inconsistent naming can lead to errors during concatenation and phylogenetic inference, see [`Note 1`](Notes/Note_1.md). Example input data are provided in the compressed file [`Sample_Data.zip`](Files/Input_Files/Sample_Data.zip).

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

### 01 Sequence concatenation
Sequences were concatenated prior to alignment to generate one combined FASTA file per gene. Each concatenated file contains sequences from all specimens for a single gene and serves as the input for multiple sequence alignment. In the provided sample data, three gene regions are used (**CO1**, **CytB**, and **ND1**). Three concatenated FASTA files are generated, one for each gene accordingly. See [`Note 2`](Notes/Note_2.md) for possible concatenation errors.
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

Concatenation errors will ve evident if values of 0 and 1 appear after this step. See [`Note 2`](Notes/Note_2.md).

### 03 IQ-TREE: phylogenetic inference
IQ-TREE was used to reconstruct phylogenetic relationships under a maximum-likelihood framework. IQ-TREE can infer trees from a single gene or from multiple genes combined into a partitioned analysis. When multiple genes are used, a partitions file is required to specify the boundaries of each gene in the alignment.
For the sample dataset, three genes (**CO1**, **CytB**, and **ND1**) were included and defined as separate partitions ("part1", "part2", and "part3") in a Nexus file.
To create a partitions file, a new Nexus file was generated:
```bash
#Create a new Nexus file
#File name is arbitrary, in this case "cats_genes.nex"
nano cats_genes.nex
```
The following content was added to define gene partitions:
```text
# Nexus
begin sets;
   charset part1 = CO1_aln.fasta;
   charset part2 = CytB_aln.fasta;
   charset part3 = ND1_aln.fasta;
end;
```
The presence of the partitions file can be confirmed using:
```bash
#This should list the newly created partitions file.
ls *.nex 
```
IQ-TREE was executed using the partition file defined above to perform a partitioned maximum-likelihood analysis with ultrafast bootstrap support.
```bash
#Output file names are based on the partitions file name, in this case "cats_genes.nex"
iqtree2 -p cats_genes.nex -B 1000 -nt AUTO
```
IQ-TREE produces multiple output files during execution (12 files for the sample data run). The primary output used in subsequent steps is the [`treefile`](Files/Linux_Output/cats_genes.nex.treefile), which contains the inferred phylogeny with branch lengths and support values:
<img width="5241" height="403" alt="image" src="https://github.com/user-attachments/assets/a2cd602c-91cc-43dd-aba6-2d6bb40e8879" />

## Preliminary tree inspection

### 04 iTOL: visualization of unrooted tree
At this stage, the `.treefile` produced by IQ-TREE represents an unrooted phylogeny. This tree can be inspected using several visualization tools. **iTOL** ([`Interactive Tree Of Life`](https://itol.embl.de/login.cgi)) is a free, web-based tool that allows quick visualization and basic annotation of phylogenetic trees.
The IQ-TREE `.treefile` can be uploaded directly to iTOL for preliminary inspection of overall topology and branch support prior to rooting and final figure generation. For the sample data, the unrooted tree looks like this:
<img width="629" height="503" alt="image" src="https://github.com/user-attachments/assets/ed9d509a-7914-4c99-a8d6-3f11e44495c1" />

## R-based visualization

### 05 Ape: tree rooting and plotting
The phylogenetic tree produced by IQ-TREE can be rooted and visualized in R using the **ape** package. When using RStudio through the VT ARC Open OnDemand interface, files located in the same working directory (including the `.treefile`) can be accessed directly without additional file transfer steps.
The **ape** package is available in the VT ARC RStudio environment. This can be confirmed by loading the library and checking the installed version:

```r
library(ape)
# If the library loads without errors, ape is installed and ready to use.
packageVersion("ape")
# This will display the installed version of ape
```
After confirming the ape package is installed and active, set the working directory and import the tree:
```r
#Set the working directory.
setwd("/home/asalvear/Sequences")
getwd()
#Import tree using the ".treefile" file name.
tree <- read.tree("cats_genes.nex.treefile")
```
If the file is read successfully, the tree object will appear in the Environment panel in RStudio (upper right):
<img width="322" height="134" alt="image" src="https://github.com/user-attachments/assets/a648e6e1-f8c9-4a76-bc78-402873c85a54" />

To inspect the taxa present in the tree, the list of tip labels was examined:
```r
tree$tip.label
```
This command prints the names of all taxa included in the tree, which can be used to identify appropriate outgroup taxa:
<img width="540" height="322" alt="image" src="https://github.com/user-attachments/assets/c94e2c8a-d8ec-401f-ba13-931f70bda330" />

An outgroup was specified by assigning the corresponding tip label. For a single outgroup:
```r
#Use the name of the outgroup exactly as listed using tree$tip.label
outgroups <- "034_Nandinia_binotata"
```
If multiple outgroups are available, they can be specified as:
```r
#Names must be exactly as listed using tree$tip.label
#"c()" must be used to group all outgroups separated by commas
outgroups <- c("034_Nandinia_binotata", "033_Manis_tricuspis", "025_Hyaena_hyaena", "011_Canis_lupus", "004_Arctogalidia_trivirgata")
```
The tree was rooted using the most distantly related outgroup. For the sample dataset, Manis tricuspis was selected because it is the only non-carnivoran mammal included and represents the sister lineage to Carnivora.
```r
#Name of the outgroup used for rooting needs to match the name as listed using tree$tip.label
t1 <- root(tree, outgroup = "033_Manis_tricuspis", resolve.root = TRUE)
```
Once the tree is rooted, ape can add bootstrap values to the tree. To inspect bootstrap support values associated with internal nodes:
```r
t1$node.label
```
Plot the tree adding bootstrap values, displaying only values ≥ 70%:
```r
plot(ladderize(t1), cex = 0.6)
nodelabels(
  text = ifelse(as.numeric(t1$node.label) >= 70, t1$node.label, ""),
   #The numeric value represents the minimum bootstrap value displayed.
  cex = 0.5,
  frame = "n",
  adj = c(1.25, -0.75)
   #Numeric values control the offset of bootstrap labels and can be adjusted for visual clarity.
)
add.scale.bar()
```
Once plotted, the tree can be previewed in the bottom right panel of RStudio:
<img width="975" height="438" alt="image" src="https://github.com/user-attachments/assets/9ac9bc88-5eb6-4f7a-bbe6-39b0e6d392ee" />

The rooted and annotated tree was exported as a PDF using the following commands:

```r
pdf("cats_rooted_tree.pdf", width = 8, height = 10) #Assign a name for the output file.
plot(ladderize(t1), cex = 0.6)
nodelabels(
  text = ifelse(as.numeric(t1$node.label) >= 70, t1$node.label, ""), #Minimum node label value
  cex = 0.5,
  frame = "n",
  adj = c(1.25, -0.75) # adjust to improve label placement/clarity #Node label offset
)
add.scale.bar()
dev.off()
```
The output file ([`cats_rooted_tree.pdf`](Files/R_Output/cats_rooted_tree.pdf)) will be saved in the current working directory. The rooted tree can also be used with other tools or R packages for further editing.
