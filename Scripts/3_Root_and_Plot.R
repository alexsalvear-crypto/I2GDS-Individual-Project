# Root and plot IQ-TREE tree in R (ape)
# Working directory is the same as in steps 01–03: data/sequences/
# Input:  cats_genes.nex.treefile  (IQ-TREE output)
# Output: cats_rooted_tree.pdf

library(ape)

# Confirm ape is available
packageVersion("ape")

# Use the same single directory as earlier steps
SEQ_DIR <- file.path("data", "sequences")
stopifnot(dir.exists(SEQ_DIR))
setwd(SEQ_DIR)

# Read the IQ-TREE treefile
treefile <- "cats_genes.nex.treefile"
stopifnot(file.exists(treefile))
tree <- read.tree(treefile)

# Inspect tip labels to choose outgroups
tree$tip.label

# Outgroup selection (replace examples with your taxa)
# Names must match exactly what's printed in tree$tip.label
# Use c(...) to list multiple outgroups.
outgroups <- c(
  "Outgroup_Example_1",
  "Outgroup_Example_2",
  "Outgroup_Example_3",
  "Outgroup_Example_4",
  "Outgroup_Example_5"
)

# Rooting requires choosing a taxon as the outgroup.
root_tip <- "Outgroup_Example_2"

# Safety checks so the script fails loudly if names don't match
if (!root_tip %in% tree$tip.label) {
  stop("Root tip not found in tree$tip.label: ", root_tip)
}

# Root the tree
t1 <- root(tree, outgroup = root_tip, resolve.root = TRUE)

# Plot and export PDF
pdf("cats_rooted_tree.pdf", width = 8, height = 10)

plot(ladderize(t1), cex = 0.6)

nodelabels(
  text = ifelse(as.numeric(t1$node.label) >= 70, t1$node.label, ""),
  cex = 0.5,
  frame = "n",
  adj = c(1.25, -0.75)
)

add.scale.bar()
dev.off()

cat("Done: rooted tree plotted to cats_rooted_tree.pdf\n")
