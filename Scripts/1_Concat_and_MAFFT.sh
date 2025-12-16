#!/usr/bin/env bash
set -euo pipefail

# Concatenate FASTA files per gene and align with MAFFT
# Input & output directory: data/sequences/
# Example input files: *ND1*.fasta, *CytB*.fasta, *CO1*.fasta
# Outputs:
#   CO1_all.fasta -> CO1_aln.fasta
#   CytB_all.fasta -> CytB_aln.fasta
#   ND1_all.fasta -> ND1_aln.fasta


# Load MAFFT module
module load MAFFT/7.526-GCC-13.2.0-with-extensions

echo "MAFFT path: $(which mafft)"
mafft --version
module list || true

# Working directory is the same for input & output
SEQ_DIR="data/sequences"
cd "$SEQ_DIR"

# Concatenate FASTA files per gene
cat *ND1*.fasta > ND1_all.fasta
cat *CytB*.fasta > CytB_all.fasta
cat *CO1*.fasta > CO1_all.fasta

echo "Concatenated FASTAs:"
ls -lh *_all.fasta

# Align each gene independently
mafft --auto --reorder CO1_all.fasta > CO1_aln.fasta
mafft --auto --reorder CytB_all.fasta > CytB_aln.fasta
mafft --auto --reorder ND1_all.fasta > ND1_aln.fasta

echo "Aligned FASTAs:"
ls -lh *_aln.fasta

# Sanity check: number of sequences must match
echo "Sequence count checks (headers):"
echo "CO1 input:"   && grep -c '^>' CO1_all.fasta
echo "CO1 aligned:" && grep -c '^>' CO1_aln.fasta
echo "CytB input:"  && grep -c '^>' CytB_all.fasta
echo "CytB aligned:"&& grep -c '^>' CytB_aln.fasta
echo "ND1 input:"   && grep -c '^>' ND1_all.fasta
echo "ND1 aligned:" && grep -c '^>' ND1_aln.fasta

echo "Done: concatenation + MAFFT alignments."
