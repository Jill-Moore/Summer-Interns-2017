#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to run fimo on the sequences, filter by q-value, and sort into bins

# Prompt the user to enter the name of the cell type, sequence file and the meme file
if [ $# != 3 ]
then
	echo Please enter the name of the cell type, the file containing the peak sequences and the file containing the motifs, in that order.
	exit
fi

# Strip the ".meme" extension from the MEME file (to isolate just the name of the motif)
motif=`basename ./$3 .meme`

# Make the necessary directories
mkdir ./$1-$motif-results
mkdir ./$1-$motif-results/FIMO

# Run FIMO
fimo -oc ./$1-$motif-results/FIMO $3 $2

# Find the number of lines in fimo.txt
numberOfLines=`wc -l ./$1-$motif-results/FIMO/fimo.txt | cut -f 1 -d ' '`
# Subtract one
minusOne=$(( $numberOfLines - 1 ))
mv ./$1-$motif-results/FIMO/fimo.txt ./$1-$motif-results/FIMO/file.txt
# Remove the header from fimo.txt
tail -$minusOne ./$1-$motif-results/FIMO/file.txt > ./$1-$motif-results/FIMO/fimo.txt

# Get data from the resulting fimo.txt file
awk '{print $2}' ./$1-$motif-results/FIMO/fimo.txt > listOfPeaks.txt
awk '{print $8}' ./$1-$motif-results/FIMO/fimo.txt > qvalues.txt

# Filter the data by q-value < 0.05
python filterQvalue.py

# Organize: Move the files to the correct folder
mv fimo_filtered.txt ./$1-$motif-results/
mv listOfPeaks.txt ./$1-$motif-results/
mv qvalues.txt ./$1-$motif-results/

# Isolate only the column of unique peaks
awk '{print $1}' ./$1-$motif-results/fimo_filtered.txt | sort | uniq > uniquePeaks.txt
# Isolate only the peak ID numbers for easier sorting into bins
cut -d "_" -f 6 uniquePeaks.txt > num.txt
# Sort the peak ID numbers in ascending order
cat num.txt | sort -n > ./$1-$motif-results/peakNumbers.txt 

# Clean up
rm num.txt
rm uniquePeaks.txt

