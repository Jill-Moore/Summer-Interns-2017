#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to run fimo on the sequences, filter by q-value, and determine the number of peaks which have a particular motif or TF.

# Prompt the user to enter the name of the cell type and the sequence file 
if [ $# != 2 ]
then
	echo Please enter the name of the cell type and the file containing the peak sequence, in that order.
	exit
fi

# Make the necessary directories
mkdir ./$1-results
mkdir ./$1-results/FIMO

# Run FIMO
fimo -oc ./$1-results/FIMO CisBP-TF.meme $2

# Find the number of lines in fimo.txt
numberOfLines=`wc -l ./$1-results/FIMO/fimo.txt | cut -f 1 -d ' '`
# Subtract one
minusOne=$(( $numberOfLines - 1 ))
mv ./$1-results/FIMO/fimo.txt ./$1-results/FIMO/file.txt
# Remove the header from fimo.txt
tail -$minusOne ./$1-results/FIMO/file.txt > ./$1-results/FIMO/fimo.txt

# Get data from the resulting fimo.txt file
awk '{print $1}' ./$1-results/FIMO/fimo.txt > listOfMotifs_all.txt
awk '{print $2}' ./$1-results/FIMO/fimo.txt > listOfPeaks_all.txt
awk '{print $8}' ./$1-results/FIMO/fimo.txt > qvalues_all.txt

# Filter the data by q-value < 0.05
python filterQvalue.py

# Organize: Move the files to the correct folder
mv fimo_filtered.txt ./$1-results/
mv listOfMotifs_all.txt ./$1-results/
mv listOfPeaks_all.txt ./$1-results/
mv qvalues_all.txt ./$1-results/

## For Motifs

# Isolate the columns of the filtered fimo.txt file
awk '{print $1}' ./$1-results/fimo_filtered.txt > listOfMotifs_filtered.txt
awk '{print $2}' ./$1-results/fimo_filtered.txt > listOfPeaks_filtered.txt

# Find the number of peaks that contain a certain motif, for each motif
python motif_finder.py

# Find the number of output files
numberOfFiles=`ls ./results* | wc -l`
# Subtract one
limit=$(( numberOfFiles - 1 ))

# Make a new temporary directory
mkdir folder

# Create a text file with all of the file names
ls results* > fileNames.txt

# Create an array
list=( `cat "fileNames.txt" `)

# Renumber the files, in ascending order
for i in $(seq 0 $limit)
do
	mv ./${list[$i]} ./folder/results$i.txt
done

# Find the number of unique peaks for each motif
for i in $(seq 0 $limit)
do
	awk '{print $1}' ./folder/results$i.txt | head -1 >> orderOfMotifs.txt
	awk '{print $2}' ./folder/results$i.txt | sort | uniq | wc -l >> numPeaksPerMotif.txt
done

# Organize the results
pr -mts orderOfMotifs.txt numPeaksPerMotif.txt > file1.txt
column -t file1.txt > file2.txt
sort file2.txt > ./$1-results/finalResult-Motif.txt

# Clean up
rm -r folder
rm orderOfMotifs.txt
rm numPeaksPerMotif.txt
rm file1.txt
rm file2.txt

## For TFs

# Find the TFs which have q-values less than 0.05
sed 's/@.*//' ./$1-results/fimo_filtered.txt > listOfTFs_filtered.txt

# Find the number of peaks that contain a certain TF, for each TF
python tf_finder.py

# Find the number of output files
numberOfFiles=`ls ./results* | wc -l`
# Subtract one
limit=$(( numberOfFiles - 1 ))

# Make a new temporary directory
mkdir folder

# Create a text file with all of the file names
ls results* > fileNames.txt

# Create an array
list=( `cat "fileNames.txt" `)

# Renumber the files, in ascending order
for i in $(seq 0 $limit)
do
        mv ./${list[$i]} ./folder/results$i.txt
done

# Find the number of unique peaks for each TF
for i in $(seq 0 $limit)
do
        awk '{print $1}' ./folder/results$i.txt | head -1 >> orderOfTFs.txt
        awk '{print $2}' ./folder/results$i.txt | sort | uniq | wc -l >> numPeaksPerTF.txt
done

# Organize the results
pr -mts orderOfTFs.txt numPeaksPerTF.txt > file1.txt
column -t file1.txt > file2.txt
sort file2.txt > ./$1-results/finalResult-TF.txt

# Clean up
rm -r folder
rm orderOfTFs.txt
rm numPeaksPerTF.txt
rm file1.txt
rm file2.txt
rm fileNames.txt

# Organize: Move the files to the correct folder
mv listOfMotifs_filtered.txt ./$1-results/
mv listOfPeaks_filtered.txt ./$1-results/
mv listOfTFs_filtered.txt ./$1-results/
