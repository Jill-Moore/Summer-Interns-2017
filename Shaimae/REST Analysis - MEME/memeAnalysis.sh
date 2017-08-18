#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to run MEME on 6 different REST ChIP-seq data sets (A549, GM12878, H1-hESC, HEK293, K562 Myers, & K562 Snyder) to find de novo motifs and determine quality of data sets

# Prompt the user to enter the name of the cell type and the sequence file
if [ $# != 2 ]
then
	echo Please enter the name of the cell type and the file containing the peak sequences, in that order.
	echo If a message is printed saying "Dataset is too large", change maxsize within the script. 
	exit
fi

# Run MEME
meme -oc ./$1results/ $2 -dna -mod zoops -nmotifs 3 -minw 6 -maxw 30 -revcomp -maxsize 10000000

# Next step:
# - scp meme.html file (and logos, if desired) to your Desktop
# - View information about each de novo motif (# occurrences, width, E-value, etc.) by opening the .html file
# - Submit each motif through TOMTOM to determine the identity of the TF which contains that motif
