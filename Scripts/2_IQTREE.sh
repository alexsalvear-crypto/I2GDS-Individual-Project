#!/usr/bin/env bash
set -euo pipefail

# IQ-TREE phylogenetic inference
# Working directory is the same as in steps 01–02: data/sequences/
# Requires: CO1_aln.fasta, CytB_aln.fasta, ND1_aln.fasta
# Produces: .treefile and other IQ-TREE outputs

module load IQ-TREE/2.3.6-gompi-2023a

echo "IQ-TREE path: $(which iqtree2 || true)"
iqtree2 --version
module list || true

SEQ_DIR="data/sequences"
cd "$SEQ_DIR"

# Make partitions file (NEXUS sets format expected by -p)
PARTS="cats_genes.nex"
cat > "$PARTS" << 'EOF'
#NEXUS
begin sets;
  charset CO1  = CO1_aln.fasta;
  charset CytB = CytB_aln.fasta;
  charset ND1  = ND1_aln.fasta;
end;
EOF

echo "Partitions file:"
ls -lh "$PARTS"

# Run IQ-TREE2
# -p: partitions file
# -B 1000: ultrafast bootstrap with 1000 replicates
# -nt AUTO: auto-detect threads
iqtree2 -p "$PARTS" -B 1000 -nt AUTO

echo "Done: IQ-TREE phylogenetic inference"
