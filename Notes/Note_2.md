# Note to Self 2: FASTA file formatting.

FASTA files must end with a newline. If a FASTA file does not include a newline at the end of the file, concatenation tools may interpret multiple input files as a single continuous string rather than separate sequences. When this happens, concatenated FASTA files appear to have 0 to 1 sequence and IQ-TREE will not run properly.

This issue does not generate an error message. But when 
