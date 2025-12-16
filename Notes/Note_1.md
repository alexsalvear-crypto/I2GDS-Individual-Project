#Note to Self 1: Naming conventions for FASTA files.

FASTA file names must remain consistent and should always include: the gene name, the species name, and a unique specimen identifier.
Following this convention ensures that sequences can be concatenated and aligned using only a small number of commands, without the need for manual editing.

FASTA headers must not include the gene name. Including gene names in FASTA headers will cause errors because IQ-TREE interprets each unique header as a separate terminal taxon, treating different genes from the same specimen as independent leaves in the tree. To prevent this, all FASTA files corresponding to the same specimen must use exactly the same header, containing only the specimen identifier and species name. Headers should use underscores as separators and must not include spaces or any other special characters. The gene name should appear only in the file name and never in the FASTA header.

Example:
<img width="989" height="458" alt="image" src="https://github.com/user-attachments/assets/fc7625cd-082d-4ff6-8490-d12513386c4e" />

If several FASTA files need to be edited to match these parameters, software such as [BBEdit](https://www.barebones.com/products/bbedit/), or other tools can be used to edit FASTA files in bulk.
